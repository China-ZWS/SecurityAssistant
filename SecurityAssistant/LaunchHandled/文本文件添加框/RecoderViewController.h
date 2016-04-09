//
//  RecoderViewController.h
//  SecurityAssistant
//
//  Created by kevin on 16/3/14.
//  Copyright © 2016年 talkweb. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PJViewController.h"
@interface RecoderViewController : PJViewController
@property (nonatomic, copy) void (^AVRecoderSuncessBlock) (RecoderViewController *,NSString *);//扫描结果
@end
