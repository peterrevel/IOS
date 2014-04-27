//
//  SetCard.m
//  Matchismo
//
//  Created by Peter Reveles on 4/25/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "SetCard.h"

@interface SetCard ()
@property(nonatomic, strong) NSString *shape;
@property(nonatomic) NSNumber *number;
@property(nonatomic, strong) NSString *shade;
@property(nonatomic, strong) UIColor *color;
@end

@implementation SetCard

- (instancetype)initWithShape:(NSString *)shape number:(NSNumber *)number shade:(NSString *)shade color:(UIColor *)color{
    self = [super init];
    if (self) {
        if ([[SetCard validShapes] containsObject:shape] &&
            [[SetCard validNumbers] containsObject:number] &&
            [[SetCard validShades] containsObject:shade] &&
            [[SetCard validColors] containsObject:color]) {
            _color = color;
            _shade = shade;
            _shape = shape;
            _number = number;
        }
    }
    return self;
}

#pragma mark - Fucntionality Methods

- (BOOL)isValidSet:(NSSet *)set{
    BOOL response;
    if ([set count] == 3 || [set count] == 1) {
        response = YES;
    } else {
        response = NO;
    }
    NSLog(@"Set is of size: %lu", [set count]);
    return response;
}

- (int)match:(NSArray *)otherCards{
    int score = 0;
    
    NSMutableSet *colors = [[NSMutableSet alloc] initWithObjects:self.color, nil];
    NSMutableSet *shapes = [[NSMutableSet alloc] initWithObjects:self.shape, nil];
    NSMutableSet *numbers = [[NSMutableSet alloc] initWithObjects:self.number, nil];
    NSMutableSet *shades = [[NSMutableSet alloc] initWithObjects:self.shade, nil];
    for (id obj in otherCards) {
        if ([obj isMemberOfClass:[SetCard class]]) {
            SetCard *card = (SetCard *)obj;
            [colors addObject:card.color];
            [shapes addObject:card.shape];
            [shades addObject:card.shade];
            [numbers addObject:card.number];
        }
    }
    
    if ([self isValidSet:colors] &&
        [self isValidSet:numbers] &&
        [self isValidSet:shades] &&
        [self isValidSet:shapes]) {
        score = 5;
    }
    NSLog(@"---------");
    return score;
}

- (NSString *)contents{
    return nil;
}

#pragma mark - Class Methods

+ (NSArray *)validColors{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
}

+ (NSArray *)validShapes{
    return @[@"▲", @"●", @"■"];
}

+ (NSArray *)validShades{
    return @[@"open", @"shaded", @"solid"];
}

+ (NSArray *)validNumbers{
    return @[@1, @2, @3];
}

@end
