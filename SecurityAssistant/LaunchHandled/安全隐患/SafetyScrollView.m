//
//  SafetyScrollView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/8.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "SafetyScrollView.h"
#import "PJTextView.h"
#import "FileAddView.h"
#import "PJPickerView.h"
#import "PlatePickerView.h"
#import "DatePicker.h"
#import "PJTableView.h"

@interface SafetyScrollView ()
<UITextFieldDelegate, UITextViewDelegate>
{
    void(^_recipientBlock)(NSString *);
    void(^_ccBlock)(NSString *);
    void (^_scanBlock)(NSString *);
    BOOL _hsaTouchHazardSourcesme;
    NSDateFormatter *_formatter;
    NSMutableArray *_codes;

}
@property (nonatomic) UILabel *nameLb;


@property (nonatomic) UILabel *hazardSourcesmeLb;
@property (nonatomic) UILabel *occurDateLb;

@property (nonatomic) UILabel *codeFirstLb;
@property (nonatomic) UILabel *codeSecondLb;

@property (nonatomic) PJTextField *nameField;
@property (nonatomic) PJTextField *recipientField;
@property (nonatomic) PJTextField *ccField;

@property (nonatomic) PJTextField *hazardSourcesmeField;
@property (nonatomic) PJTextField *occurDateField;

@property (nonatomic) PJTableView *codeView;
@property (nonatomic) PJTextView *contentView;

@property (nonatomic) UILabel *takeTitle;

@property (nonatomic) FileAddView *addView;

@property (nonatomic) UILabel *recipientLb;
@property (nonatomic) UILabel *ccLb;
@property (nonatomic) UILabel *processingLb;
@property (nonatomic) PJTextField *processingDateField;
@property (nonatomic) UIButton *recipientBtn;
@property (nonatomic) UIButton *ccBtn;

@end

@implementation SafetyScrollView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)])) {
        _formatter = [[NSDateFormatter alloc] init];
        _codes = [NSMutableArray array];
    }
    return self;
}

+ (id)showInView:(UIView *)showInView;
{
    SafetyScrollView *view = [SafetyScrollView new];
    [showInView addSubview:view];
    return view;
}

#pragma mark - 第一行label
- (UILabel *)nameLb
{
    if (!_nameLb) {
        
        _nameLb = [self _createLabelFont:FontBold(16) text:@"主 题" textColor:CustomBlack minX:leftX minY:topY];
    }
    return _nameLb;
}


#pragma mark - 第二行label
- (UILabel *)hazardSourcesmeLb
{
    if (!_hazardSourcesmeLb) {
        
        _hazardSourcesmeLb = [self _createLabelFont:FontBold(16) text:@"安全责任区域" textColor:CustomBlack minX:leftX minY:_nameLb.bottom + topY];
    }
    return _hazardSourcesmeLb;
}

#pragma mark - 第三行
- (UILabel *)startDateLb
{
    if (!_occurDateLb) {
        _occurDateLb = [self _createLabelFont:FontBold(16) text:@"发生时间" textColor:CustomBlack minX:leftX minY:_hazardSourcesmeLb.bottom + topY];
    }
    return _occurDateLb;
}


#pragma mark - 第四行label
- (UILabel *)codeFirstLb
{
    if (!_codeFirstLb) {
        
        _codeFirstLb = [self _createLabelFont:FontBold(16) text:@"扫描二维码" textColor:CustomBlack minX:leftX minY:_occurDateLb.bottom + topY];
        
    }
    return _codeFirstLb;
}



#pragma mark - 第五行
- (UILabel *)codeSecondLb
{
    
    if (!_codeSecondLb) {
        _codeSecondLb = [self _createLabelFont:FontBold(16) text:@"扫描结果:" textColor:CustomBlack minX:leftX minY:_codeFirstLb.bottom - (lineHeight - FontBold(17).leading) / 2];
    }
    return _codeSecondLb;
}

#pragma mark - 接受人label
- (UILabel *)recipientLb
{
    if (!_recipientLb) {
        
        _recipientLb = [self _createLabelFont:FontBold(16) text:@"接收人" textColor:CustomBlack minX:leftX minY:_addView.bottom + topY];
    }
    return _recipientLb;
}

