//
//  Deck.h
//  Matchismo
//
//  Created by Peter Reveles on 3/27/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
