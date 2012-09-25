//
//  LUEventTableViewCell.h
//  Lookup
//
//  Created by Wesley Smith on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setTime:(NSDate *)time;

@end
