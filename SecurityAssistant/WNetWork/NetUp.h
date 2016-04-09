//
//  NetUp.h
//  SecurityAssistant
//
//  Created by Jeast on 16-3-1.
//  Copyright (c) 2016年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SERVERADDR @"http://ppd.talkweb.com.cn:7001"

//#define SERVERADDR @"http://192.168.143.35:8080"
@interface NetUp : NSObject
{
    NSError* error;
}
//创建单实例类
+(id) shareTaskDataMgr;

//上传任务（不包含异常任务）
//参数说明
//taskDic为任务字典中@"task"字典
//stepArray为任务字典中@"step"数组
//任务上传该接口需调用两次  第一次为bFinish为0 第二次调用除了bFinish为1后其他参数不变
-(BOOL)UpNormalTask:(NSDictionary*)taskDic StepArray:(NSArray*)stepArray finish:(BOOL)bFinish;

//异常任务提交
//tasktype 1 本人处理 2 安排整改 3 继续反馈 4 接收确认
//当没有文件提交是 fileArr为nil

/*本人处理
 NSArray* valueArr = @[@"20160112145628508",@"1265",@"1",@"2000412",@"1",@"284DD524-EE5B-461F-AA6C-02AF0F7211E5",@"处理完了",@"2000412",@"2000416"];
 NSArray* fileArr = @[@{@"path": [[paths objectAtIndex:0] stringByAppendingPathComponent:@"xiaohuangren.png"],@"uuid":@"284DD524-EE5B-461F-AA6C-02AF0F7211E5"}];
 [netUp UpExptTask:valueArr FileList:fileArr TaskType:1];
*/
/*安排整改
 NSArray* valueArr = @[@"20160112145628508",@"1265",@"2",@"2016-03-03 15:07:44",@"2000412",@"2000412",@"2000417",@"1",@"4EA313B5-B51C-4FF7-987C-A08017FB3F39",@"安排整改",@"2000412",@"2000416"];
 NSArray* fileArr = @[@{@"path": [[paths objectAtIndex:0] stringByAppendingPathComponent:@"xiaohuangren.png"],@"uuid":@"4EA313B5-B51C-4FF7-987C-A08017FB3F39"}];
 [netUp UpExptTask:valueArr FileList:fileArr TaskType:2];
 */
/*继续反馈
 NSArray* valueArr = @[@"20160112145628508",@"1265",@"0",@"2016-03-03 15:23:30",@"2000412",@"2000412",@"2000415,2000516",@"1",@"945E4E7B-AB19-4808-A6C4-7D7D53A041CC",@"继续反馈"];
 NSArray* fileArr = @[@{@"path": [[paths objectAtIndex:0] stringByAppendingPathComponent:@"xiaohuangren.png"],@"uuid":@"945E4E7B-AB19-4808-A6C4-7D7D53A041CC"}];
 [netUp UpExptTask:valueArr FileList:fileArr TaskType:3];
 */
/*接收确认
 NSArray* valueArr = @[@"1002"];
 [netUp UpExptTask:valueArr FileList:nil TaskType:4];
 */

-(BOOL)UpExptTask:(NSArray*)valueArr FileList:(NSArray*)fileArr TaskType:(int)taskType; //异常任务处理

/*发起任务 接口参数说明
file为文件信息数组 value为上传的表单值 key为上传的表单键 两数组元素需一一对应 key如下：
key =     (
           "c_task_type",
           "c_task_name",
           "c_manage_section",
           "c_start_time",
           "c_end_time",
           "c_exec_userid",
           "c_sender_userid",
           "c_remark",
           "c_cc_userid_list",
           "c_fileids"   //file数组中对应的uuid 以逗号,分割开
           );
dic如下：
file =     ({path = 	"/Users/Jeast/Library/ApplicationSupport/iPhoneSimulator/7.1/Applications/0CCFDC1D-388F-	4B2F-99E2-2ABC6C18E112/Documents/UpFile/1175/20160302103117503.jpeg";
    uuid = "D1F108E3-45A4-430D-9D63-31D781BD2B38";
}
            );
value =     (
             20,
             1,
             1,
             "2016-03-02 10:30:59",
             "2016-03-02 14:30:59",
             2000412,
             2000420,
             2,
             2000413,
             "D1F108E3-45A4-430D-9D63-31D781BD2B38"
             );*/

