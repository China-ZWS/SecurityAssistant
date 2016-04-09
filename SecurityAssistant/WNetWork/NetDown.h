//
//  NetDown.h
//  SecurityAssistant
//
//  Created by Jeast on 16-2-29.
//  Copyright (c) 2016年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define SERVERADDR @"http://192.168.143.35:8080"    //内网服务器
//#define SERVERADDR @"http://ppd.talkweb.com.cn:7001"  //正式
//#define SERVERADDR @"http://ppd.talkweb.com.cn:8441" //长烟测试服务器

@interface NetDown : NSObject
{
    void(*setAction_Func) (NSDictionary*);
    NSError* error;
}

@property(nonatomic,strong)NSDictionary* userInfo;  //存放用户信息
@property(nonatomic,strong)NSMutableDictionary* dayTaskDic; //存放日常任务（不包含异常任务） 以任务ID（c_task_id）为key
@property(nonatomic,strong)NSMutableDictionary* assignTaskDic; //存放委派任务（不包含异常任务） 以任务ID（c_task_id）为key
@property(nonatomic,strong)NSMutableDictionary* fbTaskDic; //存放异常任务
@property(nonatomic,strong)NSMutableDictionary* msgDic; //存放消息
@property(nonatomic,strong)NSArray* fbTrackArray; //存放异常跟踪信息
@property(nonatomic,strong)NSMutableDictionary* basicDataDic; //存放基础数据 已剔除掉被删除的数据
@property(nonatomic,strong)NSMutableArray* areaArray; //存放区域信息数组



//创建单实例类
+(id) shareTaskDataMgr;

-(BOOL)doLogin:(NSString*)userName password: (NSString *) userPassword; //登录验证

-(void)getFBTrackInfo:(NSUInteger)fbType; //获取反馈跟踪信息 1 反馈| 2 处理| 3 抄送

-(void)getAllServerTask; //循环完全下载服务端待办标准及临时任务信息（异常任务除外）

-(void)delUpTask:(NSString*)taskID TaskType:(int)taskType; //删除已上传的任务 0 日常任务 1 委派任务 2 隐患任务

-(void)getAllServerMsg; //下载消息

-(void)getFbList;  //获取异常任务列表，获取列表后下载异常任务

-(void)updateBasicData; //获取、更新基础数据（组织结构）

-(void)msgStateChange:(NSString*)ID READ:(BOOL)bRead;  //消息已读状态更改


@end
