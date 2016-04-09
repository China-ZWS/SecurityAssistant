//
//  WaitHandledTableViewCell.h
//  SecurityAssistant
//
//  Created by talkweb on 16/2/29.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitHandledTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end
