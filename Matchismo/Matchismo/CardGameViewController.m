//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Peter Reveles on 3/22/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "CardGameViewController.h"
#import "Card.h"
#import "HistoryDisplayViewController.h"
#import "CardMathcingGame.h"

@interface CardGameViewController ()
@property (nonatomic, strong) CardMathcingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (nonatomic) NSInteger scoreOnDisplay;
@property (nonatomic, strong) Card *previousCard;
@property (nonatomic, strong) NSMutableArray *historyMessages;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@end

@implementation CardGameViewController

# pragma mark - LifeCycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Display History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryDisplayViewController class]]) {
            HistoryDisplayViewController *hdvc = (HistoryDisplayViewController *)segue.destinationViewController;
            [hdvc setHistoryText:self.historyMessages];
            [hdvc setBackgroundColor:self.view.backgroundColor];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Score: 0";
}

# pragma mark - Accessor Methods

- (CardMathcingGame *)game{
    if (!_game) _game = [[CardMathcingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]
                                                       cardsToMatch:[self cardsToMatch]];
    return _game;
}

- (NSMutableArray *)historyMessages{
    if (!_historyMessages) _historyMessages = [[NSMutableArray alloc] init];
    return _historyMessages;
}

# pragma mark Functionality Methods

- (IBAction)touchCardButton:(UIButton *)sender {
    int index = (int)[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self pushMoveMessageOntoHistoryStackForCardAtIndex:index];
    [self updateUI];
}

- (IBAction)dealAgain {
    self.game = nil;
    self.historyMessages = nil;
    self.scoreOnDisplay = 0;
    [self updateUI];
}

# pragma mark - User Interface

- (void)updateUI{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int)[self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMathced;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    self.scoreOnDisplay = self.game.score;
    self.historyLabel.attributedText = [self.historyMessages lastObject];
}

# pragma mark - Back End

- (Deck *)createDeck{ // abstract
    return nil;
}

- (NSInteger)cardsToMatch{
    return 0;
}

- (NSAttributedString *)titleForCard:(Card *)card{
    return (card.isChosen) ? [[NSAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}] : nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

- (void)pushMoveMessageOntoHistoryStackForCardAtIndex:(NSInteger)index{
    return;
}

/*
- (void)loadHistoryMessageForCardAtIndex:(NSInteger)index{
    // clear out old message if there was a match or mismatch
    NSRange containsMissMatchMessage = [self.historyMessage rangeOfString:@"don't Match"];
    NSRange containsMatchMessage = [self.historyMessage rangeOfString:@"Matched"];
    if (containsMissMatchMessage.location != NSNotFound) {
        // If their was a mismatch, bring up the last card's contents
        self.historyMessage = [self.previousCard contents];
    } else if (containsMatchMessage.location != NSNotFound) {
        self.historyMessage = @"";
    }
    
    Card *card = [self.game cardAtIndex:index];
    NSRange range = [self.historyMessage rangeOfString:[card contents]];
    if (range.location == NSNotFound) {
        // Card not already in historyMessage
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
    
    // after message was displayed, push it onto the array of messages
    if (![self.historyMessage isEqualToString:@""]) {
        [self.historyMessages addObject:self.historyMessage];
    }
}
 */

@end
