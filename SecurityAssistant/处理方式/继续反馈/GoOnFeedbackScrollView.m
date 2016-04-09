//
//  GoOnFeedbackScrollView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/14.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "GoOnFeedbackScrollView.h"
#import "PJTextView.h"
#import "FileAddView.h"

@interface GoOnFeedbackScrollView()
<UITextFieldDelegate, UITextViewDelegate>
{
    void(^_recipientBlock)(id);
    void(^_ccBlock)(id);
}

@property (nonatomic) UIImageView *titleImg;
@property (nonatomic) UILabel *titleLb;

@property (nonatomic) UILabel *recipientLb;
@property (nonatomic) UILabel *ccLb;

@property (nonatomic) PJTextField *recipientField;
@property (nonatomic) PJTextField *ccField;

@property (nonatomic) UILabel *contentLb;
@property (nonatomic) PJTextView *contentView;

@property (nonatomic) UILabel *takeTitle;

@property (nonatomic) FileAddView *addView;

@end
@implementation GoOnFeedbackScrollView

- (void)dealloc
{
    NSLog(@"%@",self);
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)])) {
    }
    return self;
}

+ (id)showInView:(UIView *)showInView;
{
    GoOnFeedbackScrollView *view = [GoOnFeedbackScrollView new];
    [showInView addSubview:view];
    return view;
}

#pragma mark - 第一行img
- (UIImageView *)titleImg
{
    if (!_titleImg) {
        UIImage *img = img(@"goOn.png");
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(leftX,topY + (44 - 25) / 2, 25, 25)];
        _titleImg.image = img;
    }
    return _titleImg;
}

#pragma mark - 第一行label
- (UILabel *)titleLb
{
    if (!_titleLb) {
        
        _titleLb = [self _createLabelFont:FontBold(16) text:@"安排整改" textColor:[VariableStore getSystemBackgroundColor] minX:leftX minY:topY];
        _titleLb.left = _titleImg.right + leftX;
    }
    return _titleLb;
}


#pragma mark - 第二行label
- (UILabel *)recipientLb
{
    if (!_recipientLb) {
        
        _recipientLb = [self _createLabelFont:FontBold(16) text:@"接收人" textColor:CustomBlack minX:leftX minY:_titleLb.bottom + topY];
    }
    return _recipientLb;
}

#pragma mark - 第三行label
- (UILabel *)ccLb
{
    if (!_ccLb) {
        
        _ccLb = [self _createLabelFont:FontBold(16) text:@"抄送人" textColor:CustomBlack minX:leftX minY:_recipientLb.bottom + topY];
    }
    return _ccLb;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        
        _contentLb = [self _createLabelFont:FontBold(16) text:@"反馈内容" textColor:CustomBlack minX:leftX minY:_ccLb.bottom + topY];
        _contentLb.height = FontBold(18).leading;
    }
    return _contentLb;

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



#pragma mark - 文本框实例化
- (PJTextView *)contentView
{
    if (!_contentView) {
        _contentView = [[PJTextView alloc] initWithFrame:CGRectMake(leftX, _contentLb.bottom + topY, self.width - leftX * 2, 150)];
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
    
    [self addSubview:self.titleImg];
    [self addSubview:self.titleLb];
    
    /*
     labels 实例化
     */
    [self addSubview:self.recipientLb];
    [self addSubview:self.ccLb];
    [self addSubview:self.contentLb];
    /*
     键盘实例化
     */
    [self addSubview:self.recipientField];
    [self addSubview:self.ccField];
    
    
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
    if (textField == _recipientField || textField == _ccField ) {
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
