//
//  ViewController.m
//  circleScrollView
//
//  Created by Peter Reveles on 10/19/13.
//  Copyright (c) 2013 Peter Reveles. All rights reserved.
//

#import "ViewController.h"
#import "PRCircleScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

#define degree_to_radians(angle) (angle)*(M_PI/180.0f)
#define radians_to_degrees(angle) (angle)*(180.0f/M_PI)

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Set up the circleScrollView
    self.circleScrollView.withCWBound = YES;
    self.circleScrollView.CWBound = degree_to_radians(0);
    self.circleScrollView.withCCWBound = YES;
    self.circleScrollView.CCWBound = degree_to_radians(-360);
    // set to 0 if no min distance desired
    self.circleScrollView.minimumDistanceFromCenter = 200.0f;
    self.circleScrollView.willCarousel = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Screen touched.");
    
}

@end