#pragma mark - 抄送人label
- (UILabel *)ccLb
{
    if (!_ccLb) {
        
        _ccLb = [self _createLabelFont:FontBold(16) text:@"抄送人" textColor:CustomBlack minX:leftX minY:_recipientLb.bottom + topY];
    }
    return _ccLb;
}

#pragma mark - 建议处理label
- (UILabel *)processingLb
{
    if (!_processingLb) {
        
        _processingLb = [self _createLabelFont:FontBold(16) text:@"建议处理时间" textColor:CustomBlack minX:leftX minY:_ccLb.bottom + topY];
    }
    return _processingLb;
}


#pragma mark -异常名称键盘
- (PJTextField *)nameField
{
    if (!_nameField) {
        _nameField = [self _createFieldFrame:CGRectMake(_nameLb.right + leftX, _nameLb.top + topY, self.width - (_nameLb.right + leftX * 2), CGRectGetHeight(_nameLb.frame) - topY * 2) font:Font(15) placeholder:@"请填写异常名称" borderType:kFoldLine borderColor:CustomBlue borderWidth:2];
        [_nameField addTarget:self  action:@selector(nameValueChanged)  forControlEvents:UIControlEventEditingChanged];
#if 0
        if (_datas) {
            _nameField.text = _datas[@"c_task_name"];
            _name(_datas[@"c_task_name"]);
        }
        NSLog(@"\n\n_datas = \n%@\n\n",_datas);
#endif
    }
    return _nameField;
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
        _recipientBtn = [self _setRightViewWithOrigin:CGPointMake((self.width - _recipientField.right - 40) / 2 + _recipientField.right, _recipientField.top + (_recipientField.height - 40) / 2) imageName:@"person.png" action:@selector(eventWithPushinContactsForRecipient)];
        [self addSubview:_recipientBtn];
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
        
        _ccBtn = [self _setRightViewWithOrigin:CGPointMake((self.width - _ccField.right - 40) / 2 + _ccField.right, _ccField.top + (_ccField.height - 40) / 2) imageName:@"person.png"  action:@selector(eventWithPushinContactsForCc)];
        [self addSubview:_ccBtn];
    }
    return _ccField;
}


#pragma mark -隐患来源键盘
- (PJTextField *)hazardSourcesmeField
{
    if (!_hazardSourcesmeField) {
        _hazardSourcesmeField = [self _createFieldFrame:CGRectMake(_hazardSourcesmeLb.right + leftX, _hazardSourcesmeLb.top + topY, self.width - (_hazardSourcesmeLb.right + leftX * 3) - 40, CGRectGetHeight(_hazardSourcesmeLb.frame) - topY * 2) font:Font(15) placeholder:@"请从右边选择隐患来源(选填)" borderType:kFoldLine borderColor:CustomGray borderWidth:2];
        _hazardSourcesmeField.delegate = self;
        [self addSubview:[self _setRightViewWithOrigin:CGPointMake((self.width - _hazardSourcesmeField.right - 40) / 2 + _hazardSourcesmeField.right, _hazardSourcesmeField.top + (_hazardSourcesmeField.height - 40) / 2) imageName:@"pen.png" action:@selector(eventWithHazardSourcesme)]];
#if 0
        NSArray *areas = [[NetDown shareTaskDataMgr] areaArray];
        _hazardSourcesmeField.text = areas[0][@"areaname"];
        _hazardSourcesme(areas[0]);
#endif
    }
    return _hazardSourcesmeField;
}

- (NSDictionary *)getAreaId
{
    NSArray *areas = [[NetDown shareTaskDataMgr] areaArray];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"areaname = %@",_datas[@"areaname"]];
    NSArray *datas = [areas filteredArrayUsingPredicate:predicate];
    return datas[0];
}

#pragma mark - 发生时间
- (PJTextField *)occurDateField
{
    if (!_occurDateField)
    {
        _occurDateField = [self _createFieldFrame:CGRectMake(_occurDateLb.right + leftX, _occurDateLb.top + topY, ScaleW(150), CGRectGetHeight(_occurDateLb.frame) - topY * 2) font:Font(15) placeholder:@"发生时间" borderType:kFullLine borderColor:CustomBlue borderWidth:1];
        _occurDateField.delegate = self;
        [_occurDateField addTarget:self action:@selector(showWithOccurDate) forControlEvents:UIControlEventEditingDidBegin];
        _occurDateField.textColor = CustomBlue;
        NSDate *date = [NSDate date];
        [_formatter setDateFormat:@"M月dd日 HH:mm"];
        _occurDateField.text = [_formatter stringFromDate:date];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _occurDate([_formatter stringFromDate:date]);
    }
    return _occurDateField;
}




