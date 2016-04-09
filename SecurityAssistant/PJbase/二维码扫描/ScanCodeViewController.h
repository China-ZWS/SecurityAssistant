//
//  ScanCodeViewController.h
//  BaseObject
//
//  Created by 周文松 on 16/3/13.
//  Copyright © 2016年 TalkWeb. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanCodeViewController : BaseViewController

- (id)initWithScanCode:(void(^)(NSString *scanCode))scanCode;
@end
