//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Peter Reveles on 4/25/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

#pragma mark - BackEnd

- (NSAttributedString *)renderedSetCardContentsForCard:(Card *)card{
    SetCard *setCard = (SetCard *)card;
    NSInteger cardNumber = [setCard.number integerValue];
    NSString *string = [[NSString alloc] initWithString:setCard.shape];
    for (int i = 1; i < cardNumber; i++) {
        string = [string stringByAppendingString:setCard.shape];
    }
    NSAttributedString *contents;
    if ([setCard.shade isEqualToString:@"open"]) {
        contents = [[NSAttributedString alloc] initWithString:string attributes:@{NSStrokeWidthAttributeName: @-3,
                                                                                  NSStrokeColorAttributeName: setCard.color,
                                                                                  NSForegroundColorAttributeName: [setCard.color colorWithAlphaComponent:0.0f]}];
    } else if ([setCard.shade isEqualToString:@"shaded"]) {
        contents = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: [setCard.color colorWithAlphaComponent:0.25f],
                                                                                  NSStrokeWidthAttributeName: @-3,
                                                                                  NSStrokeColorAttributeName: setCard.color}];
    } else if ([setCard.shade isEqualToString:@"solid"]) {
        contents = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: setCard.color}];
    }
    
    return contents;
}

#pragma mark - Implementation of Abstract Methods

- (Deck *)createDeck{
    return [[SetCardDeck alloc] init];
}

- (NSInteger)cardsToMatch{
    return 3;
}

#pragma mark - Overridden Methods

// here is where I sync UIAttributes to a card's contents
- (NSAttributedString *)titleForCard:(Card *)card byPass:(BOOL)byPass{
    return [self renderedSetCardContentsForCard:card];
}

- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardFrontChoosen" : @"cardFront"];
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
