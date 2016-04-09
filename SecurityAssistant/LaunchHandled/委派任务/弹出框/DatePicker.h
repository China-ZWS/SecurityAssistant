//
//  DatePicker.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/6.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIDatePicker
@property (nonatomic) id datas;

+ (id)show:(UIDatePickerMode)datePickerMode;

@end
