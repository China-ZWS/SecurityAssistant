//
//  WaitHandledDailyTaskDetailsTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDailyTaskDetailsTableViewController.h"
#import "WaitHandledDailyTaskDetailsTableViewCell.h"
#import "SYQRCodeViewController.h"
#import "KeyboardToolBar.h"
#import "NetUp.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "WaitHandledTaskStandardSectionViewController.h"
#import "WaitHandledTaskStandardDetailsViewController.h"

#import "WaitHandledTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RecoderViewController.h"

#import "WaitHandledAssignTaskStandardSectionViewController.h"
#import "SafetyViewController.h"
#import "WaitHandledAssignTaskDetailsTableViewController.h"

@interface WaitHandledDailyTaskDetailsTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate,UITextFieldDelegate,KeyboardToolBarDelegate,UIAlertViewDelegate>{
    
    __weak IBOutlet UILabel *lbTitle;
    __weak IBOutlet UILabel *lbType;
    __weak IBOutlet UILabel *lbToUser;
    __weak IBOutlet UILabel *lbArea;
    __weak IBOutlet UILabel *lbStartTime;
    __weak IBOutlet UILabel *lbEndTime;
    __weak IBOutlet UITextView *txtRemark;
    
    NSMutableArray *controlArray;
    UIButton *selectedButton;
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
     NSMutableDictionary *storeDict;
    
    WaitHandledTaskStandardSectionViewController * sectionViewController;
    WaitHandledAssignTaskStandardSectionViewController *assignTaskSectionViewController;
    BOOL isShowHUD;
    
    //标准执行动作，放在列表最上面的
    NSMutableArray *standardActionArray;
    //步骤执行动作
    NSMutableArray *stepActionArray;
}

@end

@implementation WaitHandledDailyTaskDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    storeDict = [[VariableStore sharedInstance] getWaitHandledData:_taskDict];
    standardActionArray = [NSMutableArray new];
    stepActionArray = [NSMutableArray new];
    for (NSDictionary *d in [storeDict objectForKey:@"step"]) {
        if([[d objectForKey:@"c_ismatch"] boolValue])
            [standardActionArray addObject:d];
        else
            [stepActionArray addObject:d];
    }
    
    NSDictionary *dict = [storeDict objectForKey:@"task"];
    
    lbTitle.text = [dict objectForKey:@"c_task_name"];
    lbType.text = [dict objectForKey:@"c_task_typename"];
    lbToUser.text = [[[NetDown shareTaskDataMgr] userInfo] objectForKey:@"displayname" ];
    lbArea.text = [dict objectForKey:@"areaname"];
    lbStartTime.text = [dict objectForKey:@"c_start_time"];
    lbEndTime.text = [dict objectForKey:@"c_end_time"];
    controlArray=[NSMutableArray new];  //给输入文本框用的， 当页面取消后可以找到并取消添加的输入侦听
    
    txtRemark.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtRemark.layer.borderWidth = 0.3;
    txtRemark.layer.cornerRadius = 3;
    txtRemark.layer.masksToBounds = YES;
    txtRemark.text = [dict objectForKey:@"c_handle_des"];

    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitTask)];
    [rightButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [KeyboardToolBar registerKeyboardToolBarWithTextView:txtRemark];
    [KeyboardToolBar shareKeyboardToolBar].inputViewDelegate = self;
    
    assignTaskSectionViewController = [[WaitHandledAssignTaskStandardSectionViewController alloc] initWithNibName:@"WaitHandledAssignTaskStandardSectionViewController" bundle:nil];
    sectionViewController  = [[WaitHandledTaskStandardSectionViewController alloc] initWithNibName:@"WaitHandledTaskStandardSectionViewController" bundle:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    if(sectionViewController)
        [sectionViewController.goDetailsButton addTarget:self action:@selector(showTaskStandard:) forControlEvents:UIControlEventTouchUpInside];
    if(assignTaskSectionViewController){
        [assignTaskSectionViewController.goDetailsButton addTarget:self action:@selector(showAssignTaskDesc) forControlEvents:UIControlEventTouchUpInside];
        [assignTaskSectionViewController.addStepButton addTarget:self action:@selector(showAddStepOption) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)submitTask{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"您确定提交当前任务！" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确 定", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex){
        if(!self.isSubmitErrorLaunch && [self analyzingAbnormality]){
            UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"隐 藏" destructiveButtonTitle:@"隐患反馈" otherButtonTitles:nil];
            actionSheet.tag=20;
            [actionSheet showInView:self.view];

        }
        else
            [self submitResult];
    }
}
//判断异常情况
-(BOOL)analyzingAbnormality{
    //判断点选里面有没有异常
    BOOL isFail = NO;
    for (NSDictionary *d in [storeDict objectForKey:@"step"]) {
        NSInteger typeId = [[d objectForKey:@"c_tracefunid"] intValue];
        NSString *result = [d objectForKey:@"c_result"];
        if(typeId == 11 && result && [result isEqualToString:@"异常"]){
            isFail = YES;
            break;
        }
    }
    return isFail;
}
-(void)submitResult{
    NSString *errorInfo;
    if(![self validateSubmitResult:&errorInfo]){
        [self showMsg:errorInfo];
        return;
    }
    [self taskTerminated];
}
-(void)taskTerminated{
    //任务上传该接口需调用两次  第一次为bFinish为0 第二次调用除了bFinish为1后其他参数不变
    BOOL flag = [[NetUp shareTaskDataMgr] UpNormalTask:[storeDict objectForKey:@"task"] StepArray:[storeDict objectForKey:@"step"] finish:0];
    if(!flag){
        [self showMsg:@"提交信息错误 1＃！"];
        return;
    }
    flag = [[NetUp shareTaskDataMgr] UpNormalTask:[storeDict objectForKey:@"task"] StepArray:[storeDict objectForKey:@"step"] finish:1];
    if(!flag){
        [self showMsg:@"提交信息错误 1＃！"];
        return;
    }
    [self showMsg:@"提交成功！"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WaitHandledTableViewController *controller = self.navigationController.viewControllers[0];
        [controller setIsFresh:YES];
        [[NetDown shareTaskDataMgr] delUpTask:[[storeDict objectForKey:@"task"] objectForKey:@"c_task_id"] TaskType:_isCustomize?1:0];
        [self.navigationController popToViewController:controller animated:YES];
    });
}
-(BOOL)validateSubmitResult:(NSString**)errorInfo{
    if(!storeDict){
        *errorInfo = @"空数据！！！";
        return false;
    }
    NSDictionary *taskDict = [storeDict objectForKey:@"task"];
    NSArray *stepArray = [storeDict objectForKey:@"step"];
    
    if(!taskDict){
        *errorInfo = @"空数据！！！";
        return false;
    }
    if(!stepArray){
        *errorInfo = @"空数据！！！";
        return false;
    }
    
    for (NSDictionary *d in stepArray) {
        NSString *result = [d objectForKey:@"c_result"];
        if(!result || result.length < 1){
            *errorInfo = @"您还有步骤没有做完，无法提交！";
            return false;
        }
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_isCustomize)
        return assignTaskSectionViewController.view;
    else if([standardActionArray count] > 0)
        return sectionViewController.view;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_isCustomize)
        return 120;
    else if([standardActionArray count] > 0)
        return 60;
    return 1.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[storeDict objectForKey:@"step"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isCustomize || indexPath.row < [standardActionArray count])
        return 110;
