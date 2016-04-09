//
//  PlatePickerView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/3.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PlatePickerView.h"

@interface PlatePickerView ()
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    void(^_selected)(id);
    NSArray *_arrs;
}
@property (nonatomic) id datas;
@end

@implementation PlatePickerView

- (void)dealloc
{
    NSLog(@"%@",self);
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY(self.frame) + 44);
        self.backgroundColor = RGBA(235, 235, 235, 1);
        self.delegate = self;
        self.dataSource = self;
        _arrs = [[NetDown shareTaskDataMgr] areaArray];
        self.datas = _arrs[0];
    }
    return self;
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arrs.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _arrs[row][@"areaname"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.datas = _arrs[row];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
