//
//  DropitBehavior.h
//  Dropit
//
//  Created by Peter Reveles on 5/13/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