//    NSDictionary *dict = [[storeDict objectForKey:@"step"] objectAtIndex:indexPath.row];
//    if([[dict objectForKey:@"c_ismatch"] boolValue])
//        return 110;
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identityString;
//    NSDictionary *dict = [[storeDict objectForKey:@"step"] objectAtIndex:indexPath.row];
//    BOOL ismatch = [[dict objectForKey:@"c_ismatch"] boolValue];
    NSDictionary *dict;
    BOOL ismatch = indexPath.row < [standardActionArray count];
    if(ismatch)
        dict = [standardActionArray objectAtIndex:indexPath.row];
    else
        dict = [stepActionArray objectAtIndex:indexPath.row - [standardActionArray count]];
    
    if(_isCustomize)
        identityString = @"assignTaskIdentifier";
    else if(ismatch)
        identityString = @"dailiTaskStandardIdentifier";
    else
        identityString = @"dailiTaskIdentifier";
  
    WaitHandledDailyTaskDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityString forIndexPath:indexPath];
//    if(indexPath.row < [standardActionArray count] && [standardActionArray count] == indexPath.row + 1)
//        cell.lineImageView.hidden = NO;
//    else
    if([standardActionArray count] > 0 && indexPath.row + 1 < [standardActionArray count])
        cell.lineImageView.hidden = YES;
    else
        cell.lineImageView.hidden = NO;
    NSLog(@"%lu",(unsigned long)[standardActionArray count]);
    NSLog(@"%lu",(unsigned long)indexPath.row);
