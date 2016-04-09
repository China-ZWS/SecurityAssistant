//
//  NetUp.m
//  SecurityAssistant
//
//  Created by Jeast on 16-3-1.
//  Copyright (c) 2016年 talkweb. All rights reserved.
//

#import "NetUp.h"

#import "CYToolFuncs.h"

#import "ASIFormDataRequest.h"

@implementation NetUp

+(id) shareTaskDataMgr
{
    static NetUp *sharedNetUp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetUp = [[self alloc] init];
    });
    return sharedNetUp;
}


//基础函数 用于任务、异常上传
-(BOOL)UpTaskTxtThread:(NSString*)urlString
{
    __block BOOL bReturn = FALSE;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    
    
    //暂时采用同步方式传送
    [request startSynchronous];

    NSError* txtError = [request error];
    if(!txtError)
    {
        NSLog(@"txtUp：%@",request.responseString);
        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
        if ([[[resultDic objectForKey:@"result"]valueForKey:@"code"]intValue]!= 1 ) {
            [CYToolFuncs AlertShow:@"失败" Context:@"上传失败，请重试"];
            bReturn = FALSE;
        }
        else
            bReturn = TRUE;
    }
    else
    {
        if(txtError.code ==1)
            [CYToolFuncs AlertShow:@"失败" Context:@"网络连接错误，请检查网络！"];
        else if(txtError.code ==2)
            [CYToolFuncs AlertShow:@"失败" Context:@"请求超时！"];
        else
            [CYToolFuncs AlertShow:@"失败" Context:txtError.debugDescription];
        bReturn = FALSE;
    }
    return bReturn;
}

//基础函数 任务表单上传
-(BOOL)UpFormTaskTxtThread:(NSString*)urlString
{
    __block BOOL bReturn = FALSE;
    NSString* totalStr =[[NSString alloc]initWithString:urlString];
    urlString = [[urlString substringToIndex:[urlString rangeOfString:@"?"].location] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString* tempContext = [totalStr substringFromIndex:[totalStr rangeOfString:@"taskinfo="].location+9];
    tempContext = [tempContext substringToIndex:[tempContext rangeOfString:@"&"].location];
    
    NSString* statusStr = [totalStr substringFromIndex:[totalStr rangeOfString:@"statusinfo="].location+11];
    statusStr = [statusStr substringToIndex:[statusStr rangeOfString:@"&"].location];
    
    NSString* interruptStr = [totalStr substringFromIndex:[totalStr rangeOfString:@"interrupt="].location+10];
    
    ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:tempContext forKey:@"taskinfo"];
    [request setPostValue:statusStr forKey:@"statusinfo"];
    [request setPostValue:interruptStr forKey:@"interrupt"];
    
    //暂时采用同步方式传送
    [request startSynchronous];
    
    NSError* txtError = [request error];
    if(!txtError)
    {
        NSLog(@"txtUp：%@",request.responseString);
        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
        if ([[[resultDic objectForKey:@"result"]valueForKey:@"code"]intValue]!= 1 ) {
            [CYToolFuncs AlertShow:@"失败" Context:@"上传失败，请重试"];
            bReturn = FALSE;
        }
        else
            bReturn = TRUE;
    }
    else
    {
        //        [CYToolFuncs stopActivityView];
        if(txtError.code ==1)
            [CYToolFuncs AlertShow:@"失败" Context:@"网络连接错误，请检查网络！"];
        else if(txtError.code ==2)
            [CYToolFuncs AlertShow:@"失败" Context:@"请求超时！"];
        else
            [CYToolFuncs AlertShow:@"失败" Context:txtError.debugDescription];
        bReturn = FALSE;
    }
    return bReturn;
}

