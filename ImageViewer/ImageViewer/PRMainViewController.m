//
//  PRViewController.m
//  ImageViewer
//
//  Created by Peter Reveles on 5/27/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "PRMainViewController.h"
#import "PRImageViewController.h"

@interface PRMainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@end

@implementation PRMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"GrabImageSegue"]) {
        PRImageViewController *ivc = segue.destinationViewController;
        ivc.imageUrl = [NSURL URLWithString:self.urlTextField.text];
    }
}

@end
