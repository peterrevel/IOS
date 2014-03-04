//
//  PRCircleScrollView.h
//  circleScrollView
//
//  Created by Peter Reveles on 10/19/13.
//  Copyright (c) 2013 Peter Reveles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRCircleScrollView : UIView

// bound constaints

@property(nonatomic, assign) BOOL withCWBound;

@property(nonatomic, assign) float CWBound;

@property(nonatomic, assign) BOOL withCCWBound;

@property(nonatomic, assign) float CCWBound;

@property(nonatomic, assign) float minimumDistanceFromCenter;

// special effects

@property(nonatomic, assign) BOOL willCarousel;

@end
