//
//  JustPostedFlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Peter Reveles on 7/11/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "JustPostedFlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotoTVC ()

@end

@implementation JustPostedFlickrPhotoTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotos];
    self.title = @"Flickr API Test App";
    [self.refreshControl addTarget:self action:@selector(fetchPhotos) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)fetchPhotos{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    dispatch_queue_t fetchQueue = dispatch_queue_create("FetchQueue", NULL);
    dispatch_async(fetchQueue, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
}

@end
