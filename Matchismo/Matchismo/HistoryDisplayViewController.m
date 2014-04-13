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
    [self updateUI];
}

- (NSString *)formatedHistoryMessage{
    NSString *historyToDisplay = [[NSString alloc] init];
    for (id obj in self.historyText) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *historyMessage = (NSString *)obj;
            historyToDisplay = [historyToDisplay stringByAppendingString:[historyMessage stringByAppendingString:@"\n"]];
        }
    }
    return historyToDisplay;
}

- (void)updateUI{
    self.historyTextView.text = [self formatedHistoryMessage];
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
