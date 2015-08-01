//
//  PRButton.h
//  Concierge
//
//  Created by Quentin Fasquel on 26/04/2014.
//  Copyright (c) 2014 Hawthorne Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PRButtonStyle) {
    PRButtonStyleBordered,
    PRButtonStylePlain,
    PRButtonStyleWhite,
};

@interface PRButton : UIButton
@property (assign, nonatomic) PRButtonStyle style;
@end
