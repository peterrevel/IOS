//
//  PRImageViewController.m
//  ImageViewer
//
//  Created by Peter Reveles on 5/27/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "PRImageViewController.h"

@interface PRImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation PRImageViewController

@synthesize imageUrl = _imageUrl;

#pragma mark - Model

- (void)downloadImage{
    self.image = nil;
    if (self.imageUrl) {
        [self.activityIndicator startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageUrl];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                                                            if (!error) {
                                                                if ([request.URL isEqual:self.imageUrl]) {
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        self.image = image;
                                                                    });
                                                                }
                                                            }
                                                        }];
        [task resume];
    }
}

#pragma mark - Acessor Methods

- (void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (void)setImageUrl:(NSURL *)imageUrl{
    _imageUrl = imageUrl;
    [self downloadImage];
}

- (NSURL *)imageUrl{
    if (!_imageUrl) _imageUrl = [NSURL URLWithString:@"http://www.404notfound.fr/assets/images/pages/img/androiddev101.jpg"];
    return _imageUrl;
}

- (UIImageView *)imageView{
    if (!_imageView) _imageView = [UIImageView new];
    return _imageView;
}

- (UIImage *)image{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.imageView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.imageView.bounds), CGRectGetHeight(self.imageView.bounds));
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.scrollView zoomToRect:self.imageView.bounds animated:YES];
    [self.activityIndicator stopAnimating];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.imageView];
}

@end
