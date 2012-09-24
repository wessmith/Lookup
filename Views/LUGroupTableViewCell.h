//
//  LUGroupTableViewCell.h
//  Lookup
//
//  Created by smith-work on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface LUGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfMembersLabel;

- (void)setGroup:(Group *)group;

@end
