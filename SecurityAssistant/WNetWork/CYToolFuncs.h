//
//  CYToolFuncs.h
//  CY-Pass
//
//  Created by Jeast on 14-2-26.
//  Copyright (c) 2014年 Jeast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "sys/utsname.h"

#import "Reachability.h"   //判断网络连接头文件

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

//#import "CYCoreData.h"
#import <CoreData/CoreData.h>


#import <ifaddrs.h>
#import <arpa/inet.h>

#define X [[UIScreen mainScreen]bounds].size.width
#define Y [[UIScreen mainScreen]bounds].size.height

#define STD 1
#define UNSTD 0
#define FINISH 2
#define LAUNCH 3

#define RED [UIColor redColor]
#define GREEN [UIColor greenColor]
#define LIGHTGRREEN [UIColor colorWithRed:(223.0f/255.0f) green:(253.0f/255.0f) blue:(223.0f/255.0f) alpha:1.0f]
#define LIGHTGRREEN2 [UIColor colorWithRed:(134.0f/255.0f) green:(196.0f/255.0f) blue:(64.0f/255.0f) alpha:1.0f]

#define STARTDOWDTASK @"startDownTask"
#define STOPDOWDTASK @"stopDownTask"



extern BOOL bUpdate;

@interface CYToolFuncs : NSObject
{
    
}


+(NSDictionary *)returnStepDic:(NSString*)stepIndex AreaName:(NSString*)areaName ActItem:(NSString*)actItem StepPrompt:(NSString*)stepPrompt ActionIndex:(NSString*)actionIndex;

+(NSDictionary *)returnTaskDic:(NSString*)taskName AreaName:(NSString*)areaName section:(NSString*)section type:(NSString*)typeName ctrl:(NSString*)isCtrl sequence:(NSString*)isSequence endTime:(NSString*)endTime std:(NSString*)isStd;

+(NSDictionary *)returnStdDic:(NSString*)stdName What:(NSString*)what std:(NSString*)Std Check:(NSString*)check Error:(NSString*)err;

+(NSString *)CvtIntToStr:(NSInteger)param;

+(int)CvtStrToInt:(NSString*)param;

+(NSString *)CvtBoolToStr:(NSString*)param;

+(NSString *)returnStepIndex:(NSString*)param;

+(NSString *)returnActionIndex:(NSString*)param;

+(NSString *)FilePath:(NSInteger)iSignal;

+(void)AlertShow:(NSString*)title Context:(NSString*)context;

+(void)startActivityView:(id)target;

+(void)stopActivityView;

+(UILabel*)FailTitleView;

+(UILabel*)GettingTitleView;

+(UILabel*)NormalTitleView:(NSString*)titleStr;

+(NSString*)getDeviceVersion;

+(void)itemClick:(UINavigationController*)navigationController;

+(NSString *)generateUuidString;

+(void)arraySort:(NSMutableArray**)arr;

+(NSString*)encodeString:(NSString*)str :(NSString*)key;

+(BOOL) isConnectionAvailable;

+(NSString*)getIP;

+(NSData*) DicToData:(id)dic;

+(NSDictionary*) DataToDic:(NSData*)data;

+(void)ShowIfStart;

+(float)GetContextHeight:(NSString*)strContext Font:(UIFont*)strFont Width:(float)fWidth;

+(void)deleteFile:(id)filePath; //删除文件

+(NSArray*)analysisFiles:(NSArray*)arr;

+(bool) isExistTaskId:(NSMutableDictionary*)taskDict ID:(NSString *)taskid;


@end
















