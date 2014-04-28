//
//  Card.h
//  Matchismo
//
//  Created by Peter Reveles on 3/25/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMathced) BOOL mathced;

- (int)match:(NSArray *)otherCard;

@end
