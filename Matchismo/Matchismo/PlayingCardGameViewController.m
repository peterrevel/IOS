//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Peter Reveles on 4/12/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"You have 6 seconods to live. Failed attempt at network requets.");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Boom!!! Explosion. I'm going to try again to pull that data you requested.");
    });
}

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (NSInteger)cardsToMatch{
    return 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