-(BOOL)LaunchTask:(NSArray*)valueArr FileList:(NSArray*)fileArr;  //发起任务

/*发起消息 接口参数说明 如下： arrValue元素需按照以下格式对应
key:
c_msg_title,
c_msg_content,
c_msg_type,
c_msg_level,
c_notify_type,
c_from,
c_create_time,
c_plan_time,
c_expiry_time,
c_send_type,
c_sender,
c_receiver,
c_remark,
c_pid

value:
工作提示,
123,
31,
1,
1,
工作提示,
2016-03-02 10:35:06,
2016-03-02 10:35:06,
2016-03-05 10:34:58,
-1,
2000420,
2000413,
,
0
 */
-(BOOL)LaunchMsg:(NSArray*)arrValue; //发起消息

/*--------- 异常反馈
参数说明：
value存放顺序需与key一一对应 fileArray存放文件信息 结构为dic {[path =@"",uuid=@""]}
自处理说明：当发现异常自己处理时部分参数才需填充数值，否则部分参数值置为空字符串
如下
key:
@[@"c_err_kind",@"c_task_id",@"c_err_name",@"c_err_type",@"c_err_level",@"c_manage_section",@"c_actnode_id",@"c_occur_time",@"c_report_time",@"c_end_time",@"c_isbyself",@"c_deal_type",@"c_from_user_id",@"c_to_user_id",@"c_cc_user_ids",@"c_report_des",@"c_tracefun_ids",@"c_file_ids",@"c_handle_des",@"c_handle_tracefun_ids",@"c_handle_file_ids",@"c_chk_person",@"c_eva_person",@"c_object_list",@"c_area"];
value:
NSArray* arrValue = @[@"2",@"",@"测试",@"0",@"",@"1",@"",@"2016-03-03 09:49:05",@"2016-03-03 09:55:05",@"2016-03-04 09:49:05",@"1",@"1",@"2000420",@"2000413",@"2000416",@"test",@"1,1",@"ED822491-E72D-49F9-8254-DBEA664905C4,129FDF0C-2BC5-4F20-BFF3-A3BD58EE7253",@"test2",@"1,1",@"F14ED50D-338E-441B-B379-69EC3B046B31,3E33BE9F-9B35-4CF0-8E35-6C5A5423FAA5",@"2000413",@"2000416",@"",@"区域编码"];

NSArray* fileArr = @[@ {@"path":[[paths objectAtIndex:0] stringByAppendingPathComponent:@"xiaohuangren.png"],@"uuid":@"ED822491-E72D-49F9-8254-DBEA664905C4"},@{@"path": [[paths objectAtIndex:0] stringByAppendingPathComponent:@"xiaohuangren2.png"],@"uuid":@"129FDF0C-2BC5-4F20-BFF3-A3BD58EE7253"},@ {@"path":[[paths objectAtIndex:0] stringByAppendingPathComponent:@"xiaohuangren.png"],@"uuid":@"F14ED50D-338E-441B-B379-69EC3B046B31"},@ {@"path":[[paths objectAtIndex:0] stringByAppendingPathComponent:@"xiaohuangren.png"],@"uuid":@"3E33BE9F-9B35-4CF0-8E35-6C5A5423FAA5"}];
 */

-(BOOL)LauchExptTask:(NSArray*)valueArr FileList:(NSArray*)fileArr; //异常反馈

/*
"c_err_id" ; 异常id
"c_feedback_id" ;
"verify_status" ; 验证状态 1不通过 2通过
"verify_result" ; 验证内容
"verify_userid" ; 验证用户id
 */
-(BOOL)ErrorVerify:(NSArray*)valueArr; //异常验证

@end

























