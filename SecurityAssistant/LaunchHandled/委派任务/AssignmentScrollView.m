//
//  AssignmentScrollView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "AssignmentScrollView.h"
#import "PJTextField.h"
#import "PJPickerView.h"
#import "PJTextView.h"
#import "DatePicker.h"
#import "FileAddView.h"


@interface AssignmentScrollView ()
<UITextFieldDelegate, UITextViewDelegate>
{
    void(^_recipientBlock)(id);
    void(^_ccBlock)(id);
    NSDateFormatter *_formatter;
}
@property (nonatomic) UILabel *assignmentNameLb;
@property (nonatomic) UILabel *recipientLb;
@property (nonatomic) UILabel *ccLb;
@property (nonatomic) UILabel *startDateLb;
@property (nonatomic) UILabel *endDateLb;
@property (nonatomic) PJTextField *assignmentNameField;
@property (nonatomic) PJTextField *recipientField;
@property (nonatomic) PJTextField *ccField;
@property (nonatomic) PJTextField *startDateField;
@property (nonatomic) PJTextField *endDateField;

@property (nonatomic) PJTextView *contentView;
@property (nonatomic) UILabel *takeTitle;

@property (nonatomic) FileAddView *addView;


@end

@implementation AssignmentScrollView

static UIView *showInView;

- (void)dealloc
{
    NSLog(@"%@",self);
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)])) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

+ (id)showInView:(UIView *)showInView;
{
    AssignmentScrollView *view = [AssignmentScrollView new];
    [showInView addSubview:view];
    return view;
}

