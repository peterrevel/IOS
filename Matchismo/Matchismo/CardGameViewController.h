//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Peter Reveles on 3/22/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//
// Abstract Class, Must implement methods as described below

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// protected
// for subclasses
- (Deck *)createDeck; // abstract
- (NSInteger)cardsToMatch; //abstract
- (NSAttributedString *)titleForCard:(Card *)card byPass:(BOOL)byPass; // Override to customize
- (UIImage *)backgroundImageForCard:(Card *)card; // Override to customize

@end
