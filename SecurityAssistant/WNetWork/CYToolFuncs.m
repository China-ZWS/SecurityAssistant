//
//  CYToolFuncs.m
//  CY-Pass
//
//  Created by Jeast on 14-2-26.
//  Copyright (c) 2014年 Jeast. All rights reserved.
//

#import "CYToolFuncs.h"


@implementation CYToolFuncs

UIView *mainActivityView;
UIView *activityView;
UIActivityIndicatorView* activityIndicator;//活动指示器对象


+(NSDictionary *)returnStepDic:(NSString*)stepIndex AreaName:(NSString*)areaName ActItem:(NSString*)actItem StepPrompt:(NSString*)stepPrompt ActionIndex:(NSString*)actionIndex;
{
    NSArray *ObjectArray = [[NSArray alloc]initWithObjects:stepIndex,areaName,actItem,stepPrompt, actionIndex,nil];
    NSArray *KeyArray = [[NSArray alloc]initWithObjects:@"c_step_index",@"areaname",@"c_actitem_id",@"c_step_prompt", @"c_tracefunid",nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:ObjectArray forKeys:KeyArray];
    
    return dic;
}

+(NSDictionary *)returnTaskDic:(NSString*)taskName AreaName:(NSString*)areaName section:(NSString*)section type:(NSString*)typeName ctrl:(NSString*)isCtrl sequence:(NSString*)isSequence endTime:(NSString*)endTime std:(NSString*)isStd
{
    NSArray *ObjectArray = [[NSArray alloc]initWithObjects:taskName,areaName,section,typeName,isCtrl, isSequence,endTime,isStd,nil];
    NSArray *KeyArray = [[NSArray alloc]initWithObjects:@"c_task_name",@"areaname",@"c_manage_section_name",@"c_task_typename",@"c_iskeyctrl",@"c_issequence",@"c_urge_time", @"c_isstd",nil];
    NSDictionary *tempDic = [[NSDictionary alloc]initWithObjects:ObjectArray forKeys:KeyArray];
    
    return tempDic;
}

+(NSDictionary *)returnStdDic:(NSString*)stdName What:(NSString*)what std:(NSString*)Std Check:(NSString*)check Error:(NSString*)err
{
    NSArray *ObjectArray = [[NSArray alloc]initWithObjects:stdName,what,Std,check, err,nil];
    NSArray *KeyArray = [[NSArray alloc]initWithObjects:@"c_actitem_name",@"c_actitem_what",@"c_std",@"c_check_std", @"c_err_std",nil];
    NSDictionary *tempDic = [[NSDictionary alloc]initWithObjects:ObjectArray forKeys:KeyArray];
    return tempDic;
}

+(NSString *)returnStepIndex:(NSString*)param
{
    NSString *temp;
    switch ([param intValue]) {
        case 1:
            temp=@"步骤一";
            break;
        case 2:
            temp=@"步骤二";
            break;
        case 3:
            temp=@"步骤三";
            break;
        case 4:
            temp=@"步骤四";
            break;
        case 5:
            temp=@"步骤五";
            break;
        case 6:
            temp=@"步骤六";
            break;
        case 7:
            temp=@"步骤七";
            break;
        case 8:
            temp=@"步骤八";
            break;
        case 9:
            temp=@"步骤九";
            break;
            
        default:
            temp = [[NSString alloc]initWithFormat:@"步骤%d",[param intValue]];
            break;
    }
    return temp;
}

+(NSString *)returnActionIndex:(NSString*)param
{
    NSString *temp;
    switch ([param intValue]) {
        case 1:
            temp=@"操作一";
            break;
        case 2:
            temp=@"操作二";
            break;
        case 3:
            temp=@"操作三";
            break;
        case 4:
            temp=@"操作四";
            break;
        case 5:
            temp=@"操作五";
            break;
        case 6:
            temp=@"操作六";
            break;
        case 7:
            temp=@"操作七";
            break;
        case 8:
            temp=@"操作八";
            break;
        case 9:
            temp=@"操作九";
            break;
            
        default:
            temp = [[NSString alloc]initWithFormat:@"操作%d",[param intValue]];
            break;
    }
    return temp;
}

+(NSString *)CvtIntToStr:(NSInteger)param
{
    return [[NSString alloc]initWithFormat:@"%d",(int)param];
}

+(int)CvtStrToInt:(NSString*)param
{
    return [param intValue];
}

+(NSString *)CvtBoolToStr:(NSString*)param
{
    if ([param compare:@"0"]) {
        return @"否";
    }
    else
    {
        return @"是";
    }
}

