//
//  Sqaure.m
//  PRSqauresView
//
//  Created by Peter Reveles on 7/30/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "Sqaure.h"

@interface Sqaure ()
@property (nonatomic, strong) NSString *title;
@end

@implementation Sqaure

#pragma mark - Accessibility

- (NSString *)title{
    if (!_title) {
        _title = [NSString new];
    }
    return _title;
}

#pragma mark - Life Cycle

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

@end