//    NSString *numberString = [VariableStore translation:[NSString stringWithFormat:@"%lu",indexPath.row - [standardActionArray count] + 1]];
////    NSString * stepContent = [NSString stringWithFormat:@"步骤 %ld  ",(long)indexPath.row - [standardActionArray count] + 1];
//    NSString * stepContent =[NSString stringWithFormat:@"步骤 %@  ",numberString];
    if(!ismatch){
        NSString *numberString = [VariableStore translation:[NSString stringWithFormat:@"%lu",indexPath.row - [standardActionArray count] + 1]];
        NSString * stepContent =[NSString stringWithFormat:@"步骤 %@  ",numberString];
        [cell.stepButton setTitle:stepContent forState:UIControlStateNormal];
    }
    if(!_isCustomize)
        cell.contentLabel.text = [dict objectForKey:@"c_step_prompt"];
    NSInteger typeId = [[dict objectForKey:@"c_tracefunid"] intValue];
    
    ///结果值
    NSString *resultString = [dict objectForKey:@"c_result"];
    if(resultString){
        cell.statueLabel.text = @"已完成";
        cell.statueLabel.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        cell.statueLabel.text = @"待执行";
        cell.statueLabel.backgroundColor = [VariableStore hexStringToColor:@"#80c9ff"];
    }
    cell.actionLabel.textColor = [UIColor darkGrayColor];
    //10 是文本输入
    if(typeId == 10){
        cell.normalSwitch.hidden = YES;
        cell.actionButton.hidden = YES;
        cell.actionImageView.hidden=YES;
        cell.actionLabel.hidden=YES;
        cell.actionTextInput.hidden = NO;
        
//        [KeyboardToolBar registerKeyboardToolBarWithTextField:cell.actionTextInput];
        [controlArray addObject:cell.actionTextInput];
        cell.actionTextInput.delegate = self;
        cell.actionTextInput.tag = indexPath.row;
        if(resultString)
            cell.actionTextInput.text = resultString;
    }
    //11 点判断
    else if(typeId == 11){
        cell.normalSwitch.hidden = NO;
        cell.actionButton.hidden = YES;
        cell.actionImageView.hidden=YES;
        cell.actionTextInput.hidden=YES;
        cell.actionLabel.hidden=NO;
        
        cell.normalSwitch.tag = indexPath.row;
        [cell.normalSwitch addTarget:self action:@selector(saveSwitchStatue:) forControlEvents:UIControlEventValueChanged];
        
        if(resultString){
            cell.normalSwitch.on = [resultString isEqualToString:@"正常"] ? YES : NO ;
            cell.actionLabel.text = resultString;
        }
        else
            cell.actionLabel.hidden = YES;
    }
    // 1 拍照 2 录音 3 录视频 10 文本 11  判断检查结果 20 扫码 30 gps
    else{
        cell.actionButton.hidden = NO;
        cell.actionTextInput.hidden=YES;
        cell.normalSwitch.hidden = YES;
        
        cell.actionLabel.hidden=YES;
        cell.actionImageView.hidden = YES;
        
        switch (typeId) {
            case 1:{
                [cell.actionButton setImage:[[UIImage imageNamed:@"ic_option_camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                if(resultString){
                    cell.actionLabel.hidden=YES;
                    cell.actionImageView.hidden = NO;
                    NSURL *url = [NSURL fileURLWithPath:resultString];
                    [cell.actionImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"no_img"] options:SDWebImageProgressiveDownload];
                }
                break;
            }
            case 2:{
                [cell.actionButton setImage:[[UIImage imageNamed:@"ic_option_audio"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                if(resultString){
                    cell.actionLabel.hidden=YES;
                    cell.actionImageView.hidden = NO;
                    cell.actionImageView.image = [UIImage imageNamed:@"ic_file_audio_img"];
                }
                break;
            }
            case 3:{
                [cell.actionButton setImage:[[UIImage imageNamed:@"ic_option_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                if(resultString){
                    cell.actionLabel.hidden=YES;
                    cell.actionImageView.hidden = NO;
                    cell.actionImageView.image = [UIImage imageNamed:@"ic_file_video_img"];
                }
                break;
            }
            case 20:{
                [cell.actionButton setImage:[[UIImage imageNamed:@"c_codescan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                if(resultString){
                    cell.actionLabel.hidden=NO;
                    cell.actionImageView.hidden = YES;
                    cell.actionLabel.text = @"详情";
                    cell.actionLabel.textColor = [VariableStore getSystemBackgroundColor];
                }
                
                break;
            }
            case 30:{
                [cell.actionButton setImage:[[UIImage imageNamed:@"c_gps"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                if(resultString){
                    cell.actionLabel.hidden=NO;
                    cell.actionImageView.hidden = YES;
                    cell.actionLabel.text = resultString;
                }
                break;
            }
            default:
                break;
        }
        
        cell.actionButton.tag = indexPath.row;
        [cell.actionButton addTarget:self action:@selector(actionButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [KeyboardToolBar registerKeyboardToolBarWithTextField:cell.actionTextInput];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchUp:)];
    cell.actionImageView.tag = indexPath.row;
    [cell.actionImageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showResultString:)];
    cell.actionLabel.tag = indexPath.row;
    [cell.actionLabel addGestureRecognizer:singleTap2];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIControl *control in controlArray){
        if([control isKindOfClass:[UITextField class]])
            [KeyboardToolBar unregisterKeyboardToolBarWithTextField:(UITextField*)control];
        if([control isKindOfClass:[UITextView class]])
            [KeyboardToolBar unregisterKeyboardToolBarWithTextView:(UITextView*)control];
    }
    [controlArray removeAllObjects];
}

-(void)actionButtonOnclick:(id)sender{
    selectedButton = sender;
//    NSDictionary *dict = [[storeDict objectForKey:@"step"] objectAtIndex:selectedButton.tag];
    NSDictionary *dict;
    BOOL ismatch = selectedButton.tag < [standardActionArray count];
    if(ismatch)
        dict = [standardActionArray objectAtIndex:selectedButton.tag];
    else
        dict = [stepActionArray objectAtIndex:selectedButton.tag - [standardActionArray count]];
    
    NSInteger typeId = [[dict objectForKey:@"c_tracefunid"] intValue];
    NSLog(@"tag:%ld",(long)typeId);
    
    switch (typeId) {
        case 1:
            [self takePhoto];
            break;
        case 2:
            [self takeRecorder];
            break;
        case 3:
            [self takeVideo];
            break;
        case 10:
            //text
            break;
        case 20:
            [self saomiaoAction];
            break;
        case 30:
            //gps
            [self startGPS];
            break;
        default:
            break;
    }
}

#pragma mark - 扫描二维码
-(void)saomiaoAction
{
    
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){

        NSLog(@"code return result:%@",qrString);
        
        NSDictionary *dict;
        BOOL ismatch = selectedButton.tag < [standardActionArray count];
        if(ismatch){
            dict = [standardActionArray objectAtIndex:selectedButton.tag];
            NSString *c_qrcode = [dict objectForKey:@"c_qrcode"];
            if(![c_qrcode isEqualToString:qrString]){
                [self performSelectorOnMainThread:@selector(scanCodeError) withObject:nil waitUntilDone:YES];
                return;
            }
        }
        [self performSelectorOnMainThread:@selector(saveSCanInformation:) withObject:qrString waitUntilDone:YES];
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
    
}
-(void)scanCodeError{
    [self showMsg:@"扫码对象有误！"];
}
#pragma mark - 录音（mp3）
-(void)takeRecorder{
    RecoderViewController *avrecodeviewcontroller=[[RecoderViewController alloc]init];
    avrecodeviewcontroller.AVRecoderSuncessBlock = ^(RecoderViewController *recoderview,NSString *pathString){
        NSLog(@"mp3 path:%@",pathString);
        [self saveAudio:pathString];
    };
    [self presentViewController:avrecodeviewcontroller animated:YES completion:nil];
}
#pragma mark - 拍照方法
-(void)takePhoto{
    //屏蔽从照片库选取照片
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"相 机" otherButtonTitles:@"照片库", nil];
    actionSheet.tag=1;
    [actionSheet showInView:self.view];
}

#pragma mark - 视频方法
-(void)takeVideo{
    //屏蔽从照片库选取照片
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"拍摄视频" otherButtonTitles:@"资料库", nil];
    actionSheet.tag=0;
    [actionSheet showInView:self.view];

}
//1 拍照 2 录音 3 录视频 10 文本 11  判断检查结果 20 扫码 30 gps
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //10 委派任务自定义添加选项
    if(actionSheet.tag == 10){
        switch (buttonIndex) {
            case 0:
                [self addStepToTask:1 withTypeName:@"拍照" withFunFile:YES];
                break;
            case 1:
                [self addStepToTask:10 withTypeName:@"文本" withFunFile:NO];
                break;
            case 2:
                [self addStepToTask:20 withTypeName:@"扫码" withFunFile:NO];
                break;
            case 3:
                [self addStepToTask:30 withTypeName:@"GPS位置信息" withFunFile:NO];
                break;
            default:
                break;
        }
    }
    //20 提交判断是否有异常，并作相关处理
    else if (actionSheet.tag == 20){
        if(buttonIndex == 0){
            SafetyViewController * controller = [SafetyViewController new];
            controller.parameters = [storeDict objectForKey:@"task"];
            [self.navigationController pushViewController:controller animated:YES];
        }
//        else if (buttonIndex == 1){
//            [self taskTerminated];
//        }
    }
    else{
        if(buttonIndex == 0 || buttonIndex == 1){
            [self itemPhotographButtonOnclick:buttonIndex withTypeImage:actionSheet.tag];
        }
    }
}
-(void)itemPhotographButtonOnclick:(NSInteger)typeId withTypeImage:(BOOL)isPicture{
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }
    
    //创建图像选取控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    if(!typeId)
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:isPicture?(NSString*)kUTTypeImage:(NSString*)kUTTypeMovie, nil];
    //允许用户进行编辑
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark - Camera View Delegate Methods
//点击相册中的图片或者照相机照完后点击use 后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    [picker dismissViewControllerAnimated:YES completion:nil];//关掉照相机
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
    //把选中的图片添加到界面中
        [self performSelectorOnMainThread:@selector(saveCamera:) withObject:image waitUntilDone:YES];
    }
    else{
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *path = [[mediaURL absoluteString] substringFromIndex:[@"file://" length]];
        [self performSelectorOnMainThread:@selector(saveVedio:) withObject:path waitUntilDone:YES];
    }
}

//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.text.length < 1){
        return;
    }
    NSLog(@"textfeild tag:%ld",(long)textField.tag);
    [self performSelectorOnMainThread:@selector(saveTextFieldInput:) withObject:textField waitUntilDone:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1)
        return;
    [self performSelectorOnMainThread:@selector(saveRemark) withObject:nil waitUntilDone:YES];
}


#pragma mark - GPS
-(void)startGPS{
    if(!locationManager){
        locationManager=[[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10;
//        if ([UIDevice ]>=8) {
            [locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
//        }
    }
    [locationManager startUpdatingLocation];//开启定位
    
    isShowHUD = YES;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD =[[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"正在获取当前位置信息...";
    [HUD showWhileExecuting:@selector(idleProcess) onTarget:self withObject:nil animated:YES];
//    [self showMsg:@"正在获取当前位置信息..."];
}
-(void)idleProcess{
    while (isShowHUD) {
        sleep(1);
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation* location = [locations lastObject];
    NSLog(@"location:%f%f",location.coordinate.latitude,location.coordinate.longitude);
    
    if(!geocoder){
        geocoder = [[CLGeocoder alloc] init];
    }
    //2.反地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
            NSLog(@"你输入的地址没找到，可能在月球上");

        }else//编码成功
        {
            //显示最前面的地标信息
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            [locationManager stopUpdatingLocation];
            isShowHUD = NO;
            [self performSelectorOnMainThread:@selector(saveLocationInformation:) withObject:firstPlacemark.name waitUntilDone:YES];
        }
    }];
}

#pragma mark - 保存数据
//把图片添加到当前view中
- (void)saveCamera:(UIImage *)image {
    WaitHandledDailyTaskDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedButton.tag inSection:0]];
    cell.actionImageView.image = image;
    cell.actionImageView.hidden = NO;
    cell.actionLabel.hidden = YES;
    NSString *savePath;
    [[VariableStore sharedInstance] saveImage:image withScale:0.3 savePath:&savePath];
    if(!savePath)
        NSLog(@"save image error!");
    else
        NSLog(@"save image path:%@",savePath);
    
    [self saveCellResultAtIndex:selectedButton.tag resultString:savePath resultType:1];
}
-(void)saveAudio:(NSString*)path{
    WaitHandledDailyTaskDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedButton.tag inSection:0]];
    cell.actionImageView.image = [UIImage imageNamed:@"ic_file_audio_img"];
    cell.actionImageView.hidden = NO;
    cell.actionLabel.hidden = YES;
    [self saveCellResultAtIndex:selectedButton.tag resultString:path resultType:2];
}
-(void)saveVedio:(NSString*)path{
    WaitHandledDailyTaskDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedButton.tag inSection:0]];
    cell.actionImageView.image = [UIImage imageNamed:@"ic_file_video_img"];
    cell.actionImageView.hidden = NO;
    cell.actionLabel.hidden = YES;
    [self saveCellResultAtIndex:selectedButton.tag resultString:path resultType:3];
}
-(void)saveSCanInformation:(NSString*)string{
    [self saveCellResultAtIndex:selectedButton.tag resultString:string resultType:20];
}
-(void)saveLocationInformation:(NSString*)string{
    [self saveCellResultAtIndex:selectedButton.tag resultString:string resultType:30];
}

