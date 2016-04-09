//
//  WaitHandledDangerDetailsStandardFooterViewController.h
//  SecurityAssistant
//
//  Created by talkweb on 16/4/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaitHandledDangerDetailsStandardFooterDelegate
- (void)processIdeal;
- (void)processMake;
- (void)processContinue;
@end

@interface WaitHandledDangerDetailsStandardFooterViewController : UIViewController
@property(weak,nonatomic)id<WaitHandledDangerDetailsStandardFooterDelegate> delegate;
@end
