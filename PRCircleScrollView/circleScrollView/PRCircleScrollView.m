//
//  PRCircleScrollView.m
//  circleScrollView
//
//  Created by Peter Reveles on 10/19/13.
//  Copyright (c) 2013 Peter Reveles. All rights reserved.
//

#import "PRCircleScrollView.h"

@interface PRCircleScrollView (){
    float _currentTouchAngle;
    float _previousMovement;
    float _curQuad;
    BOOL _passedCCWBound;
    BOOL _passedCWBound;
    float _curRotationAngle;
}

- (void)defaultInit;

- (float)distanceFromCenter:(CGPoint)point;

- (float)angleBetweenCenterAndPoint:(CGPoint)point;

- (CGPoint)pointRelativeToCenter:(CGPoint)point;

- (int)quadrantForPoint:(CGPoint)point;

- (float)computeRotation:(CGPoint) touchPoint;

- (void)carousselSubviews:(float)newAngle;

- (float)enforceBoundaries:(float)angle;

- (void)resetScrollView;

- (void)resetScrollViewFrom:(float)oldValue to:(float)newValue;

@end

@implementation PRCircleScrollView

#define degree_to_radians(angle) (angle)*(M_PI/180.0f)
#define radians_to_degrees(angle) (angle)*(180.0f/M_PI)

// these is the amount of resitence that applied when a user
// attempts to rotate the scroll view past its boundaries
// values in the negative direction provide greater resistance
// I've set them to values which provide the most natural user experience
// based on trial and error
#define _CCWweight 15
#define _CWweight 5

// The amount of time it takes for the circleScrollView to reset
// after its been rotated past its boundary and let go
#define _resetTime 0.5f

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit{
	// set variables to default values
    _withCWBound = YES;
    _CWBound = degree_to_radians(0);
    _withCCWBound = NO;
    _willCarousel = YES;
    _minimumDistanceFromCenter = 200.0f;
}

- (float)distanceFromCenter:(CGPoint)point{
	float a = point.x;
	float b = point.y;
	return (a*a + b*b);
}

// returns angle in radians
- (float)angleBetweenCenterAndPoint:(CGPoint)point{
	return atan2f(point.y, point.x);
}

// the touchPoint is taken relative to the superview
// this function adjust the point so its origin is the
// center of this view
- (CGPoint)pointRelativeToCenter:(CGPoint)point{
    return CGPointMake((point.x - self.center.x), (self.center.y - point.y));
}

// returns either 1, 2, 3, 4, or (0 for origin)
- (int)quadrantForPoint:(CGPoint)point{
    // returns either 1, 2, 3, 4, or (0 for origin)
    if (point.x>0) {
        if (point.y>0) {
            return 1;
        }
        else if(point.y<0) {
            return 4;
        }
        // positive x but y is on the x-axis - in quad 1
        return 1;
    }
    else if(point.x<0) {
        if (point.y>0) {
            return 2;
        }
        else if(point.y<0) {
            return 3;
        }
        // negative x but y is on the x-axis - in quad 1
        return 2;
    }
    return 0;
}

// returns angle in radians
// this function return the angle the circleScroll
// is currently rotated to
- (float)computeRotation:(CGPoint)touchPoint{
    // current angle is now old angle
    float oldAngle = _currentTouchAngle;

    // grab new angle
    _currentTouchAngle = [self angleBetweenCenterAndPoint:touchPoint];
    
    // compute angle to rotate by
    float desiredMovement = oldAngle - _currentTouchAngle;
    
    // handle special cases since atan2 only returns angles between 0->180degrees
    // when moving from quadrant 2->3:
    // when moving from quadrant 3->2:
    if (_curQuad==2) {
        if ([self quadrantForPoint:touchPoint]==3) {
            desiredMovement = desiredMovement - (2.0f*M_PI);
        }
    } else if (_curQuad==3) {
        if ([self quadrantForPoint:touchPoint]==2) {
            desiredMovement = (2.0f*M_PI) + desiredMovement;
        }
    }
    
    // update the current quadrant
    _curQuad = [self quadrantForPoint:touchPoint];
    
    // add the movement that has already been committed to arrive at newAngle
    float newAngle = desiredMovement + _previousMovement;
    
    // update previous movement to included the desired angle change
    _previousMovement = newAngle;
    
    return newAngle;
}

-(void)carousselSubviews:(float)newAngle{
    
    // Return if there are no subviews
    if ([self.subviews count] == 0) return;
    
    // rotate each subview in the opposite/negative direction
    for (UIView *subview in self.subviews) {
        subview.layer.transform = CATransform3DMakeRotation(-newAngle, 0, 0, 1);
    }
}

