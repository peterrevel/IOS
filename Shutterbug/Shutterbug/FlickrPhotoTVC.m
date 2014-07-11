//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Peter Reveles on 7/11/14.
//  Copyright (c) 2014 Peter Reveles. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "PRImageViewController.h"

@interface FlickrPhotoTVC ()

@end

@implementation FlickrPhotoTVC

#pragma mark - Accessor Methods

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    id detail = self.splitViewController.viewControllers[1]; // will be nil if target does not hace a splitVC
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[PRImageViewController class]]) {
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FlickrPhotoCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // customize cell
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKey:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareImageViewController:(PRImageViewController *)imageVC toDisplayPhoto:(NSDictionary *)photo{
    imageVC.imageUrl = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    imageVC.title = [photo valueForKey:FLICKR_PHOTO_TITLE];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"DisplayPhotoSeque"]) {
                if ([segue.destinationViewController isKindOfClass:[PRImageViewController class]]) {
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row]];
                }
            }
        }
    }
}

@end