//表单上传通用接口
-(BOOL)FormUpThread:(NSString*)urlString value:(NSArray*)arrValue key:(NSArray*)arrKey
{
    __block BOOL bReturn = FALSE;
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    
    for (int i=0; i<[arrKey count]; i++) {
        [request setPostValue:[arrValue objectAtIndex:i] forKey:[arrKey objectAtIndex:i]];
    }
    
    //暂时采用同步方式传送
    [request startSynchronous];
    
    NSError* txtError = [request error];
    if(!txtError)
    {
        NSLog(@"txtUp：%@",request.responseString);
        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
        if ([[[resultDic objectForKey:@"result"]valueForKey:@"code"]intValue]!= 1 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CYToolFuncs AlertShow:@"失败" Context:@"上传失败，请重试"];});
            bReturn = FALSE;
        }
        else
            bReturn = TRUE;
    }
    else
    {
        //        [CYToolFuncs stopActivityView];
        if(txtError.code ==1)
            dispatch_async(dispatch_get_main_queue(), ^{
                [CYToolFuncs AlertShow:@"失败" Context:@"网络连接错误，请检查网络！"];});
        else if(txtError.code ==2)
            dispatch_async(dispatch_get_main_queue(), ^{
                [CYToolFuncs AlertShow:@"失败" Context:@"请求超时！"];});
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                [CYToolFuncs AlertShow:@"失败" Context:txtError.debugDescription];});
        bReturn = FALSE;
    }
    return bReturn;
}

//发起任务接口
-(BOOL)LaunchTask:(NSArray*)valueArr FileList:(NSArray*)fileArr
{
    NSArray* keyArr = @[@"c_task_type",@"c_task_name",@"c_manage_section",@"c_start_time",@"c_end_time",@"c_exec_userid",@"c_sender_userid",@"c_remark",@"c_cc_userid_list",@"c_fileids"];
    NSString* taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionTaskInitiate!createNewTaskII.action"];
    if ([self FormUpThread:taskAct value:valueArr key:keyArr]) {
        return [self UpFileThread:fileArr];
    }
    else
        return FALSE;
}

//发起消息接口
-(BOOL)LaunchMsg:(NSArray*)arrValue
{
    NSString* taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionMessageDispatch!sendMessage.action"];
    NSArray* keyArr = @[@"c_msg_title",@"c_msg_content",@"c_msg_type",@"c_msg_level",@"c_notify_type",@"c_from",@"c_create_time",@"c_plan_time",@"c_expiry_time",@"c_send_type",@"c_sender",@"c_receiver",@"c_remark",@"c_pid"];
    return [self FormUpThread:taskAct value:arrValue key:keyArr];
}