+(NSString *)FilePath:(NSInteger)iSignal
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename;
    switch (iSignal) {
        case 0:
            filename=[plistPath stringByAppendingPathComponent:@"UpTask.plist"];
            break;
        case 1:
            filename=[plistPath stringByAppendingPathComponent:@"fTaskData.plist"];
            break;
        case 2:
            filename=[plistPath stringByAppendingPathComponent:@"sTaskData.plist"];
            break;
            
        default:
            filename=[plistPath stringByAppendingPathComponent:@"UpTask.plist"];
            break;
    }
    return filename;
}

+(void)AlertShow:(NSString*)title Context:(NSString*)context
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:context delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
    [alertView show];
}

+(void)startActivityView:(id)target
{
    mainActivityView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, X, Y)];
    [mainActivityView setBackgroundColor:[UIColor clearColor]];
    
    activityView = [[UIView alloc]initWithFrame:CGRectMake(110, (Y-100)*0.5, 100, 100)];
    [activityView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [activityView.layer setCornerRadius:8.0f];
    
    UILabel* textLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.f, 70.f, 50.f, 25.f)];
    [textLabel setText:@"请稍候..."];
    [textLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:12.0f]];
    [textLabel setTextAlignment:1];
    [activityView addSubview:textLabel];
    
    activityIndicator = [[UIActivityIndicatorView alloc] init];
    [activityIndicator setCenter:activityView.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [activityIndicator setColor:[UIColor redColor]];
//            [activityIndicator setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
//            [activityIndicator.layer setCornerRadius:10.0];
    [mainActivityView addSubview:activityView];
    [mainActivityView addSubview:activityIndicator];
    [target addSubview:mainActivityView];
    [activityIndicator startAnimating];
}

+(void)stopActivityView
{
    [activityIndicator stopAnimating];
    [mainActivityView removeFromSuperview];
}

+(UILabel*)FailTitleView
{
    UILabel* itemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 100, 30)];
//    [itemTitleLabel setTextColor:[UIColor colorWithRed:32.0f/255.0f green:138/255.0f blue:254.0f/255.0f alpha:0.8f]];
    [itemTitleLabel setTextColor:RED];
    [itemTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [itemTitleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:15.0f]];
    [itemTitleLabel setText:@"收取任务失败"];
    return itemTitleLabel;
}

+(UILabel*)GettingTitleView
{
    UILabel* itemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 100, 30)];
    [itemTitleLabel setTextColor:[UIColor colorWithRed:32.0f/255.0f green:138/255.0f blue:254.0f/255.0f alpha:0.8f]];
    [itemTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [itemTitleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:15.0f]];
    [itemTitleLabel setText:@"收取任务中..."];
    return itemTitleLabel;
}

+(UILabel*)NormalTitleView:(NSString*)titleStr
{
    UILabel* itemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 100, 24)];
//    [itemTitleLabel setTextColor:[UIColor colorWithRed:32.0f/255.0f green:138/255.0f blue:254.0f/255.0f alpha:0.8f]];
    [itemTitleLabel setTextAlignment:NSTextAlignmentCenter];
//    [itemTitleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:15.0f]];
    [itemTitleLabel setFont:[UIFont boldSystemFontOfSize:16.5f]];
    [itemTitleLabel setText:titleStr];
    return itemTitleLabel;
}

+(NSString*)getDeviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

//+(void)itemClick:(UINavigationController*)navigationController
//{
//    //用CATransition出现残影效果 原因待查
//    if(!bViewSignal)
//    {
//        [UIView beginAnimations:@"move" context:nil];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationDelegate:self];
//        //改变它的frame的x,y的值
//        navigationController.view.frame=CGRectMake(X-100,0, X,Y);
//        UIView* tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 100, Y-64.0f)];
//        [tempView setAlpha:0.1f];
//        [tempView setBackgroundColor:[UIColor clearColor]];
//        [UIView commitAnimations];
//        [navigationController.view addSubview:tempView];
//    }
//    else
//    {
//        [UIView beginAnimations:@"move" context:nil];
//        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationDelegate:self];
//        //改变它的frame的x,y的值
//        navigationController.view.frame=CGRectMake(0,0, X,Y);
//        [UIView commitAnimations];
//        [navigationController.view.subviews[[navigationController.view.subviews count]-1]removeFromSuperview];
//    }
//    bViewSignal = !(bViewSignal);
//}

//得到UUID
+(NSString *)generateUuidString{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

+(void)arraySort:(NSMutableArray**)arr
{
    [*arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *tm1=(NSString *)[(NSDictionary*)obj1 objectForKey:@"time"];
//        NSLog(@"%@",[(NSDictionary*)obj1 objectForKey:@"wDic"]);
        NSString *tm2=(NSString *)[(NSDictionary*)obj2 objectForKey:@"time"];
//        NSLog(@"%@",tm2);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date1=[formatter dateFromString:tm1];
        NSDate *date2=[formatter dateFromString:tm2];
        
        //        float i = [date1 timeIntervalSinceDate:date2];
        
        return [date2 timeIntervalSinceDate:date1];
    }];
//    NSLog(@"%@",*arr);
}

