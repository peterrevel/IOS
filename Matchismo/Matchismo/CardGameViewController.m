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
@end

@implementation CardGameViewController

# pragma mark Accessor Methods

- (CardMathcingGame *)game{
    if (!_game) _game = [[CardMathcingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

# pragma mark Functionality Methods

- (IBAction)touchCardButton:(UIButton *)sender {
    int index = (int)[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUIWithSegControlEnabled:NO];
}

- (IBAction)dealAgain {
    self.game = nil;
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

@end