#pragma mark - 建议时间
- (PJTextField *)processingDateField
{
    if (!_processingDateField) {
        _processingDateField = [self _createFieldFrame:CGRectMake(_processingLb.right + leftX, _processingLb.top + topY, ScaleW(150), CGRectGetHeight(_processingLb.frame) - topY * 2) font:Font(15) placeholder:@"建议时间" borderType:kFullLine borderColor:CustomBlue borderWidth:1];
        _processingDateField.textColor = CustomBlue;
        _processingDateField.delegate = self;
        [_processingDateField addTarget:self action:@selector(showWithProcessingDate) forControlEvents:UIControlEventEditingDidBegin];
    }
    return _processingDateField;
}


#pragma mark -二维码键盘
- (PJTableView *)codeView
{
    if (!_codeView) {
        
        CGFloat imgWidth = _codeSecondLb.bottom - _codeFirstLb.top;
        _codeView = [[PJTableView alloc] initWithFrame:CGRectMake(_codeSecondLb.right + leftX, _codeSecondLb.top + topY, self.width - imgWidth - leftX * 3 - _codeSecondLb.right, CGRectGetHeight(_codeSecondLb.frame) - topY * 2) style:UITableViewStylePlain];
        _codeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _codeView.scrollEnabled = NO;
//        _codeView.backgroundColor = [UIColor redColor];
        UIButton *btn = [self _setRightViewWithOrigin:CGPointMake(_codeView.right + leftX, _codeFirstLb.top) imageName:nil action:@selector(eventWithPushinCode)];
        btn.size = CGSizeMake(imgWidth, imgWidth);
        [btn setBackgroundImage:[UIImage imageNamed:@"c_codescan.png"] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        __block NSMutableArray *safeCodes = _codes;
        __block PJTableView *safeTable = _codeView;
        __block UILabel *safeCodeLb = _codeSecondLb;
        
        __block void(^safeResultCode)(NSString *) = _resultCode;
        WEAKSELF
        _scanBlock = ^(NSString *code)
        {
            [safeCodes addObject:code];
            safeTable.datas = safeCodes;
            [safeTable reloadData];
            NSInteger rows = safeCodes.count;
            safeTable.height = rows * (safeCodeLb.height - topY * 2);
            [weakSelf refreshHeight];
            safeResultCode([safeCodes componentsJoinedByString:@","]);
        };
        
        _codeView.deleteDatas = ^(id datas){
            NSInteger rows = [datas count]?[datas count]:1;
            safeTable.height = rows * (safeCodeLb.height - topY * 2);
            [weakSelf refreshHeight];
            safeResultCode(safeCodes.count?[safeCodes componentsJoinedByString:@","]:@"");
        };
    }
    return _codeView;
}


#pragma mark - 文本框实例化
- (PJTextView *)contentView
{
    if (!_contentView) {
        _contentView = [[PJTextView alloc] initWithFrame:CGRectMake(leftX, _codeView.bottom + topY, self.width - leftX * 2, 150)];
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
    [self addSubview:self.nameLb];
    [self addSubview:self.hazardSourcesmeLb];
    [self addSubview:self.startDateLb];
    [self addSubview:self.codeFirstLb];
    [self addSubview:self.codeSecondLb];

    /*
     键盘实例化
     */
    [self addSubview:self.nameField];
    [self addSubview:self.hazardSourcesmeField];
    [self addSubview:self.occurDateField];
    [self addSubview:self.codeView];
    
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
    
    
    [self addSubview:self.recipientLb];
    [self addSubview:self.ccLb];
    [self addSubview:self.recipientField];
    [self addSubview:self.ccField];
    [self addSubview:self.processingLb];
    [self addSubview:self.processingDateField];

    /*
     算self.contentSize
     */
    [self refreshHeight];
}

- (void)refreshHeight
{
    _contentView.top = _codeView.bottom + topY;
    _takeTitle.top = _contentView.bottom;
    _addView.top = _takeTitle.bottom;
    _recipientLb.top = _addView.bottom + topY;
    _recipientBtn.top = _recipientField.top = _recipientLb.top + topY;
    _ccLb.top = _recipientLb.bottom + topY;
    _ccBtn.top = _ccField.top = _ccLb.top + topY;
    _processingLb.top = _ccLb.bottom + topY;
    _processingDateField.top = _processingLb.top + topY;
    self.contentSize = CGSizeMake(self.width, _processingLb.bottom + topY);
}


#pragma mark - 获取主题类容
- (void)nameValueChanged
{
    NSUInteger loc = _nameField.text.length;
    if (loc) {
        _name(_nameField.text);
    }

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

#pragma mark - 隐患来源选择框
- (void)eventWithHazardSourcesme
{
    _hsaTouchHazardSourcesme = YES;
    if (_hazardSourcesmeField.inputView) {
        [_hazardSourcesmeField becomeFirstResponder];
        return;
    }
    __block PJTextField *safeHazardSourcesme = _hazardSourcesmeField;
    __block void(^safeHazardSourcesmeBlcok)(NSString *) = _hazardSourcesme;
    _hazardSourcesmeField.inputView = [PJPickerView showInView:^(PJPickerView *pickerView)
                                       {
                                           
                                           pickerView.addContentView(
                                                                     ({
                                               [PlatePickerView new];
                                           })
                                                                     );
                                       }
                                                       success:^(id datas)
                                       {
                                           safeHazardSourcesme.text = datas[@"areaname"];
                                           safeHazardSourcesmeBlcok(datas);
                                           [safeHazardSourcesme resignFirstResponder];
                                       }
                                                        cancel:^{
                                                            [safeHazardSourcesme resignFirstResponder];
                                                        }
                                       ];
    
    [_hazardSourcesmeField becomeFirstResponder];
}



#pragma mark - 发生弹出时间窗口

- (void)showWithOccurDate
{
    if (_occurDateField.inputView) {
        return;
    }
    
    __block PJTextField *safeOccurDateField = _occurDateField;
    __block void(^safeOccurDateBlock)(NSString *) = _occurDate;
    
    _occurDateField.inputView = [PJPickerView showInView:^(PJPickerView *pickerView)
                                       {
                                           
                                           pickerView.addContentView(
                                                                     ({
                                               [DatePicker show:UIDatePickerModeDateAndTime];
                                           })
                                                                     );
                                       } success:^(id datas)
                                       {
                                           [_formatter setDateFormat:@"M月dd日 HH:mm"];
                                           safeOccurDateField.text = [_formatter stringFromDate:datas];
                                           [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                           safeOccurDateBlock([_formatter stringFromDate:datas]);
                                           [safeOccurDateField resignFirstResponder];
                                       }
                                                        cancel:^{
                                                            [safeOccurDateField resignFirstResponder];
                                                        }
                                       ];
    
}



#pragma mark - 建议弹出时间窗口
- (void)showWithProcessingDate
{
    if (_processingDateField.inputView) {
        return;
    }
    
    __block PJTextField *safeProcessingDateField = _processingDateField;
    __block void(^safeProcessingDateBlock)(NSString *) = _processingDate;
    
    _processingDateField.inputView = [PJPickerView showInView:^(PJPickerView *pickerView)
                                       {
                                           
                                           pickerView.addContentView(
                                                                     ({
                                               [DatePicker show:UIDatePickerModeDateAndTime];
                                           })
                                                                     );
                                       } success:^(id datas)
                                       {
                                           [_formatter setDateFormat:@"M月dd日 HH:mm"];
                                           safeProcessingDateField.text = [_formatter stringFromDate:datas];
                                           [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                           safeProcessingDateBlock([_formatter stringFromDate:datas]);
                                           [safeProcessingDateField resignFirstResponder];
                                       }
                                                        cancel:^{
                                                            [safeProcessingDateField resignFirstResponder];
                                                        }
                                       ];
    
}

#pragma mark - 进入二维码界面
- (void)eventWithPushinCode
{
    _code(_scanBlock);
}

#pragma mark - 获取文本类容
- (void)textViewDidChange:(UITextView *)textView;
{
    NSUInteger loc = _contentView.text.length;
    if (loc) {
        _contents(_contentView.text);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _recipientField || textField == _ccField) {
        return NO;
    }
    else if (textField == _hazardSourcesmeField )
    {
        if (_hsaTouchHazardSourcesme) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _hsaTouchHazardSourcesme = NO;
    [super textFieldDidBeginEditing:textField];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
