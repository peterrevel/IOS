//
//  ViewController.m
//  PRButtonAnimations
//
//  Created by Peter Reveles on 7/2/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "ViewController.h"
#import "PRButton.h"

@interface ViewController ()
@property (nonatomic, weak) PRButton *buttonOne;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation ViewController

#pragma mark - Accessor Methods

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

#pragma mark - UINavigation
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.buttonOne.center = CGPointMake(self.buttonOne.center.x, CGRectGetMaxY([[UIScreen mainScreen] bounds]) + CGRectGetHeight(self.buttonOne.bounds));
    [self stringButtonsTogether];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self intitiateGravity];
    [self presentButtons];
}

#pragma mark - Views

- (void)stringButtonsTogether{
    int nextY = CGRectGetMaxY(self.buttonOne.frame) + 10.0f;
    PRButton *previousButton = self.buttonOne;
    for (PRButton *button in self.buttons) {
        button.center = CGPointMake(button.center.x, nextY);
        UIOffset leftOffset;
        UIOffset rightOffset;
        CGFloat width;
        if (CGRectGetWidth(button.bounds) < CGRectGetWidth(previousButton.bounds)) {
            width = CGRectGetWidth(button.bounds);
            leftOffset = UIOffsetMake(-width/2.0f, 0.0f);
            rightOffset = UIOffsetMake(width/2.0f, 0.0f);
            
        } else {
            width = CGRectGetWidth(previousButton.bounds);
            leftOffset = UIOffsetMake(-width/2.0f, 0.0f);
            rightOffset = UIOffsetMake(width/2.0f, 0.0f);
        }
        UIAttachmentBehavior *leftAttachment = [[UIAttachmentBehavior alloc] initWithItem:button offsetFromCenter:leftOffset attachedToItem:previousButton offsetFromCenter:rightOffset];
        UIAttachmentBehavior *rightAttachment = [[UIAttachmentBehavior alloc] initWithItem:button offsetFromCenter:rightOffset attachedToItem:previousButton offsetFromCenter:leftOffset];
        leftAttachment.frequency = 7.0f;
        leftAttachment.damping = 5.0f;
        //leftAttachment.length = (CGRectGetHeight(previousButton.bounds) / 2.0f) + (CGRectGetHeight(button.bounds) / 2.0f) + 15.0f;
        CGFloat height = (CGRectGetHeight(previousButton.bounds) / 2.0f) + (CGRectGetHeight(button.bounds) / 2.0f) + 10.0f;
        leftAttachment.length = floorf(sqrtf(height*height + width*width));
        rightAttachment.frequency = leftAttachment.frequency;
        rightAttachment.damping = leftAttachment.damping;
        rightAttachment.length = leftAttachment.length;
        [self.animator addBehavior:leftAttachment];
        [self.animator addBehavior:rightAttachment];
        previousButton = button;
        nextY += CGRectGetHeight(button.bounds) + 20.0f;
    }
}

- (void)intitiateGravity{
    UIDynamicItemBehavior *angularResistanceBehavior_allButtons = [[UIDynamicItemBehavior alloc] initWithItems:self.buttons];
    UIDynamicItemBehavior *angularResistanceBehavior_topButton = [[UIDynamicItemBehavior alloc] initWithItems:@[self.buttonOne]];
    angularResistanceBehavior_allButtons.angularResistance = 140.0f;
    angularResistanceBehavior_topButton.angularResistance = angularResistanceBehavior_allButtons.angularResistance;
    [self.animator addBehavior:angularResistanceBehavior_allButtons];
    [self.animator addBehavior:angularResistanceBehavior_topButton];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:self.buttons];
    gravity.magnitude = 1.0f;
    gravity.gravityDirection = CGVectorMake(0.0f, 1.0f);
    [self.animator addBehavior:gravity];
}

- (void)presentButtons{
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self.buttonOne snapToPoint:CGPointMake(self.buttonOne.center.x, CGRectGetMaxY([[UIScreen mainScreen] bounds]) - 140.0f)];
    __weak ViewController *_weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_weakSelf.animator addBehavior:snapBehavior];
    });
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    PRButton *buttonOne = [PRButton new];
    buttonOne.translatesAutoresizingMaskIntoConstraints = NO;
    buttonOne.alpha = 1.0f;
    buttonOne.tintColor = [UIColor orangeColor];
    buttonOne.style = PRButtonStylePlain;
    [buttonOne setTitle:@"Hello" forState:UIControlStateNormal];
    [self.view addSubview:buttonOne];
    _buttonOne = buttonOne;
    
    PRButton *buttonTwo = [PRButton new];
    buttonTwo.translatesAutoresizingMaskIntoConstraints = NO;
    buttonTwo.alpha = buttonOne.alpha;
    buttonTwo.tintColor = [UIColor orangeColor];
    buttonTwo.style = PRButtonStyleBordered;
    [buttonTwo setTitle:@"World" forState:UIControlStateNormal];
    [self.view addSubview:buttonTwo];
    
    self.buttons = @[buttonTwo];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(buttonOne, buttonTwo);
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(40)-[buttonOne]-(40)-|"
      options:0 metrics:nil views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[buttonOne(==40)]"
      options:0 metrics:nil views:views]];
    
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:buttonTwo attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:buttonOne attribute:NSLayoutAttributeHeight
      multiplier:1.0f constant:0.0f]];
    
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:buttonTwo attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:buttonOne attribute:NSLayoutAttributeWidth
      multiplier:1.0f constant:0.0f]];
    
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:buttonTwo attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:buttonOne attribute:NSLayoutAttributeCenterX
      multiplier:1.0f constant:0.0f]];
}

@end
