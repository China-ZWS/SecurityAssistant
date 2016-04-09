//
//  WaitHandledDangerDetailsContentCollectionViewCell.h
//  SecurityAssistant
//
//  Created by talkweb on 16/4/5.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitHandledDangerDetailsContentCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic)NSString *url;
@property (assign, nonatomic)int typeId;

@end
