//
//  SetCard.h
//  Matchismo
//
//  Created by Peter Reveles on 4/25/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

- (instancetype)initWithShape:(NSString *)shape number:(NSNumber *)number shade:(NSString *)shade color:(UIColor *)color;

@property(nonatomic, readonly) NSString *shape;
@property(nonatomic, readonly) NSNumber *number;
@property(nonatomic, readonly) NSString *shade;
@property(nonatomic, readonly) UIColor *color;

- (int)match:(NSArray *)otherCards;

+ (NSArray *)validColors;
+ (NSArray *)validShapes;
+ (NSArray *)validShades;
+ (NSArray *)validNumbers;

@end