//文件上传接口
-(BOOL)UpFileThread:(NSArray*)upFilePathArray
{
    //所有文件都放在同一个相对路径
    NSString* urlString = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/filemanageraction!UpdateFileInfoArray.action"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL bReturn = FALSE;
    
    if([upFilePathArray count] == 0 || upFilePathArray == nil)
        return TRUE;
    if(upFilePathArray!=nil)  //上传异常反馈文件
    {
        for (int i = 0; i<[upFilePathArray count]; i++) {
            ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request addFile:[upFilePathArray[i] objectForKey:@"path"]forKey:@"files"];
            
            if([[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"jpeg"] || [[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"jpg"] || [[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"png"])
                [request addPostValue:@"1"forKey:@"c_filetypes"];//1图片 2音频  3视频 4其他
            else if([[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"mov"] ||[[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"mp4"])
                [request addPostValue:@"3"forKey:@"c_filetypes"];
            else if([[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"caf"] ||[[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"wav"] ||[[[[upFilePathArray[i] objectForKey:@"path"] pathExtension] lowercaseString] isEqualToString:@"mp3"])
                [request addPostValue:@"2"forKey:@"c_filetypes"];
            else
                [request addPostValue:@"4"forKey:@"c_filetypes"];
            [request addPostValue:[[upFilePathArray[i] objectForKey:@"path"] pathExtension]forKey:@"c_extens"];
            NSLog(@"%@",[[upFilePathArray[i] objectForKey:@"path"] pathExtension]);
            [request addPostValue:@"2"forKey:@"c_filekind"];
            [request addPostValue:[upFilePathArray[i] objectForKey:@"uuid"]forKey:@"c_fileids"];
            
            [request startSynchronous];
            NSError* fileError = [request error];
            if(!fileError)
            {
                NSLog(@"fileUp：%@",request.responseString);
                NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
                if ([[[resultDic objectForKey:@"result"]valueForKey:@"code"]intValue]== 1 ) {
                    bReturn = TRUE;
                }
            }
            else
            {
                bReturn = FALSE;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CYToolFuncs AlertShow:@"文件上传异常" Context:@"上传文件失败，请重试！"];});
                return bReturn;
            }
            
        }
    }
    return bReturn;
}

//上传任务  bFinish:0代表任务未上传 当调用该接口上传成功后需在以bFinish=1再调用此该接口
-(BOOL)UpNormalTask:(NSDictionary*)taskDic StepArray:(NSArray*)stepArray finish:(BOOL)bFinish
{
    NSString *taskAct;
    NSMutableArray* stepFileArray = [[NSMutableArray alloc]init]; //存放文件ID跟文件地址列表

        NSMutableArray* tempStepArray = [[NSMutableArray alloc]init]; //存放步骤
        for (int k =0; k<[stepArray count]; k++) {
            NSString* tempResult = [[NSString alloc]init];  //判断步骤中是否存放操作结果
            NSString* strUUID = @"";
            if([stepArray[k] objectForKey:@"c_result"] == nil)
                tempResult = @"";
            else
            {
                //判断是否有结果，如果有判断是否是拍照、录音、视频，如果是，存放进列表
                tempResult = [stepArray[k] objectForKey:@"c_result"];
                if([[stepArray[k] objectForKey:@"c_tracefunid"]intValue]<=3&&[[stepArray[k] objectForKey:@"c_tracefunid"]intValue]>=1)
                {
                    strUUID = [CYToolFuncs generateUuidString];
                    NSDictionary* tempFileDic = @{@"path":tempResult,@"uuid":strUUID};
                    [stepFileArray addObject:tempFileDic];
                }
            }
            
            NSDictionary* step1Dic = @{@"c_isstd": [[stepArray[k] objectForKey:@"c_id"]isEqualToString:@""]?@"0":@"1",@"c_taskstep_id":[stepArray[k] objectForKey:@"c_id"],@"c_step_index":[stepArray[k] objectForKey:@"c_step_index"],@"c_isfile":([[stepArray[k] objectForKey:@"c_tracefunid"]intValue]<=3&&[[stepArray[k] objectForKey:@"c_tracefunid"]intValue]>=1)?([stepArray[k] objectForKey:@"c_result"]!=nil ? @"1":@"0"):@"0",@"c_resultvalue":([[stepArray[k] objectForKey:@"c_tracefunid"]intValue]<=3&&[[stepArray[k] objectForKey:@"c_tracefunid"]intValue]>=1)?@"":tempResult, @"c_tracefunid":[stepArray[k] objectForKey:@"c_tracefunid"],@"c_step_prompt":[stepArray[k] objectForKey:@"c_step_prompt"]==nil?@"":[stepArray[k] objectForKey:@"c_step_prompt"],@"c_area":[stepArray[k] objectForKey:@"c_area"],@"c_obj_id":[stepArray[k] objectForKey:@"c_obj_id"],@"c_file_id":strUUID};
            [tempStepArray addObject:step1Dic];
        }

        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* endTm = [formatter stringFromDate:[NSDate date]];
        
        NSDictionary* tempTaskDic = @{@"c_task_id":[taskDic objectForKey:@"c_task_id"],@"c_status":@"33",@"c_iscancel":@"0",@"c_handle_des":[taskDic objectForKey:@"c_handle_des"],@"c_iserror":@"0",@"c_err_status":@"",@"c_fact_starttime":[taskDic objectForKey:@"c_fact_starttime"],@"c_fact_endtime":endTm};
    
        //将任务信息跟步骤信息保存进字典
        NSDictionary* taskInfoDic = @{@"task":tempTaskDic,@"step":tempStepArray};
        //字典转化成nsdata再转化成字符串
        NSData *taskJson = [NSJSONSerialization dataWithJSONObject:taskInfoDic options:NSJSONWritingPrettyPrinted error: nil];
        NSString* taskJsonStr = [[NSString alloc]initWithData:taskJson encoding:NSUTF8StringEncoding];
        
        NSString *taskStr;
        if(!bFinish)
            taskStr = [NSString stringWithFormat:@"/CyxwglWebInService/upTaskinfoaction!UpTaskInfo.action?taskinfo=%@&statusinfo=0&interrupt=%@",taskJsonStr,@"0"];
        else
        {
            taskInfoDic = @{@"task":taskDic,@"step":@""};
            taskJson = [NSJSONSerialization dataWithJSONObject:taskInfoDic options:NSJSONWritingPrettyPrinted error: nil];
            taskJsonStr = [[NSString alloc]initWithData:taskJson encoding:NSUTF8StringEncoding];
            taskStr = [NSString stringWithFormat:@"/CyxwglWebInService/upTaskinfoaction!UpTaskInfo.action?taskinfo=%@&statusinfo=1&interrupt=%@",taskJsonStr,@"0"];
        }
        taskAct = [[VariableStore getServerUrl] stringByAppendingString:taskStr];

    if(!bFinish)
    {
        if([self UpFormTaskTxtThread:taskAct]) //UpFormTaskTxtThread
        {

            if([self UpFileThread:stepFileArray])
                return TRUE;
            else
                return FALSE;
        }
        return FALSE;
    }
    else
        return  [self UpFormTaskTxtThread:taskAct];
}

//--------- 异常任务提交
//tasktype 1 本人处理 2 安排整改 3 继续反馈 4 接收确认
-(BOOL)UpExptTask:(NSArray*)valueArr FileList:(NSArray*)fileArr TaskType:(int)taskType
{
    
    NSString *taskAct;
    NSArray* keyArr;
    switch (taskType) {
        case 1:
            taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionErrorUpload!handleError.action"];
            keyArr = @[@"c_err_id",@"c_feedback_id",@"c_deal_type",@"c_user_id",@"c_tracefun_ids",@"c_file_ids",@"c_handle_des",@"c_chk_person",@"c_eva_person"];
            break;
        case 2:
            taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionErrorUpload!forwardError.action"];
            keyArr = @[@"c_err_id",@"c_feedback_id",@"c_deal_type",@"c_end_time",@"c_from_user_id",@"c_to_user_id",@"c_cc_user_ids",@"c_tracefun_ids",@"c_file_ids",@"c_report_des",@"c_chk_person",@"c_eva_person"];
            break;
        case 3:
            keyArr = @[@"c_err_id",@"c_feedback_id",@"c_deal_type",@"c_end_time",@"c_from_user_id",@"c_to_user_id",@"c_cc_user_ids",@"c_tracefun_ids",@"c_file_ids",@"c_report_des"];
            taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionErrorUpload!forwardError.action"];
            break;
        case 4:
            keyArr = @[@"c_feedback_id"];
            taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionErrorUpload!receiptError.action"];
            break;
    }

    if ([self FormUpThread:taskAct value:valueArr key:keyArr])
    {
        if([self UpFileThread:fileArr])
            return TRUE;
        else
            return FALSE;
    }
    return FALSE;
}

//--------- 异常反馈
-(BOOL)LauchExptTask:(NSArray*)valueArr FileList:(NSArray*)fileArr
{
    
    NSString *taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionErrorUpload!reportError.action"];
    
    NSArray* keyArr = @[@"c_err_kind",@"c_task_id",@"c_err_name",@"c_err_type",@"c_err_level",@"c_manage_section",@"c_actnode_id",@"c_occur_time",@"c_report_time",@"c_end_time",@"c_isbyself",@"c_deal_type",@"c_from_user_id",@"c_to_user_id",@"c_cc_user_ids",@"c_report_des",@"c_tracefun_ids",@"c_file_ids",@"c_handle_des",@"c_handle_tracefun_ids",@"c_handle_file_ids",@"c_chk_person",@"c_eva_person",@"c_object_list",@"c_area"];
    
    
    if ([self FormUpThread:taskAct value:valueArr key:keyArr])
    {
        if([self UpFileThread:fileArr])
            return TRUE;
        else
            return FALSE;
    }
    return FALSE;
}

//异常验证接口
-(BOOL)ErrorVerify:(NSArray*)valueArr
{
    NSString* taskAct = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/actionErrorUpload!handleErrorVerify.action"];
    NSArray* keyArr = @[@"c_err_id",@"c_feedback_id",@"verify_status",@"verify_result",@"verify_userid"];
    return [self FormUpThread:taskAct value:valueArr key:keyArr];
}


@end























