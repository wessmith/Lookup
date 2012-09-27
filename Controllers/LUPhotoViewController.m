//
//  LUPhotoViewController.m
//  Lookup
//
//  Created by Wesley Smith on 9/25/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUPhotoViewController.h"
#import "Event.h"
#import "Photo.h"
#import "LUTheme.h"

@interface LUPhotoViewController () <NSFetchedResultsControllerDelegate, NIPhotoAlbumScrollViewDataSource>
@property (nonatomic, strong) NSArray *photoInfoObjects;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LUPhotoViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fetchData
{
    [self.fetchedResultsController performSelectorOnMainThread:@selector(performFetch:)
                                                    withObject:nil
                                                 waitUntilDone:YES
                                                         modes:@[NSRunLoopCommonModes]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photoID" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"event.eventID=%@", self.event.eventID];
    
    NSManagedObjectContext *context = [(id)[UIApplication sharedApplication].delegate managedObjectContext];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self fetchData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [LUTheme clearNavigationBarTheme:self.navigationController.navigationBar];
    [LUTheme clearBarButtonItemTheme:self.navigationItem.rightBarButtonItem];
    [LUTheme clearBackBarButtonItemTheme];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoAlbumView.dataSource = self;
    
    self.animateMovingToNextAndPreviousPhotos = YES;
    
    [self setupFetchedResultsController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Fetched Results Controller Delegate -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    self.photoInfoObjects = controller.fetchedObjects;
    [self.photoAlbumView reloadData];
    [self.photoScrubberView reloadData];
    

}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Photo Scrubber View Data Source

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPhotosInScrubberView:(NIPhotoScrubberView *)photoScrubberView {
    return self.photoInfoObjects.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Photo Album Scroll View Data Source

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView
{
    return self.photoInfoObjects.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage *)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex: (NSInteger)photoIndex
                        photoSize: (NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading: (BOOL *)isLoading
          originalPhotoDimensions: (CGSize *)originalPhotoDimensions
{
    UIImage *image = nil;
    
    NSString *photoIndexKey = [self cacheKeyForPhotoIndex:photoIndex];
    
    Photo *photoInfo = [self.photoInfoObjects objectAtIndex:photoIndex];
    
    image = [self.highQualityImageCache objectWithName:photoIndexKey];
    
    if (nil != image) {
        
        *photoSize = NIPhotoScrollViewPhotoSizeOriginal;
        
    } else {
        
        [self requestImageFromSource: photoInfo.photoLink
                           photoSize: NIPhotoScrollViewPhotoSizeOriginal
                          photoIndex: photoIndex];
        
        *isLoading = YES;
    }
    
    return image;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
     stopLoadingPhotoAtIndex: (NSInteger)photoIndex {

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView<NIPagingScrollViewPage>*)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {

    return [self.photoAlbumView pagingScrollView:pagingScrollView pageViewForIndex:pageIndex];
}

@end
