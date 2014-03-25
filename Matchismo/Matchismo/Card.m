//
//  Card.m
//  Matchismo
//
//  Created by Peter Reveles on 3/25/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "Card.h"

@interface Card ()

@end

@implementation Card

- (int)match:(NSArray *)otherCard{
    int score = 0;
    
    for (Card *card in otherCard) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