-(void)saveTextFieldInput:(id)control{
    UITextField *textField = control;
    [self saveCellResultAtIndex:textField.tag resultString:textField.text resultType:10];
}

-(void)saveRemark{
    NSMutableDictionary *dict = [storeDict objectForKey:@"task"];
    [dict setObject:txtRemark.text forKey:@"c_handle_des"];
    [[VariableStore sharedInstance] setWaitHandledWithSourceData:storeDict withHandledStatus:YES];
}
-(void)saveSwitchStatue:(id)sender{
    UISwitch *button = sender;
    NSLog(@"switch value change:%@",button.on?@"正常":@"异常");
    [self saveCellResultAtIndex:button.tag resultString:button.on?@"正常":@"异常" resultType:11];
}

#pragma mark - save dictionary
//1 拍照 2 录音 3 录视频 10 文本 11  判断检查结果 20 扫码 30 gps
-(void)saveCellResultAtIndex:(NSInteger)index resultString:(NSString*)result resultType:(NSInteger)type{
    WaitHandledDailyTaskDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if(type == 30){
        cell.actionLabel.text = result;
        cell.actionLabel.hidden = NO;
    }
    if(type == 20){
        cell.actionLabel.text = @"详情";
        cell.actionLabel.textColor = [VariableStore getSystemBackgroundColor];
        cell.actionLabel.hidden = NO;
    }

//    NSMutableDictionary *dict = [[storeDict objectForKey:@"step"] objectAtIndex:index];
    NSMutableDictionary *dict;
    BOOL ismatch = index < [standardActionArray count];
    if(ismatch)
        dict = [standardActionArray objectAtIndex:index];
    else
        dict = [stepActionArray objectAtIndex:index - [standardActionArray count]];
    
    
    [dict setObject:result forKey:@"c_result"];
    
    //保存执行任务数据集合
    [[VariableStore sharedInstance] setWaitHandledWithSourceData:storeDict withHandledStatus:YES];
    cell.statueLabel.text = @"已完成";
    cell.statueLabel.backgroundColor = [UIColor lightGrayColor];
}
-(void)showResultString:(UITapGestureRecognizer *)recognizer{
    NSDictionary *dict;
    BOOL ismatch = recognizer.view.tag < [standardActionArray count];
    if(ismatch)
        dict = [standardActionArray objectAtIndex:recognizer.view.tag];
    else
        dict = [stepActionArray objectAtIndex:recognizer.view.tag - [standardActionArray count]];
    NSInteger typeId = [[dict objectForKey:@"c_tracefunid"] intValue];
    if(typeId != 20)
        return;
    ///结果值
    NSString *result = [dict objectForKey:@"c_result"];
    if(!result || result.length < 1)
        return;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫码信息" message:result delegate:nil cancelButtonTitle:nil otherButtonTitles:@"关 闭", nil];
    [alertView show];
}

