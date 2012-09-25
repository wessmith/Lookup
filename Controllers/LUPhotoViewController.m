//
//  LUPhotoViewController.m
//  Lookup
//
//  Created by Wesley Smith on 9/25/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUPhotoViewController.h"
#import "Event.h"

@interface LUPhotoViewController ()
@property (nonatomic, strong) NSArray *photos;
@end

@implementation LUPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photoID" ascending:NO]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"event.eventID=%@", self.event.eventID];
    
    NSError *error = nil;
    self.photos = [self.event.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) NSLog(@"Error fetching photos: %@", error);
    
    NSLog(@"Photos: %@", self.photos);
}

@end
