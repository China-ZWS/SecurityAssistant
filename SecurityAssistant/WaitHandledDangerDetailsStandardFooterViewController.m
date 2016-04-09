//
//  WaitHandledDangerDetailsStandardFooterViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/4/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDangerDetailsStandardFooterViewController.h"

@interface WaitHandledDangerDetailsStandardFooterViewController (){
    __weak IBOutlet UIButton *processContinueButton;
    __weak IBOutlet UIButton *processMakeButton;
    __weak IBOutlet UIButton *processIdealButton;
}

@end

@implementation WaitHandledDangerDetailsStandardFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    processIdealButton.layer.borderColor = [VariableStore getSystemBackgroundColor].CGColor;
    processIdealButton.layer.borderWidth = 1.f;
    processIdealButton.layer.masksToBounds = YES;
    processIdealButton.layer.cornerRadius = 5;
    
    processMakeButton.layer.borderColor = [VariableStore getSystemBackgroundColor].CGColor;
    processMakeButton.layer.borderWidth = 1.f;
    processMakeButton.layer.masksToBounds = YES;
    processMakeButton.layer.cornerRadius = 5;
    
    processContinueButton.layer.borderColor = [VariableStore getSystemBackgroundColor].CGColor;
    processContinueButton.layer.borderWidth = 1.f;
    processContinueButton.layer.masksToBounds = YES;
    processContinueButton.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)processIdealButtonOnclick:(id)sender {
    [self.delegate processIdeal];
}
- (IBAction)processMakeButtonOnclick:(id)sender {
    [self.delegate processMake];
}
- (IBAction)processContinueButtonOnclick:(id)sender {
    [self.delegate processContinue];
}

@end
