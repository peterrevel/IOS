//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Peter Reveles on 4/26/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"
#import "Card.h"

@implementation SetCardDeck

- (instancetype)init{
    self = [super init];
    
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSNumber *number in [SetCard validNumbers]) {
                for (UIColor *color in [SetCard validColors]) {
                    for (NSString *shade in [SetCard validShades]) {
                        SetCard *card = [[SetCard alloc] initWithShape:shape number:number shade:shade color:color];
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
