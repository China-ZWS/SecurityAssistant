//
//  NotiScrollView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/8.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "NotiScrollView.h"
#import "PJTextView.h"
#import "PJPickerView.h"
#import "DatePicker.h"

@interface NotiScrollView ()
<UITextFieldDelegate, UITextViewDelegate>
{
    void(^_recipientBlock)(id);
    NSDateFormatter *_formatter;

}
@property (nonatomic) UILabel *notiNameLb;
@property (nonatomic) UILabel *recipientLb;
@property (nonatomic) UILabel *endDateLb;

@property (nonatomic) PJTextField *notiNameField;
@property (nonatomic) PJTextField *recipientField;
@property (nonatomic) PJTextField *endDateField;


@property (nonatomic) PJTextView *contentView;


@end
@implementation NotiScrollView


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)])) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

+ (id)showInView:(UIView *)showInView;
{
    NotiScrollView *view = [NotiScrollView new];
    [showInView addSubview:view];
    return view;
}

#pragma mark - 第一行label
- (UILabel *)notiNameLb
{
    if (!_notiNameLb) {
        
        _notiNameLb = [self _createLabelFont:FontBold(16) text:@"通知类别" textColor:CustomBlack minX:leftX minY:topY];
    }
    return _notiNameLb;
}

#pragma mark - 第二行label
- (UILabel *)recipientLb
{
    if (!_recipientLb) {
        
        _recipientLb = [self _createLabelFont:FontBold(16) text:@"接收人" textColor:CustomBlack minX:leftX minY:2 * topY + lineHeight];
    }
    return _recipientLb;
}

#pragma mark - 第三行label
- (UILabel *)endDateLb
{
    if (!_endDateLb) {
        
        _endDateLb = [self _createLabelFont:FontBold(16) text:@"通知失效时间" textColor:CustomBlack minX:leftX minY:3 * topY + lineHeight * 2];
    }
    return _endDateLb;
}

#pragma mark -任务名称键盘
- (PJTextField *)notiNameField
{
    if (!_notiNameField) {
        _notiNameField = [self _createFieldFrame:CGRectMake(_notiNameLb.right + leftX, _notiNameLb.top + topY, self.width - (_notiNameLb.right + leftX * 2), CGRectGetHeight(_notiNameLb.frame) - topY * 2) font:Font(15) placeholder:@"工作提示" borderType:kFoldLine borderColor:[UIColor clearColor] borderWidth:2];
        _notiNameField.enabled = NO;
        _notiNameField.text = @"工作提示";
        _notiName(@"工作提示");
    }
    return _notiNameField;
}

#pragma mark -接收人键盘
- (PJTextField *)recipientField
{
    if (!_recipientField) {
        _recipientField = [self _createFieldFrame:CGRectMake(_recipientLb.right + leftX, _recipientLb.top + topY, self.width - (_recipientLb.right + leftX * 3) - 40, CGRectGetHeight(_recipientLb.frame) - topY * 2) font:Font(15) placeholder:@"请从右边选择接收人" borderType:kFoldLine borderColor:CustomGray borderWidth:2];
        [_recipientField setClearButtonMode:UITextFieldViewModeUnlessEditing];
        _recipientField.delegate = self;
        __block PJTextField *safeTextField = _recipientField;
       
        __block void(^safeRecipient)(NSString *) = _recipient;
        _recipientBlock = ^(id datas)
        {
            NSMutableArray *names = [NSMutableArray array];
            for (NSDictionary *dic in datas)
            {
                [names addObject:dic[@"displayname"]];
            }
            safeTextField.text = [names componentsJoinedByString:@","];
            
            NSMutableArray *userids = [NSMutableArray array];
            for (NSDictionary *dic in datas)
            {
                [userids addObject:dic[@"userid"]];
            }
            
            safeRecipient([userids componentsJoinedByString:@","]);
        };
        [self addSubview:[self _setRightViewWithOrigin:CGPointMake((self.width - _recipientField.right - 40) / 2 + _recipientField.right, _recipientField.top + (_recipientField.height - 40) / 2) imageName:@"person.png" action:@selector(eventWithPushinContactsForRecipient)]];
        
    }
    return _recipientField;
}