-(void)onTouchUp:(UITapGestureRecognizer *)recognizer{
//    NSLog(@"UITapGestureRecognizer Tag:%ld",recognizer.view.tag);
    WaitHandledDailyTaskDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:recognizer.view.tag inSection:0]];
//    NSDictionary *dict = [[storeDict objectForKey:@"step"] objectAtIndex:recognizer.view.tag];
    NSDictionary *dict;
    BOOL ismatch = recognizer.view.tag < [standardActionArray count];
    if(ismatch)
        dict = [standardActionArray objectAtIndex:recognizer.view.tag];
    else
        dict = [stepActionArray objectAtIndex:recognizer.view.tag - [standardActionArray count]];
    
    NSInteger typeId = [[dict objectForKey:@"c_tracefunid"] intValue];
    ///结果值
    NSURL *url = [NSURL fileURLWithPath:[dict objectForKey:@"c_result"]];
    switch (typeId) {
        case 1:
            [[VariableStore sharedInstance] showImageView:cell.actionImageView fromUrl:url];
            break;
        case 2:
            [[VariableStore sharedInstance] playMedia:url];
            break;
        case 3:
            [[VariableStore sharedInstance] playMedia:url];
            break;
    
        default:
            break;
    }

}
//1 拍照 2 录音 3 录视频 10 文本 11  判断检查结果 20 扫码 30 gps
#pragma mark - 添加委派执行步骤

