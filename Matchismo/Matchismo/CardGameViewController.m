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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (nonatomic) NSInteger scoreOnDisplay;
@property (nonatomic, strong) NSMutableOrderedSet *cardsAtPlay; // of card
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

- (NSMutableOrderedSet *)cardsAtPlay{
    if (!_cardsAtPlay) _cardsAtPlay = [[NSMutableOrderedSet alloc] init];
    return _cardsAtPlay;
}

# pragma mark Functionality Methods

- (void)addToPlaySetCardAtIndex:(NSInteger)index{
    Card *card = [self.game cardAtIndex:index];
    if ([self.cardsAtPlay containsObject:card]) {
        [self.cardsAtPlay removeObject:card];
    } else {
        [self.cardsAtPlay addObject:card];
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int index = (int)[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self addToPlaySetCardAtIndex:index];
    [self pushMoveMessageOntoHistoryMessagesForCardAtIndex:index];
    [self updateUI];
}

- (IBAction)dealAgain {
    self.game = nil;
    self.historyMessages = nil;
    self.cardsAtPlay = nil;
    self.scoreOnDisplay = 0;
    [self updateUI];
}

# pragma mark - User Interface

- (void)updateUI{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int)[self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setAttributedTitle:[self titleForCard:card byPass:NO] forState:UIControlStateNormal];
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

- (NSAttributedString *)titleForCard:(Card *)card byPass:(BOOL)byPass{
    return (card.isChosen || byPass) ? [[NSAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}] : nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

- (NSAttributedString *)cardsAtPlayContents{
    NSMutableAttributedString *contents = [[NSMutableAttributedString alloc] init];
    for (Card *card in self.cardsAtPlay) {
        [contents appendAttributedString:[self titleForCard:card byPass:YES]];
    }
    return contents;
}

- (NSString *)didTheUserScore{
    NSInteger scoreDelta = self.game.score - self.scoreOnDisplay;
    if (scoreDelta > 0) {
        // A match was found
        [self.cardsAtPlay removeAllObjects];
        return [NSString stringWithFormat:@" Matched! (+%ld pts)", scoreDelta];
    } else if(scoreDelta < -1) {
        // A mismatch occured
        [self.cardsAtPlay removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.game.cardsToMatch - 1)]];
        return [NSString stringWithFormat:@" don't match. (%ld pts)", scoreDelta];
    }
    return @"";
}

- (void)pushMoveMessageOntoHistoryMessagesForCardAtIndex:(NSInteger)index{
    NSMutableAttributedString *moveMessage = [[NSMutableAttributedString alloc] init];
    
    if ([self.cardsAtPlay count] == self.game.cardsToMatch) {
        [moveMessage appendAttributedString:[self cardsAtPlayContents]];
        [moveMessage appendAttributedString:[[NSAttributedString alloc] initWithString:[self didTheUserScore]]];
        
    } else if ([self.cardsAtPlay count]) {
        [moveMessage appendAttributedString:[self cardsAtPlayContents]];
    }
    
    [self.historyMessages addObject:moveMessage];
}

@end
