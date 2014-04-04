//
//  CardMathcingGame.m
//  Matchismo
//
//  Created by Peter Reveles on 3/28/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "CardMathcingGame.h"

@interface CardMathcingGame ()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of card
@end

@implementation CardMathcingGame

#define MISMATCH_PENALTY 2;
#define MATCH_BONUS 4;
#define COST_TO_CHOOSE 1;

- (NSMutableArray *)cards{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    if (self) {
        // default to matching 2 cards
        self.cardsToMatch = 2;
        // load cards
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index{
    
    Card *card = [self cardAtIndex:index];
     
    if (!card.isMathced) {
        if (card.isChosen) {
            card.chosen = NO;
        } else{
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            // match against another card
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMathced) {
                    [otherCards addObject:otherCard];
                }
                if ([otherCards count] == self.cardsToMatch - 1) {
                    break;
                }
            }
            
            // max amount of cards have been chosen, time to compare
            if ([otherCards count] == self.cardsToMatch - 1) {
                int matchScore = [card match:otherCards];
                
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    card.mathced = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.mathced = YES;
                    }
                } else{
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
