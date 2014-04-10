//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Peter Reveles on 3/22/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMathcingGame.h"

@interface CardGameViewController ()
@property (nonatomic, strong) CardMathcingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegControl;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (nonatomic, strong) NSString *historyMessage;
@property (nonatomic) NSInteger scoreOnDisplay;
@property (nonatomic, strong) Card *previousCard;
@property (nonatomic, strong) NSMutableArray *historyMessages;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

# pragma mark Accessor Methods

- (CardMathcingGame *)game{
    if (!_game) _game = [[CardMathcingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (NSString *)historyMessage{
    return _historyMessage ? _historyMessage : @"";
}

- (NSMutableArray *)historyMessages{
    if (!_historyMessages) _historyMessages = [[NSMutableArray alloc] init];
    return _historyMessages;
}

# pragma mark Functionality Methods

- (IBAction)touchCardButton:(UIButton *)sender {
    int index = (int)[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self loadHistoryMessageForCardAtIndex:index];
    self.historySlider.enabled = YES;
    [self updateUIWithSegControlEnabled:NO];
}

- (IBAction)dealAgain {
    self.game = nil;
    self.historyMessage = @"";
    self.historySlider.enabled = NO;
    self.historyMessages = nil;
    self.scoreOnDisplay = 0;
    [self updateUIWithSegControlEnabled:YES];
}

# pragma mark User Interface

- (IBAction)toggleMatchMode:(UISegmentedControl *)sender {
    // The game mode should really only be updatable upon
    // the creation of a new game
    NSInteger matchMode = [sender selectedSegmentIndex] + 2;
    [self.game setCardsToMatch:matchMode];
}

- (void)updateUIWithSegControlEnabled:(BOOL)enabled{
    if (enabled) {
        self.gameModeSegControl.enabled = YES;
    } else {
        self.gameModeSegControl.enabled = NO;
    }
    [self updateUI];
}

- (void)updateUI{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int)[self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMathced;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    self.scoreOnDisplay = self.game.score;
    self.historyLabel.text = self.historyMessage;
    [self.historyLabel setAlpha:1.0];
    // after message was displayed, push it onto the array of messages
    if (![self.historyMessage isEqualToString:@""]) {
        [self.historyMessages addObject:self.historyMessage];
        [self.historySlider setMaximumValue:[self.historyMessages count]];
        self.historySlider.value = self.historySlider.maximumValue;
    }
}

- (IBAction)sliderThroughHistory:(UISlider *)sender {
    if (ceil(sender.value) == sender.maximumValue) {
        [self.historyLabel setAlpha:1.0];
    } else {
        [self.historyLabel setAlpha:0.5];
    }
    int messageIndex = floor(sender.value);
    if (sender.value == sender.maximumValue) {
        messageIndex--;
    }
    self.historyLabel.text = [self.historyMessages objectAtIndex:messageIndex];
}

# pragma mark Back End

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card{
    return (card.isChosen) ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}


// doesnt work in the following cases:
// 1. Mismatch
// 2. Card deselected way back in history
- (void)loadHistoryMessageForCardAtIndex:(NSInteger)index{
    // clear out old message if there was a match or mismatch
    NSRange containsMissMatchMessage = [self.historyMessage rangeOfString:@"don't Match"];
    NSRange containsMatchMessage = [self.historyMessage rangeOfString:@"Matched"];
    if (containsMissMatchMessage.location == NSNotFound) {
        // If their was a mismatch, bring up the last card's contents
        self.historyMessage = [self.previousCard contents];
    } else if (containsMatchMessage.location == NSNotFound) {
        self.historyMessage = @"";
    }
    
    Card *card = [self.game cardAtIndex:index];
    NSRange range = [self.historyMessage rangeOfString:[card contents]];
    if (range.location == NSNotFound) {
        //Card not found in historyMessage
        if ([[self.game cardAtIndex:index] isChosen]) {
            self.historyMessage = [self.historyMessage stringByAppendingString:[[self.game cardAtIndex:index] contents]];
        }
    } else {
        // Card is already in the historyMessage, it must be removed
        self.historyMessage = [[self.historyMessage substringToIndex:range.location] stringByAppendingString:[self.historyMessage substringFromIndex:(range.location + range.length)]];
    }
    
    NSInteger scoreDelta = self.game.score - self.scoreOnDisplay;
    if (scoreDelta > 0) {
        // A match was found
        self.historyMessage = [self.historyMessage stringByAppendingString:[NSString stringWithFormat:@" Matched! (+%ld pts)", scoreDelta]];
    } else if(scoreDelta < -1) {
        // A mismatch occured
        self.historyMessage = [self.historyMessage stringByAppendingString:[NSString stringWithFormat:@" don't Match. (%ld pts)", scoreDelta]];
    }
    self.previousCard = card;
}

@end