+(NSString*)encodeString:(NSString*)str :(NSString*)key{
    key = @"王东杰";
    NSString *result=[NSString string];
    for(int i=0; i < [str length]; i++){
        unichar chData=[str characterAtIndex:i];
        for(int j=0;j<[key length];j++){
            int chKey=[key characterAtIndex:j];
            chData=chData^chKey;
        }
        result=[NSString stringWithFormat:@"%@%@",result,[NSString stringWithFormat:@"%C",chData]];
    }
    return result;
}

+(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}

+(NSData*) DicToData:(id)dic
{
    //NSDictionary -> NSData:
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSDictionary* dc = (NSDictionary*)dic;
    [archiver encodeObject:dc forKey:@"Jeast"];
    [archiver finishEncoding];
    return data;
}

+(NSDictionary*) DataToDic:(NSData*)data
{
    //NSData -> NSDictionary
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Jeast"];
    [unarchiver finishDecoding];
    return myDictionary;
}

+(void)ShowIfStart
{
    [self AlertShow:@"提示" Context:@"请先点击手形按钮阅读该项工作的行为标准（或工作安排、或异常信息）"];
}

+(float)GetContextHeight:(NSString*)strContext Font:(UIFont*)strFont Width:(float)fWidth
{
    CGSize constraintSize= CGSizeMake(fWidth,MAXFLOAT);
    CGSize expectedSize = [strContext sizeWithFont:strFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    return expectedSize.height;
}

+(void)deleteFile:(id)filePath //删除文件
{
    NSArray* tempFileArray = [[NSArray alloc]init];
    if ([filePath isKindOfClass:[NSString class]])
        tempFileArray = @[filePath];
    else
        tempFileArray = [NSArray arrayWithArray:filePath];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* inFilePath;
    for(inFilePath in tempFileArray)
        [fileMgr removeItemAtPath:inFilePath error:nil];
}

+(NSArray*)analysisFiles:(NSArray*)arr
{
    //解析处理取证文件信息*************************************
    NSString* strCLID = [[NSString alloc]init];  //uuid
    NSString* strClFunIDs = [[NSString alloc]init]; //type
    NSMutableArray* clFileArray = [[NSMutableArray alloc]init];
    NSMutableArray* clIdArray = [[NSMutableArray alloc]init];
    
    if ([arr count]==0)
        return @[@"",@"",clFileArray];
    
    
    if([arr count]>0)
    {
        for (int i = 0; i<[arr count]; i++) {
            NSString* uuidString = [CYToolFuncs generateUuidString];
            [clIdArray addObject:uuidString];
            NSDictionary* tempFileDic = @{@"path":arr[i],@"uuid":uuidString};
            [clFileArray addObject:tempFileDic];
        }
    }
    if([clIdArray count]>0)
    {
        for (int i =0; i<[clIdArray count]; i++) {
            NSString* tempIdStr = [[NSString alloc]initWithFormat:@"%@",[clIdArray objectAtIndex:i]];
            if (i == 0) {
                strCLID = [strCLID stringByAppendingString:tempIdStr];
            }
            else
            {
                strCLID = [strCLID stringByAppendingString:@","];
                strCLID = [strCLID stringByAppendingString:tempIdStr];
            }
        }
    }
    else
        strCLID = @"";
    //-------------c_errtracefunids--------------  //c_errtracefunids 拍照：1 录音：2 视频：3
    if([clFileArray count]>0)
    {
        for (int i =0; i<[clFileArray count]; i++) {
            NSString* tempExtenStr = [[NSString alloc]init];
            if([[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"jpeg"] || [[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"jpg"] || [[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"png"])
                tempExtenStr = @"1";
            else if([[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"caf"] ||[[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"wav"] ||[[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"mp3"])
                tempExtenStr = @"2";
            else if([[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"mov"] ||[[[[clFileArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"mp4"])
                tempExtenStr = @"3";
            
            if (i == 0) {
                strClFunIDs = [strClFunIDs stringByAppendingString:tempExtenStr];
            }
            else
            {
                strClFunIDs = [strClFunIDs stringByAppendingString:@","];
                strClFunIDs = [strClFunIDs stringByAppendingString:tempExtenStr];
            }
        }
    }
    else
        strClFunIDs = @"";
    return @[strClFunIDs,strCLID,clFileArray];
}


+(NSString*)getIP
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


+(bool) isExistTaskId:(NSMutableDictionary*)taskDict ID:(NSString *)taskid{
    bool bFind = false;
    NSArray *arr = [taskDict allKeys];
    
    for (id key in arr ){
        if ( [key isEqualToString:taskid] ) {
            //            NSLog(@"%@ --- %@",key,taskid);
            bFind = true;
            break;
        }
    }
    return bFind;
}

@end

























