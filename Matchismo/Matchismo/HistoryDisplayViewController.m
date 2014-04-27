//
//  HistoryDisplayViewController.m
//  Matchismo
//
//  Created by Peter Reveles on 4/12/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "HistoryDisplayViewController.h"

@interface HistoryDisplayViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryDisplayViewController

- (void)setHistoryText:(NSArray *)historyText{
    _historyText = historyText;
    if (self.view.window) [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = self.backgroundColor;
    self.historyTextView.backgroundColor = self.backgroundColor;
    [self updateUI];
}

- (NSAttributedString *)formatedHistoryMessage{
    NSMutableAttributedString *historyToDisplay = [[NSMutableAttributedString alloc] init];
    for (id obj in self.historyText) {
        if ([obj isKindOfClass:[NSAttributedString class]]) {
            NSAttributedString *historyMessage = (NSAttributedString *)obj;
            if ([historyMessage length]) {
                [historyToDisplay appendAttributedString:historyMessage];
                [historyToDisplay appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
        }
    }
    return historyToDisplay;
}

- (void)updateUI{
    self.historyTextView.attributedText = [self formatedHistoryMessage];
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
