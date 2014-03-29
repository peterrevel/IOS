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
            // match against another card
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMathced) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        card.mathced = YES;
                        otherCard.mathced = YES;
                    } else{
                        otherCard.chosen = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
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
