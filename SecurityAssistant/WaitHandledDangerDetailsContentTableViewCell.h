//
//  WaitHandledDangerDetailsContentTableViewCell.h
//  SecurityAssistant
//
//  Created by talkweb on 16/4/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitHandledDangerDetailsContentTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbArea;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbSuggestTime;

@property (weak, nonatomic) IBOutlet UICollectionView *cvObtainVidence;
@property (weak, nonatomic) IBOutlet UILabel *lbFeedbackUser;
@property (weak, nonatomic) IBOutlet UILabel *lbReceiveUser;
@property (weak, nonatomic) IBOutlet UILabel *lbCCUser;
@property (weak, nonatomic) IBOutlet UILabel *lbFeedbackTime;
@property (weak, nonatomic) IBOutlet UITextView *txtFeedbackContent;

@property (strong,nonatomic)NSArray *array;
@end
