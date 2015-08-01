//
//  SqauresView.m
//  PRSqauresView
//
//  Created by Peter Reveles on 7/30/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "SqauresView.h"
#import "Sqaure.h"

@interface SqauresView ()
@property (nonatomic, weak) NSMutableArray *squares;
@end

@implementation SqauresView

#pragma mark - Accessibility Methods

- (void)addSquareWithTitle:(NSString *)title{
    Sqaure *square = [[Sqaure alloc] initWithTitle:title];
    [self.squares addObject:square];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
