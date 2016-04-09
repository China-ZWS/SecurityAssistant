//
//  WaitHandledDangerDetailsResultTableViewCell.h
//  SecurityAssistant
//
//  Created by talkweb on 16/4/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitHandledDangerDetailsResultTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cvObtainVidence;
@property (weak, nonatomic) IBOutlet UITextView *txtProcessMark;
@property (weak, nonatomic) IBOutlet UILabel *lbProcessStatue;
@property (weak, nonatomic) IBOutlet UILabel *lbProcessor;
@property (weak, nonatomic) IBOutlet UILabel *lbProcessTime;

@property (strong,nonatomic)NSArray *array;

@end