-(float)enforceBoundaries:(float)angle{
    // if there's a CWBound, and if the angle passes the ClockWise(CW) boundary
    if (self.withCWBound && (angle > self.CWBound)) {
        // if the angle passes the boundary, apply the exponential decay function on it as punishment
        angle = angle*exp(-angle/_CWweight);
        _passedCWBound = YES;
    }
    else{
        _passedCWBound = NO;
    }
    // if there's a CCWBound, and if the angle passes the CounterClockWise(CCW) boundary
    if (self.withCCWBound && (angle < self.CCWBound)) {
        // if the angle passes the boundary, apply the exponential decay function on it as punishment
        angle = angle*exp(((-1 * self.CCWBound)+angle)/_CCWweight);
        _passedCCWBound = YES;
    }
    else{
        _passedCCWBound = NO;
    }
    return angle;
}

- (void)resetScrollView{
    if (_passedCWBound) {
        [self resetScrollViewFrom:_curRotationAngle to:self.CWBound];
        //reset previous movement to the its last legal value, strange things happen if you don't
        _previousMovement = self.CWBound;
    }
    if (_passedCCWBound) {
        [self resetScrollViewFrom:_curRotationAngle to:self.CCWBound];
        //reset previous movement to the its last legal valu, strange things happen if you don't
        _previousMovement = self.CCWBound;
    }
}

- (void)resetScrollViewFrom:(float)oldValue to:(float)newValue{
    // prepare animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.duration = _resetTime;
    
    animation.values = @[[NSNumber numberWithFloat:oldValue],
                         [NSNumber numberWithFloat:(newValue + oldValue)/2.0f],
                         [NSNumber numberWithFloat:newValue]];
    
    animation.keyTimes = @[@0.0f,
                           @0.5f,
                           @1.0f];
    
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    // set animation to circleScrollView
    [self.layer addAnimation:animation forKey:nil];
    // commit rotation
	self.layer.transform = CATransform3DMakeRotation(newValue, 0, 0, 1);
    
    // if carouseling is in effect
    if (self.willCarousel) {
        // and if there exists subviews
        if ([self.subviews count] > 0){
            // for the subviews, multiply all values by -1 because they're roatating in
            // the opposite direction
            animation.values = @[[NSNumber numberWithFloat:-oldValue],
                                 [NSNumber numberWithFloat:(-newValue + -oldValue)/2.0f],
                                 [NSNumber numberWithFloat:-newValue]];
            
            for (UIView *subview in self.subviews) {
                [subview.layer addAnimation:animation forKey:nil];
                subview.layer.transform = CATransform3DMakeRotation(-newValue, 0, 0, 1);
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // grab the touchPoint relative to the suprview
    // if you grab it relative to the current view, the point will never actually change
    CGPoint touchPoint = [[touches anyObject] locationInView:self.superview];
    // adjust point to he origin is at the center of self.center
    touchPoint = [self pointRelativeToCenter:touchPoint];
    
    if (!([self distanceFromCenter:touchPoint] < self.minimumDistanceFromCenter)) {
        // Handle touch
        // this is the first touch, save it, and store the current quadrant
        _currentTouchAngle = [self angleBetweenCenterAndPoint:touchPoint];
        _curQuad = [self quadrantForPoint:touchPoint];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // grab the touchPoint relative to the superview
    // if you grab it relative to the current view, the point will never actually change
    CGPoint touchPoint = [[touches anyObject] locationInView:self.superview];
    
    // the following check is in place to make sure the user's touch is still within circleScrollView's frame
    if (CGRectContainsPoint(self.frame, touchPoint)) {
    
        // adjust point to he origin is at the center of self.center
        touchPoint = [self pointRelativeToCenter:touchPoint];
    
        if (!([self distanceFromCenter:touchPoint] < self.minimumDistanceFromCenter)) {
            // Handle touch
            // compute angle to roatate to: rotationAngle
            float rotationAngle = [self computeRotation:touchPoint];
            // rotationAngle is the angle we need to rotate to
        
            // enforce boundaries if they exist
            rotationAngle = [self enforceBoundaries:rotationAngle];
            
            // store current rotation angle
            _curRotationAngle = rotationAngle;
        
            // commit rotation
            self.layer.transform = CATransform3DMakeRotation(rotationAngle, 0, 0, 1);
            // if carouseling is in effect, rotate subviews as well
            if (self.willCarousel) {
                [self carousselSubviews:rotationAngle];
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // reset circleScrollView if need be
    [self resetScrollView];
}


// Notes to developer
/*
    This section exists to keep track of what work needs to be done on this project
 
 // The following is a snapshot of what my notes read at one point in time:
 
    Currently working on: reset the circleScrollView upon touchesEnded
        1. The subviews need to be reset
 
    To do:
        1. make sure a user can toggle all the fancy addOns like carouseling
        2. clean up code, write detailed comments
            - Make the (lower and upper) angle bounds global variables
            - make sure there isn't any variable laying around that cannot easily be reset from uptop
 
 // end snapshot
 
 // current notes
 
    Future add-on projects:
        1. Touch, drag, and release to spin circleScrollView until the momentum dies out 
            - this wil help maintain a natural/fluid user experience
 
 // end current notes
*/


@end