#pragma mark - 结束时间
- (PJTextField *)endDateField
{
    if (!_endDateField) {
        _endDateField = [self _createFieldFrame:CGRectMake(_endDateLb.right + leftX, _endDateLb.top + topY, ScaleW(150), CGRectGetHeight(_endDateLb.frame) - topY * 2) font:Font(15) placeholder:@"结束时间" borderType:kFullLine borderColor:CustomBlue borderWidth:1];
        _endDateField.delegate = self;
        [_endDateField addTarget:self action:@selector(showWithendDate) forControlEvents:UIControlEventEditingDidBegin];
        _endDateField.textColor = CustomBlue;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit|NSDayCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | kCFCalendarUnitSecond
                                             fromDate:[NSDate date]];
        // 得到几号
        NSInteger day = [comp day];
        [comp setDay:day + 3];
        NSDate *date= [calendar dateFromComponents:comp];
        [_formatter setDateFormat:@"M月dd日 HH:mm"];
        _endDateField.text = [_formatter stringFromDate:date];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _endDate([_formatter stringFromDate:date]);
    }
    
    return _endDateField;
}



#pragma mark - 文本框实例化
- (PJTextView *)contentView
{
    if (!_contentView) {
        _contentView = [[PJTextView alloc] initWithFrame:CGRectMake(leftX, _endDateLb.bottom + topY, self.width - leftX * 2, 150)];
        _contentView.font = Font(15);
        [_contentView getCornerRadius:5 borderColor:CustomBlue borderWidth:1 masksToBounds:YES];
        _contentView.delegate = self;
    }
    return _contentView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_hasFirst) {
        return;
    }
    _hasFirst = YES;
    /*
     labels 实例化
     */
    [self addSubview:self.notiNameLb];
    [self addSubview:self.recipientLb];
    [self addSubview:self.endDateLb];
    
    /*
     键盘实例化
     */
    [self addSubview:self.notiNameField];
    [self addSubview:self.recipientField];
    [self addSubview:self.endDateField];
    
    /*
     textView实例化
     */
    [self addSubview:self.contentView];
    
    
    /*
     算高度
     */
    [self refreshHeight];
}

- (void)refreshHeight
{
    self.contentSize = CGSizeMake(self.width, _contentView.bottom + topY);
}


#pragma mark - 进入联系人界面
- (void)eventWithPushinContactsForRecipient
{
    _pushInContacts(_recipientBlock);
}

#pragma mark - 获取文本类容
- (void)textViewDidChange:(UITextView *)textView;
{
    NSUInteger loc = _contentView.text.length;
    if (loc) {
        _contents(_contentView.text);
    }
}



#pragma mark - 弹出时间窗口

- (void)showWithendDate
{
    
    if (_endDateField.inputView) {
        return;
    }
    
    __block PJTextField *safeEndDateField = _endDateField;
    __block void(^safeEndDateBlock)(NSString *) = _endDate;
    
    _endDateField.inputView = [PJPickerView showInView:^(PJPickerView *pickerView)
                                     {
                                         
                                         pickerView.addContentView(
                                                                   ({
                                             [DatePicker show:UIDatePickerModeDateAndTime];
                                         })
                                                                   );
                                     } success:^(id datas)
                                     {
                                         [_formatter setDateFormat:@"M月dd日 HH:mm"];
                                         safeEndDateField.text = [_formatter stringFromDate:datas];
                                         [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                         safeEndDateBlock([_formatter stringFromDate:datas]);
                                         [safeEndDateField resignFirstResponder];
                                     }
                                                      cancel:^{
                                                          [safeEndDateField resignFirstResponder];
                                                      }
                                     ];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _recipientField) {
        return NO;
    }
    return YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