-(void)showAddStepOption{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"拍 照" otherButtonTitles:@"文本输入",@"扫 描",@"GPS 定位", nil];
    actionSheet.tag=10;
    [actionSheet showInView:self.view];
}

-(void)addStepToTask:(int)typeId withTypeName:(NSString*)typeName withFunFile:(BOOL)isFile{
    NSMutableArray *array = [storeDict objectForKey:@"step"];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"" forKey:@"areaname"];
    [dict setValue:@"" forKey:@"c_actitem_id"];
    [dict setValue:@"" forKey:@"c_area"];
    [dict setValue:@"" forKey:@"c_getdata_pretext"];
    [dict setValue:@"" forKey:@"c_getdata_text"];
    [dict setValue:@"" forKey:@"c_getdata_unit"];
    [dict setValue:@"" forKey:@"c_groupindex"];
    [dict setValue:@"" forKey:@"c_id"];
    [dict setValue:@"" forKey:@"c_ismatch"];
    [dict setValue:@"" forKey:@"c_obj_id"];
    [dict setValue:@"" forKey:@"c_obj_name"];
    [dict setValue:@"" forKey:@"c_objtype_code"];
    [dict setValue:@"" forKey:@"c_objtype_fullname"];
    [dict setValue:@"" forKey:@"c_objtype_id"];
    [dict setValue:@"" forKey:@"c_objtype_name"];
    [dict setValue:@"0" forKey:@"c_status"];
    [dict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[array count]] forKey:@"c_step_index"];
    [dict setValue:@"" forKey:@"c_step_media"];
    [dict setValue:@"" forKey:@"c_step_prompt"];
    [dict setValue:@"" forKey:@"c_step_std"];
    [dict setValue:isFile?@"1":@"0" forKey:@"c_tracefun_isfile"];
    [dict setValue:typeName forKey:@"c_tracefun_name"];
    [dict setValue:[NSString stringWithFormat:@"%d",typeId] forKey:@"c_tracefunid"];
    
    [array addObject:dict];
    [stepActionArray addObject:dict];
    [[VariableStore sharedInstance] setWaitHandledWithSourceData:storeDict withHandledStatus:NO];
    [self.tableView reloadData];
}

