//
//  WaitHandledDailyTaskDetailsTableViewCell.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDailyTaskDetailsTableViewCell.h"

@implementation WaitHandledDailyTaskDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.actionLabel.lineType = LineTypeDown;
    self.actionLabel.lineColor = [UIColor darkGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)normalSwitchOnclick:(id)sender {
    _actionLabel.hidden = NO;
    _actionLabel.text =  _normalSwitch.on ? @"正常" : @"异常";
    
}


@end
