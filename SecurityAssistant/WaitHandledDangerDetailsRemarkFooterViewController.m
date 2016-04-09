//
//  WaitHandledDangerDetailsRemarkFooterViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/4/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDangerDetailsRemarkFooterViewController.h"
#import "KeyboardToolBar.h"
@interface WaitHandledDangerDetailsRemarkFooterViewController ()

@end

@implementation WaitHandledDangerDetailsRemarkFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _remarkTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _remarkTextView.layer.borderWidth = .3f;
    _remarkTextView.layer.masksToBounds = YES;
    _remarkTextView.layer.cornerRadius = 3;
    [KeyboardToolBar registerKeyboardToolBarWithTextView:_remarkTextView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [KeyboardToolBar unregisterKeyboardToolBarWithTextView:_remarkTextView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchCompletOnclick:(id)sender {
    UISwitch *sw = sender;
    
    if(sw.on){
        _resultLabel.text = @"合格";
    }
    else {
        _resultLabel.text = @"不合格";
    }
}


@end
