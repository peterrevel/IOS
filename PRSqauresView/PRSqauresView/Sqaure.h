//
//  Sqaure.h
//  PRSqauresView
//
//  Created by Peter Reveles on 7/30/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sqaure : NSObject

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic, readonly) NSString *title;
@end
