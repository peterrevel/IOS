//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Peter Reveles on 4/27/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture; 

@end
