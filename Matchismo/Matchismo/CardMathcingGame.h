//
//  CardMathcingGame.h
//  Matchismo
//
//  Created by Peter Reveles on 3/28/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMathcingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;

@end
