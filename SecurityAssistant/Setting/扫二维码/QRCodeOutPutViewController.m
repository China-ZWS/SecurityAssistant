//
//  QRCodeOutPutViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/4.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "QRCodeOutPutViewController.h"

@interface QRCodeOutPutViewController ()

@end

@implementation QRCodeOutPutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationItem setNewTitle:@"扫描结果"];
  //设置textview的边框
    self.ouputText.layer.borderColor=[UIColor lightGrayColor].CGColor;
  self.ouputText.layer.borderWidth=1;
   self.ouputText.layer.cornerRadius=3;
    self.ouputText.layer.masksToBounds=YES;
    self.ouputText.text=[NSString stringWithFormat:@"测试结果:%@",self.recipeString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
