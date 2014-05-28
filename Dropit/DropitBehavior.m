//
//  DropitBehavior.m
//  Dropit
//
//  Created by Peter Reveles on 5/13/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior ()
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
@end

@implementation DropitBehavior

- (UIDynamicBehavior *)gravity{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
    }
    return _gravity;
}

- (UICollisionBehavior *)collider{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // set up
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collider];
    }
    return self;
}

- (void)addItem:(id <UIDynamicItem>)item{
    [self.gravity addItem:item];
    [self.collider addItem:item];
}

- (void)removeItem:(id <UIDynamicItem>)item{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
}



@end
