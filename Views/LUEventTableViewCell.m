//
//  LUEventTableViewCell.m
//  Lookup
//
//  Created by Wesley Smith on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUEventTableViewCell.h"

@interface LUEventTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayOfWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOfMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation LUEventTableViewCell

- (void)setTime:(NSDate *)time
{
    static NSDateFormatter *_dateTimeFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateTimeFormatter = [[NSDateFormatter alloc] init];
    });
    
    [_dateTimeFormatter setDateFormat:@"EEE"];
    self.dayOfWeekLabel.text = [[_dateTimeFormatter stringFromDate:time] uppercaseString];
    
    [_dateTimeFormatter setDateFormat:@"MMM"];
    self.monthLabel.text = [[_dateTimeFormatter stringFromDate:time] uppercaseString];
    
    [_dateTimeFormatter setDateFormat:@"d"];
    self.dayOfMonthLabel.text = [_dateTimeFormatter stringFromDate:time];
    
    [_dateTimeFormatter setDateFormat:@"h:mm a"];
    self.timeLabel.text = [_dateTimeFormatter stringFromDate:time];
}

@end
