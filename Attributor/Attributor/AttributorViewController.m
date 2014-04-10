//
//  AttributorViewController.m
//  Attributor
//
//  Created by Peter Reveles on 4/8/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

// Note: tintColor = highlight Color

#import "AttributorViewController.h"

@interface AttributorViewController ()
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;
@end

@implementation AttributorViewController

- (IBAction)changeBodySelectionColorToMatchBackgroundOfButton:(UIButton *)sender {
    [self.body.textStorage addAttribute:NSForegroundColorAttributeName
                                  value:sender.backgroundColor
                                  range:self.body.selectedRange];
}

- (IBAction)outlineBodySelection {
    [self.body.textStorage addAttributes:@{NSStrokeWidthAttributeName : @-3, NSStrokeColorAttributeName : [UIColor blackColor]}
                                   range:self.body.selectedRange];
}

- (IBAction)unoutlineBodySelection:(id)sender {
    [self.body.textStorage removeAttribute:NSStrokeWidthAttributeName
                                     range:self.body.selectedRange];
}

# pragma mark - View Controller LifeCycle

- (void)awakeFromNib{
    [super awakeFromNib];
    // occurs before viewDidLoad
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // great place to put a lot of setup code
    // Not yet on screen
    // At this point, outlets have been set
    // At this point, the bounds of the view have not yet been finalized, not geometry
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.outlineButton.currentTitle];
    [title addAttributes:@{NSStrokeWidthAttributeName : @3, NSStrokeColorAttributeName : self.outlineButton.tintColor}
                   range:NSMakeRange(0, [title length])];
    [self.outlineButton setAttributedTitle:title forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self usePerfferedFonts];
    // Do not put one time initializatino code in here
    // This gets called anytime the view is about to appear on the screen
    // This is a good place to update data that may have changed while you were off screen
    // Geomtery is set here, allow not recommeded to update geometry here
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(prefferedFontsChanged:)
                   name:UIContentSizeCategoryDidChangeNotification
                 object:nil];
}

- (void)prefferedFontsChanged:(NSNotification *)notification{
    [self usePerfferedFonts];
}

- (void)usePerfferedFonts{
    self.body.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.headline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    // Here is were iOS7 will layout ur views geometry
    // This is the place to create the storyboard programatically
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // Good place to rearrange the layout however you desire
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // you're not on screen, stop using resourced
    // pause your usage of the CPU
    // stop animations
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning{
    // Try to free up memory
    // Set strongly held pointers to nil as long as you recreate them,
    // and they're not on screen
}

@end
