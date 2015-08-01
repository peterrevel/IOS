//
//  ViewController.h
//  PRButtonAnimations
//
//  Created by Peter Reveles on 7/2/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRPresentationViewController : UIViewController

- (void)pushButtonToPresentationChain:(UIButton *)button;
- (void)popButtonFromPresentationChain:(UIButton *)button;

- (void)presentButtonsToPoint:(CGPoint)point;

@end

