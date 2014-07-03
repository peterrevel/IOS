//
//  PRButton.m
//  Concierge
//
//  Created by Quentin Fasquel on 26/04/2014.
//  Copyright (c) 2014 Hawthorne Labs. All rights reserved.
//

#import "PRButton.h"

@implementation PRButton

- (void)setup {
    self.style = PRButtonStyleBordered;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

- (void)setStyle:(PRButtonStyle)style {
    _style = style;

    switch (style) {
        case PRButtonStyleWhite:
        case PRButtonStylePlain:
            self.layer.borderWidth = 0.0f;
            break;

        default:
        case PRButtonStyleBordered:
            self.layer.borderWidth = 2.0f;
            break;
    }
    
    [self tintColorDidChange];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0f;
}

- (void)tintColorDidChange {
    switch (self.style) {
        case PRButtonStylePlain:
            self.backgroundColor = self.tintColor;
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
            break;

        case PRButtonStyleWhite:
            self.backgroundColor = [UIColor whiteColor];
            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
            [self setTitleColor:self.tintColor forState:UIControlStateHighlighted];
            [self setTitleColor:[self.tintColor colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
            break;

            
        default:
        case PRButtonStyleBordered:
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderColor = self.tintColor.CGColor;
            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
            [self setTitleColor:self.tintColor forState:UIControlStateHighlighted];
            [self setTitleColor:[self.tintColor colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
            break;
    }
    
    if (self.backgroundColor != [UIColor clearColor]) {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:self.enabled?1.0f:0.3f];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    if (self.backgroundColor != [UIColor clearColor]) {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:enabled?1.0f:0.3f];
    }
//    [self setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateDisabled];
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    [UIView animateWithDuration:(highlighted ? 0.0:0.15) animations:^{
        if (self.style == PRButtonStylePlain) {
            self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:highlighted?0.7f:1.0f];
        } else {
            self.layer.borderColor = [self.tintColor colorWithAlphaComponent:highlighted?0.7f:1.0f].CGColor;
        }
    }];
}


@end
