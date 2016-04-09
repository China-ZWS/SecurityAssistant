//
//  MeHandleScrollview.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/13.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "MeHandleScrollview.h"
#import "PJTextView.h"
#import "FileAddView.h"

@interface MeHandleScrollView ()
<UITextFieldDelegate, UITextViewDelegate>
{
    void(^_certifierBlock)(id);
    void(^_appraiserBlock)(id);
}

@property (nonatomic) UIImageView *titleImg;
@property (nonatomic) UILabel *titleLb;
@property (nonatomic) PJTextView *contentView;

@property (nonatomic) UILabel *takeTitle;

@property (nonatomic) FileAddView *addView;

@property (nonatomic) UILabel *certifierLb;
@property (nonatomic) UILabel *appraiserLb;
@property (nonatomic) PJTextField *certifierField;
@property (nonatomic) PJTextField *appraiserField;
@property (nonatomic) UIButton *certifierBtn;
@property (nonatomic) UIButton *appraiserBtn;


@end

@implementation MeHandleScrollView

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
    MeHandleScrollView *view = [MeHandleScrollView new];
    [showInView addSubview:view];
    return view;
}

#pragma mark - 第一行img
- (UIImageView *)titleImg
{
    if (!_titleImg) {
        UIImage *img = img(@"person.png");
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(leftX,topY + (44 - 25) / 2, 25, 25)];
        _titleImg.image = img;
    }
    return _titleImg;
}

#pragma mark - 第一行label
- (UILabel *)titleLb
{
    if (!_titleLb) {
        
        _titleLb = [self _createLabelFont:FontBold(16) text:@"本人处理" textColor:[VariableStore getSystemBackgroundColor] minX:leftX minY:topY];
        _titleLb.left = _titleImg.right + leftX;
    }
    return _titleLb;
}


#pragma mark - 文本框实例化
- (PJTextView *)contentView
{
    if (!_contentView) {
        _contentView = [[PJTextView alloc] initWithFrame:CGRectMake(leftX, _titleLb.bottom + topY, self.width - leftX * 2, 150)];
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


#pragma mark - 验证人label
- (UILabel *)certifierLb
{
    if (!_certifierLb) {
        
        _certifierLb = [self _createLabelFont:FontBold(16) text:@"验证人" textColor:CustomBlack minX:leftX minY:_addView.bottom + topY];
    }
    return _certifierLb;
}

#pragma mark - 评价人label
- (UILabel *)appraiserLb
{
    if (!_appraiserLb) {
        
        _appraiserLb = [self _createLabelFont:FontBold(16) text:@"评价人" textColor:CustomBlack minX:leftX minY:_certifierLb.bottom + topY];
    }
    return _appraiserLb;
}

#pragma mark -验证人键盘
- (PJTextField *)certifierField
{
    if (!_certifierField) {
        _certifierField = [self _createFieldFrame:CGRectMake(_certifierLb.right + leftX, _certifierLb.top + topY, self.width - (_certifierLb.right + leftX * 3) - 40, CGRectGetHeight(_certifierLb.frame) - topY * 2) font:Font(15) placeholder:@"请从右边选择验证人" borderType:kFoldLine borderColor:CustomGray borderWidth:2];
        [_certifierField setClearButtonMode:UITextFieldViewModeUnlessEditing];
        _certifierField.delegate = self;
        __block PJTextField *safeTextField = _certifierField;
        __block void(^safeRecipient)(NSString *) = _certifier;
        _certifierBlock = ^(id datas)
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
        _certifierBtn = [self _setRightViewWithOrigin:CGPointMake((self.width - _certifierField.right - 25) / 2 + _certifierField.right, _certifierField.top) imageName:@"person.png" action:@selector(eventWithPushinContactsForCertifier)];
        [self addSubview:_certifierBtn];
    }
    return _certifierField;
}

#pragma mark -抄送人键盘
- (PJTextField *)appraiserField
{
    if (!_appraiserField) {
        _appraiserField = [self _createFieldFrame:CGRectMake(_appraiserLb.right + leftX, _appraiserLb.top + topY, self.width - (_appraiserLb.right + leftX * 3) - 40, CGRectGetHeight(_appraiserLb.frame) - topY * 2) font:Font(15) placeholder:@"请从右边选择评价人" borderType:kFoldLine borderColor:CustomGray borderWidth:2];
        [_appraiserField setClearButtonMode:UITextFieldViewModeUnlessEditing];
        _appraiserField.delegate = self;
        __block PJTextField *safeTextField = _appraiserField;
        __block void(^safeCC)(NSString *) = _appraiser;
        
        _appraiserBlock  = ^(id datas)
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
        
        _appraiserBtn = [self _setRightViewWithOrigin:CGPointMake((self.width - _appraiserField.right - 25) / 2 + _appraiserField.right, _appraiserField.top) imageName:@"person.png"  action:@selector(eventWithPushinContactsForAppraiser)];
        [self addSubview:_appraiserBtn];
    }
    return _appraiserField;
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
     labels 实例化
     */
    [self addSubview:self.certifierLb];
    [self addSubview:self.appraiserLb];
    /*
     键盘实例化
     */
    [self addSubview:self.certifierField];
    [self addSubview:self.appraiserField];

      /*
     算self.contentSize
     */
    [self refreshHeight];

}

- (void)refreshHeight
{
    _certifierLb.top = _addView.bottom + topY;
    _certifierBtn.top = _certifierField.top = _certifierLb.top + topY;
    _appraiserLb.top = _certifierLb.bottom + topY;
    _appraiserBtn.top = _appraiserField.top = _appraiserLb.top + topY;
    self.contentSize = CGSizeMake(self.width, _appraiserLb.bottom + topY);
}


- (void)eventWithPushinContactsForCertifier
{
    _pushInCertifier(_certifierBlock);
}

- (void)eventWithPushinContactsForAppraiser
{
    _pushInAppraiser(_appraiserBlock);
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
    if (textField == _certifierField || textField == _appraiserField) {
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