#pragma mark - 第一行label
- (UILabel *)assignmentNameLb
{
    if (!_assignmentNameLb) {
        
        _assignmentNameLb = [self _createLabelFont:FontBold(16) text:@"任务名称" textColor:CustomBlack minX:leftX minY:topY];
    }
    return _assignmentNameLb;
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
- (UILabel *)ccLb
{
    if (!_ccLb) {
        
        _ccLb = [self _createLabelFont:FontBold(16) text:@"抄送人" textColor:CustomBlack minX:leftX minY:3 * topY + lineHeight * 2];
    }
    return _ccLb;
}

#pragma mark - 第四行
- (UILabel *)startDateLb
{
    if (!_startDateLb) {
        _startDateLb = [self _createLabelFont:FontBold(16) text:@"开始时间" textColor:CustomBlack minX:leftX minY:4 * topY + lineHeight * 3];
    }
    return _startDateLb;
}

#pragma mark - 第五行
- (UILabel *)endDateLb
{
    if (!_endDateLb) {
        _endDateLb = [self _createLabelFont:FontBold(16) text:@"结束时间" textColor:CustomBlack minX:leftX minY:5 * topY + lineHeight * 4];
    }
    return _endDateLb;
    
}



#pragma mark -任务名称键盘
- (PJTextField *)assignmentNameField
{
    if (!_assignmentNameField) {
        _assignmentNameField = [self _createFieldFrame:CGRectMake(_assignmentNameLb.right + leftX, _assignmentNameLb.top + topY, self.width - (_assignmentNameLb.right + leftX * 2), CGRectGetHeight(_assignmentNameLb.frame) - topY * 2) font:Font(15) placeholder:@"请填写任务名称" borderType:kFoldLine borderColor:CustomBlue borderWidth:2];
        [_assignmentNameField addTarget:self  action:@selector(assignmentNameValueChanged)  forControlEvents:UIControlEventEditingChanged];
    }
    return _assignmentNameField;
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

#pragma mark -抄送人键盘
- (PJTextField *)ccField
{
    if (!_ccField) {
        _ccField = [self _createFieldFrame:CGRectMake(_ccLb.right + leftX, _ccLb.top + topY, self.width - (_ccLb.right + leftX * 3) - 40, CGRectGetHeight(_ccLb.frame) - topY * 2) font:Font(15) placeholder:@"请从右边选择抄送人(选填)" borderType:kFoldLine borderColor:CustomGray borderWidth:2];
        [_ccField setClearButtonMode:UITextFieldViewModeUnlessEditing];
        _ccField.delegate = self;
        __block PJTextField *safeTextField = _ccField;
        __block void(^safeCC)(NSString *) = _cc;
        
        _ccBlock = ^(id datas)
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
            
            safeCC([userids componentsJoinedByString:@","]);
        };

        [self addSubview:[self _setRightViewWithOrigin:CGPointMake((self.width - _ccField.right - 40) / 2 + _ccField.right, _ccField.top + (_ccField.height - 40) / 2) imageName:@"person.png"  action:@selector(eventWithPushinContactsForCc)]];
    }
    return _ccField;
}

#pragma mark - 开始时间
- (PJTextField *)startDateField
{
    if (!_startDateField) {
        _startDateField = [self _createFieldFrame:CGRectMake(_startDateLb.right + leftX, _startDateLb.top + topY, ScaleW(150), CGRectGetHeight(_startDateLb.frame) - topY * 2) font:Font(15) placeholder:@"开始时间" borderType:kFullLine borderColor:CustomBlue borderWidth:1];
        _startDateField.delegate = self;
        [_startDateField addTarget:self action:@selector(showWithstartDate) forControlEvents:UIControlEventEditingDidBegin];
      
        _startDateField.textColor = CustomBlue;
        NSDate *date = [NSDate date];
        [_formatter setDateFormat:@"M月dd日 HH:mm"];
        _startDateField.text = [_formatter stringFromDate:date];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _startDate([_formatter stringFromDate:date]);

    }
    return _startDateField;
}

#pragma mark - 结束时间年月日
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
        NSInteger hour = [comp hour];
        [comp setHour:hour + 2];
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

#pragma  mark - 取证label
- (UILabel *)takeTitle
{
    if (!_takeTitle) {
        _takeTitle = [self _createLabelFont:FontBold(16) text:@"取证" textColor:CustomBlack minX:leftX minY:_contentView.bottom];
    }
    return _takeTitle;
}


#pragma mark - 文本添加框实例化
- (FileAddView *)addView
{
    if (!_addView) {
        WEAKSELF
        __block void(^safeFiles)(id) = _files;
        _addView =  [FileAddView  showInViewWithframe:CGRectMake(leftX, _takeTitle.bottom , _contentView.width, (_contentView.width - 24) / 4) success:^(id datas)
                     {
                         
                         safeFiles(datas);
                     }
                                        refreshHeight:^()
                     {
                         [weakSelf refreshHeight];
                     }
                     ];
    }
    return _addView;
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
    [self addSubview:self.assignmentNameLb];
    [self addSubview:self.recipientLb];
    [self addSubview:self.ccLb];
    [self addSubview:self.startDateLb];
    [self addSubview:self.endDateLb];
    
    /*
     键盘实例化
     */
    [self addSubview:self.assignmentNameField];
    [self addSubview:self.recipientField];
    [self addSubview:self.ccField];
    [self addSubview:self.startDateField];
    [self addSubview:self.endDateField];
    
    /*
     textView实例化
     */
    [self addSubview:self.contentView];
    
    
    /*
     取证Lable
     */
    [self addSubview:self.takeTitle];
    
    /*
     文本文件添加
     */
    [self addSubview:self.addView];
    
    /*
     算self.contentSize
     */
    [self refreshHeight];
}

- (void)refreshHeight
{
    self.contentSize = CGSizeMake(self.width, _addView.bottom + topY);
}

#pragma mark - 进入联系人界面
- (void)eventWithPushinContactsForRecipient
{
    _pushInRecipient(_recipientBlock);
}

- (void)eventWithPushinContactsForCc
{
    _pushInCC(_ccBlock);
}

#pragma mark - 获取任务名称
- (void)assignmentNameValueChanged;
{
    NSUInteger loc = _assignmentNameField.text.length;
    if (loc) {
        _assignmentName(_assignmentNameField.text);
    }
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

- (void)showWithstartDate
{
    if (_startDateField.inputView) {
        return;
    }
    
    __block PJTextField *safeStartDateField = _startDateField;
    __block void(^safeStartDateBlock)(NSString *) = _startDate;
    
    _startDateField.inputView = [PJPickerView showInView:^(PJPickerView *pickerView)
                                       {
                                           
                                           pickerView.addContentView(
                                                                     ({
                                               [DatePicker show:UIDatePickerModeDateAndTime];
                                           })
                                                                     );
                                       } success:^(id datas)
                                       {
                                           [_formatter setDateFormat:@"M月dd日 HH:mm"];
                                           safeStartDateField.text = [_formatter stringFromDate:datas];
                                           [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                           safeStartDateBlock([_formatter stringFromDate:datas]);
                                           [safeStartDateField resignFirstResponder];
                                       }
                                                        cancel:^{
                                                            [safeStartDateField resignFirstResponder];
                                                        }
                                       ];

}


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
                                             [DatePicker show:UIDatePickerModeDateAndTime ];
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
    if (textField == _recipientField || textField == _ccField) {
        return NO;
    }
    return YES;
}

@end