#pragma mark - 查看标准
-(void)showTaskStandard:(id)sender{
    [self performSegueWithIdentifier:@"showTaskStandardSegue" sender:self];
}
#pragma mark - 委派任务查看任务信息
-(void)showAssignTaskDesc{
    [self performSegueWithIdentifier:@"showAssignTaskDescSegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showTaskStandardSegue"]){
        WaitHandledTaskStandardDetailsViewController *controller = segue.destinationViewController;
        NSDictionary *dict = [[storeDict objectForKey:@"stditem"] firstObject];
        NSString *string = [NSString stringWithFormat:@"<h4>一.要做什么</h4><p>%@</p><h4>二.执行标准</h4><p>%@ </p><h4>三.异常怎么处置(执行环节)</h4><p>%@</p><h4>四.验证标准</h4><p>%@</p><h4>五.异常怎么处置(验证环节)</h4>%@ <h4>六.评价标准</h4><p>%@</p><!-- <h4>七.制度文件</h4> -->",[dict objectForKey:@"c_actitem_what"],[dict objectForKey:@"c_std"],[dict objectForKey:@"c_err_std"],[dict objectForKey:@"c_check_std"],[dict objectForKey:@"c_err_check"],[dict objectForKey:@"c_std_review"]];

        controller.tt = string;
    }
    if([segue.identifier isEqualToString:@"showAssignTaskDescSegue"]){
        WaitHandledAssignTaskDetailsTableViewController *controller = segue.destinationViewController;
        controller.taskDict = _taskDict;
    }
}
#pragma mark - MBProgressHUD Delegate
-(void)showMsg:(NSString*)msg{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD =[[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = msg;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
}
@end
