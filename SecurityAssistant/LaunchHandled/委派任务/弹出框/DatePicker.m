//
//  DatePicker.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/6.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "DatePicker.h"

@interface DatePicker ()
@property (nonatomic) NSDateFormatter *formatter;
@end

@implementation DatePicker

- (void)dealloc
{
    NSLog(@"%@",self);
}

- (NSLocale *)setLocale
{
    return ({
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        locale;
    });
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY(self.frame) + 44);
        self.backgroundColor = RGBA(235, 235, 235, 1);
        self.locale = [self setLocale];
    }
    return self;
}

+ (id)show:(UIDatePickerMode)datePickerMode;
{
    DatePicker *pick = [DatePicker new];
    pick.datePickerMode = datePickerMode;
    [pick addTarget:pick action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    [pick sendActionsForControlEvents:UIControlEventValueChanged];
    return pick;
}

- (void)selected:(id)sender
{
    DatePicker *pick = (DatePicker *)sender;
    NSDate *select = [pick date];
    switch (pick.datePickerMode) {
        case UIDatePickerModeDateAndTime:
        {
            self.datas =  select;
        }
            break;
 
        default:
            break;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
