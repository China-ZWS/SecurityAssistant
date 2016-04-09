//
//  BasePickerView.m
//  BaseObject
//
//  Created by 周文松 on 16/3/2.
//  Copyright © 2016年 TalkWeb. All rights reserved.
//

#import "BasePickerView.h"
#define kToolViewHeight 44

@interface BasePickerView ()
{
    void(^_successBlock)(id);
    void(^_cancel)();
    id _datas;
    
}
@property (nonatomic) UIView *contentView;
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation BasePickerView

- (void)dealloc
{
    [_contentView removeObserver:self forKeyPath:@"datas"];
    
}

+ (id)showInView:(void(^)(id))showInView  success:(void (^)(id))success cancel:(void(^)())cancel;
{
    
    BasePickerView *view = [BasePickerView new];
    view->_successBlock = success;
    view->_cancel = cancel;
    showInView(view);
    return view;
}

- (BasePickerView *(^)(UIView *contentView))addContentView;
{
    return ^BasePickerView *(UIView *contentView)
    {
        self.contentView = contentView;
        [self setFrameWithSelf];
        [self createNotification];

        return self;
    };
}

- (void)createNotification
{
    [_contentView addObserver:self
                   forKeyPath:@"datas"
                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                       context:nil];
}

//实现回调方法
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"datas"]) {
        _datas = change[@"new"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.toolBar];
    [self addSubview:_contentView];
}


- (void)setFrameWithSelf
{
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(_contentView.frame) - kToolViewHeight;
    rect.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    rect.size.height = CGRectGetHeight(_contentView.frame) + kToolViewHeight;
    self.frame = rect;

}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, kToolViewHeight)];
        UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
        
        UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
        _toolBar.items=@[lefttem,centerSpace,right];
    }
    return _toolBar;
    
}

- (void)remove
{
    _cancel();
}

- (void)doneClick
{
    _successBlock(_datas);
    [self.window endEditing:YES];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
