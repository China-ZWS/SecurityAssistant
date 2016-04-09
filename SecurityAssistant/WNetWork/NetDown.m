//
//  NetDown.m
//  SecurityAssistant
//
//  Created by Jeast on 16-2-29.
//  Copyright (c) 2016年 talkweb. All rights reserved.
//

#import "NetDown.h"
#import "CYToolFuncs.h"

int downTaskCount;
static int itaskDowning = 0;
NSString* lastTaskID = @"0";
NSString* lastMsgID = @"0";

@implementation NetDown: NSObject
@synthesize userInfo,dayTaskDic,assignTaskDic,fbTaskDic,msgDic,fbTrackArray,basicDataDic,areaArray;

+(id) shareTaskDataMgr
{
    static  NetDown *sharedNetDown = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetDown = [[self alloc] init];
    });
    return sharedNetDown;
}

-(id)init
{
    if (self == [super init]) {
        userInfo = [[NSDictionary alloc]init];
        dayTaskDic = [[NSMutableDictionary alloc]init];
        assignTaskDic = [[NSMutableDictionary alloc]init];
        fbTaskDic = [[NSMutableDictionary alloc]init];
        msgDic = [[NSMutableDictionary alloc]init];
        fbTrackArray = [[NSArray alloc]init];
        //初始化组织架构基础数据
        basicDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OrgFile.plist"]];
        if (basicDataDic == nil)
            basicDataDic = [[NSMutableDictionary alloc]init];
        //剔除已被删除数据
        [self delInvalidBsiData:&basicDataDic];
        
        //初始化区域基础数据
        areaArray = [[[[NSMutableDictionary alloc]initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AreaFile.plist"]] objectForKey:@"area"] mutableCopy];
        if (areaArray == nil)
            areaArray = [[NSMutableArray alloc]init];
        
        //初始化通知数据
        NSString* fileName = [[NSString alloc]initWithFormat:@"Msg-%@.plist",[userInfo objectForKey:@"usercode"]];
        msgDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]];
        if (msgDic == nil)
            msgDic = [[NSMutableDictionary alloc]init];
        else
        {
            lastMsgID = [msgDic objectForKey:@"lastMsgID"];
            [msgDic removeObjectForKey:@"lastMsgID"];
        }
    }
    return self;
}



//通用数据获取接口
-(BOOL) getActionData:(NSString *)requestStr callback:(SEL) sel
{
    if (![CYToolFuncs isConnectionAvailable]) //判断是否连上网络
        return false;
    
    NSError *tempError;
    //加载一个NSURL对象
    NSURLRequest *request;
    if([requestStr rangeOfString:@"login.action"].length>0)
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    else
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestStr]];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&tempError];
    error = tempError;
    
    if(error!=nil)
    {
        return NO;
    }
    
    if ( response != nil ){
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *dictResult = [dict valueForKey:@"result"];
        if ( dictResult != nil && ([[dictResult valueForKey:@"code"] intValue]== 1) ) {//简单判定成功
            
            [self performSelector:sel withObject:dict];
            return YES;
        }
    }
    return NO;
}

//通用数据获取接口
-(NSDictionary*) getActionData:(NSString *)requestStr;
{
    if(![CYToolFuncs isConnectionAvailable])
        return nil;
    requestStr = [requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //解决直接用URLWithString来拼接NSURL有时候得到的NSURL是为nil的
    NSError *tempError;
    //加载一个NSURL对象
    NSURLRequest *request;
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&tempError];
    error = tempError;
    
    if(error!=nil)
        return nil;
    
    if ( response != nil ){
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *dictResult = [dict valueForKey:@"result"];
        if ( dictResult != nil && ([[dictResult valueForKey:@"code"] intValue]== 1) ) {//简单判定成功
            return dict;
        }
    }
    return nil;
}

-(void)alertShow
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"获取完整任务失败，请重试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
    [alertView show];
}

//登录验证
//http://ppd.talkweb.com.cn:8441/CyxwglWebInService/userAction!login.action?usercode=jiangyin&password=888888
-(BOOL)doLogin:(NSString*)userName password: (NSString *) userPassword
{
    NSString *logStr = [NSString stringWithFormat:@"/CyxwglWebInService/actionUser!login.action?usercode=%@&password=%@",userName,userPassword];
    NSString *logAct = [[VariableStore getServerUrl] stringByAppendingString:logStr];
    
    BOOL b =[self getActionData:logAct callback:@selector(processLogin:)];
    if ( b == YES ){//登录成功，内存存储用户名和密码，方便脱网后自动重连
        NSLog(@"login sucess");
    }
    return b;
}
-(void)processLogin:(NSDictionary *)da
{
    if (da!=nil)  //登录初始化
    {
        userInfo = [[NSDictionary alloc]initWithDictionary:[da objectForKey:@"userinfo"]];
        dayTaskDic = [[NSMutableDictionary alloc]init];
        assignTaskDic = [[NSMutableDictionary alloc]init];
        fbTaskDic = [[NSMutableDictionary alloc]init];
        //初始化通知数据
        NSString* fileName = [[NSString alloc]initWithFormat:@"Msg-%@.plist",[userInfo objectForKey:@"usercode"]];
        msgDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]];
        if (msgDic == nil)
        {
            lastMsgID = @"0";
            msgDic = [[NSMutableDictionary alloc]init];
        }
        else
        {
            lastMsgID = [msgDic objectForKey:@"lastMsgID"];
            [msgDic removeObjectForKey:@"lastMsgID"];
        }
        lastTaskID = @"0";
    }
//userInfo储存内容
//    displayname = "\U59dc\U82f1";
//    orgcode = 20101339;
//    orgid = 1000559;
//    orglevel = 3;
//    orgname = "\U8f85\U6599\U4ed3\U50a8\U73ed";
//    orgshortname = "\U8f85\U6599\U4ed3\U50a8\U73ed";
//    password = 21218cca77804d2ba1922c33e0151105;
//    posicode = 20140111;
//    posiname = "\U8f85\U6599\U4fdd\U7ba1\U5de5\Uff08\U94dd\U7b94\U548c\U6536\U7f29\U819c\Uff09";
//    positionid = 1002823;
//    usercode = 1206;
//    userid = 2000423;
}

//反馈跟踪信息
-(void)getFBTrackInfo:(NSUInteger)fbType
{
    //http://ppd.talkweb.com.cn:8441/CyxwglWebInService/abnormalaction!GetErrorTask.action?userid=1001005&pagesize=0&pageindex=0&c_tracetype=1
    
    NSString *logStr = [NSString stringWithFormat:@"/CyxwglWebInService/abnormalaction!GetErrorTask.action?userid=%@&pagesize=50&pageindex=1&c_tracetype=%lu",[userInfo objectForKey:@"userid"],(unsigned long)fbType];
    NSString *logAct = [[VariableStore getServerUrl] stringByAppendingString:logStr];
    
    [self getActionData:logAct callback:@selector(processFBTrack:)];
}

-(void)processFBTrack:(NSDictionary *)da
{
    if ([da objectForKey:@"errortrace"]!=nil && [[da objectForKey:@"errortrace"]  count]>0)
    {
        fbTrackArray = [[NSArray alloc]initWithArray:[da objectForKey:@"errortrace"]];
        return;
    }
    fbTrackArray = [[NSArray alloc]init];
        
}

//获取新任务
//http://ppd.talkweb.com.cn:8441/CyxwglWebInService/taskAction!GetUnderTask.action?c_exec_userid=1001004&c_task_id=0 //旧接口
//http://127.0.0.1:8080/CyxwglWebInService/actionTaskDispatch!getNextTodoTask.action?c_task_id=0&c_exec_userid=1002999 //新接口
-(BOOL)getTaskDown:(NSString *)taskid
{
    NSString *taskStr = [NSString stringWithFormat:@"/CyxwglWebInService/actionTaskDispatch!getNextTodoTask.action?c_exec_userid=%@&c_task_id=%@",[userInfo objectForKey:@"userid"],taskid];
    
    NSString *taskAct = [[VariableStore getServerUrl] stringByAppendingString:taskStr];
    
    return [self getActionData:taskAct callback:@selector(processTaskDown:)];
}
//获取任务成功后处理数据
-(void)processTaskDown:(NSDictionary *)da;
{
    NSDictionary *taskDict = [da valueForKey:@"task"];
    NSString *IdNew = [taskDict valueForKey:@"c_task_id"];
    if ( [IdNew intValue] > 0 && ([CYToolFuncs isExistTaskId:assignTaskDic ID:IdNew] == false) && ([CYToolFuncs isExistTaskId:dayTaskDic ID:IdNew] == false)){ //如果任务ID不为空 并且该任务在缓存中不存在
        if ([[[da objectForKey:@"task"] objectForKey:@"c_isstd"] intValue]==1)
            [dayTaskDic setObject:da forKey:IdNew];
        else if ([[[da objectForKey:@"task"] objectForKey:@"c_isstd"] intValue]==0)
            [assignTaskDic setObject:da forKey:IdNew];
        lastTaskID = IdNew;
        downTaskCount++;
        return;
    }
    if( [IdNew intValue] > 0 && (([CYToolFuncs isExistTaskId:dayTaskDic ID:IdNew] != false) || ([CYToolFuncs isExistTaskId:assignTaskDic ID:IdNew] != false)) )//如果任务ID不为空 并且该任务在缓存中存在
    {
        lastTaskID = IdNew;
    }
}
//重新下载任务函数，如果下载中校验出错则重新下载所有任务
-(void)againGetAllServerTask
{
    [self getAllServerTask];
}

-(void)syncTask
{
    if ([lastTaskID longLongValue]==0) //任务初始状态步进行同步
        return;
    
    NSString *taskStr = [NSString stringWithFormat:@"/CyxwglWebInService/actionTaskDispatch!todoTaskList.action?c_exec_userid=%@&c_task_id=%@",[userInfo objectForKey:@"userid"],lastTaskID];
    NSString *taskAct = [[VariableStore getServerUrl] stringByAppendingString:taskStr];
    [self getActionData:taskAct callback:@selector(syncTaskProcess:)];
}

-(void)syncTaskProcess:(NSDictionary *)da;
{
    NSArray* tempArray = [da valueForKey:@"taskList"];
    for (NSString* strTaskID in [dayTaskDic allKeys]) {
        if ([tempArray indexOfObject:strTaskID]== NSNotFound)
            [dayTaskDic removeObjectForKey:strTaskID];
    }
    for (NSString* strTaskID in [assignTaskDic allKeys]) {
        if ([tempArray indexOfObject:strTaskID]== NSNotFound)
            [assignTaskDic removeObjectForKey:strTaskID];
    }
}

//获取所有任务
-(void)getAllServerTask
{
    if (itaskDowning != 0)
        return;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self syncTask]; //任务同步
    });
    itaskDowning = 1; //加锁
    __block int iDownCount = 0; //标志位 用于判断是否有新任务下载以供刷新
    int taskCount1=([[dayTaskDic allKeys] count]+[[assignTaskDic allKeys] count]); //下载前任务数
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        downTaskCount = 0;
        while ([self getTaskDown:lastTaskID]) {
            iDownCount++;
            continue;
        }
//        NSLog(@"%@",taskDic);
        int taskCount2 = ([[dayTaskDic allKeys] count]+[[assignTaskDic allKeys] count]); //下载后任务数
        if (downTaskCount!=0 && downTaskCount>(taskCount2-taskCount1)) {
            //任务校对出错后标志位初始化
            lastTaskID = @"0";
            NSLog(@"downTask again");
        }
        itaskDowning = 0; //解锁
    });
    return;
}

-(void)delUpTask:(NSString*)taskID TaskType:(int)taskType //删除已上传的任务
{
    switch (taskType) {
        case 0:
            [dayTaskDic removeObjectForKey:taskID];
            break;
        case 1:
            [assignTaskDic removeObjectForKey:taskID];
            break;
        case 2:
            [fbTaskDic removeObjectForKey:taskID];
            break;
        default:
            break;
    }
}

//获取待办异常列表
-(void)getFbList
{
    NSString *taskStr = [NSString stringWithFormat:@"/CyxwglWebInService/actionErrorDispatch!getTodoErrorTasks.action?userid=%@",[userInfo objectForKey:@"userid"]];
    
//    ppd.talkweb.com.cn:8441/CyxwglWebInService/actionErrorDispatch!getTodoErrorTasks.action?userid=1001004
    
    NSString *taskAct = [[VariableStore getServerUrl] stringByAppendingString:taskStr];
    
    [self getActionData:taskAct callback:@selector(checkFbList:)];
}

-(void)checkFbList:(NSDictionary *)da
{
    NSArray* arr1 =[[NSMutableArray alloc]initWithArray:[da objectForKey:@"errors"]];
    NSArray* arr2 =[fbTaskDic allKeys];
    NSMutableArray* arr3 = [[NSMutableArray alloc]init];
    for (NSDictionary* tempDic in arr1) {
        [arr3 addObject:[tempDic objectForKey:@"c_err_id"]];
    }
    
    //删除已完成的异常任务
    for (int i = 0; i<[arr2 count]; i++)
        if ([arr3 indexOfObject:arr2[i]]==NSNotFound)
            [fbTaskDic removeObjectForKey:arr2[i]];
    
    for (int i =0; i<[arr1 count]; i++) {
        NSString* strFbId = [arr1[i] objectForKey:@"c_err_id"];
        NSString* strFbStatus = [arr1[i] objectForKey:@"c_status"];
        if ([arr2 indexOfObject:strFbId]==NSNotFound) {
            NSString* strErrorId = [arr1[i] objectForKey:@"c_err_id"];
            NSLog(@"c_err_id:%@",strErrorId);
            [self getFbTask:strErrorId];
        }
        else if([[[fbTaskDic objectForKey:strFbId] objectForKey:@"status"]intValue]<[strFbStatus intValue])
        {
            [fbTaskDic removeObjectForKey:strFbId];
            NSString* strErrorId = [arr1[i] objectForKey:@"c_err_id"];
            NSLog(@"c_err_id:%@",strErrorId);
            [self getFbTask:strErrorId];
        }
        else
            continue;
    }
}

-(BOOL)getFbTask:(NSString*)errId
{
    NSString *taskStr = [NSString stringWithFormat:@"/CyxwglWebInService/actionErrorDispatch!getErrorTask.action?errid=%@&userid=%@",errId,[userInfo objectForKey:@"userid"]];
    
    NSString *taskAct = [[VariableStore getServerUrl] stringByAppendingString:taskStr];
    
    return [self getActionData:taskAct callback:@selector(saveFbTask:)];
}

-(void)saveFbTask:(NSDictionary*)da
{
    if (da!=nil)
        [fbTaskDic setObject:da forKey:[[da objectForKey:@"errinfo"] objectForKey:@"c_err_id"]];
}

//获取消息数据
//http://ppd.talkweb.com.cn:8441/CyxwglWebInService/messageaction!GetMessage.action?userid=1001002&msgid=0
-(BOOL)getMessageDown:(NSString *)msgid
{
    NSString *msgStr = [NSString stringWithFormat:@"/CyxwglWebInService/messageaction!GetMessage.action?userid=%@&msgid=%@",[userInfo objectForKey:@"userid"],msgid];
    NSString *msgAct = [[VariableStore getServerUrl] stringByAppendingString:msgStr];
    
    return [self getActionData:msgAct callback:@selector(processMessageDown:)];
}
//下载所有消息
-(void)getAllServerMsg
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while ([self getMessageDown:lastMsgID]) {
            continue;
        }
    });
    return;
}

-(void)processMessageDown:(NSDictionary *)da
{
    NSDictionary *taskDict = [da valueForKey:@"message"];
    NSMutableDictionary *dic = [da mutableCopy];
//    [dic setObject:@"NO" forKey:@"bRead"];  //增加消息是否已读键值标志
    
    //目前接口返回一个整数，临时做类型转换处理
    NSString *IdNew = [NSString stringWithFormat:@"%@",[taskDict valueForKey:@"c_msg_id"]];
    
    if ( [IdNew intValue] > 0 && [CYToolFuncs isExistTaskId:msgDic ID:IdNew] == false ){
        lastMsgID = IdNew;
        [msgDic setObject:dic forKey:IdNew];
        [msgDic setObject:lastMsgID forKey:@"lastMsgID"];
        NSString* fileName = [[NSString alloc]initWithFormat:@"Msg-%@.plist",[userInfo objectForKey:@"usercode"]];
        [msgDic writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName] atomically:YES];
        [msgDic removeObjectForKey:@"lastMsgID"];
    }
}

-(void)msgStateChange:(NSString*)ID READ:(BOOL)bRead  //消息已读状态更改
{
    NSMutableDictionary* tempMsgDic = [[NSMutableDictionary alloc]initWithDictionary:[msgDic objectForKey:ID]];
    [tempMsgDic setObject:[NSNumber numberWithBool:bRead] forKey:@"bRead"];
    [msgDic setObject:tempMsgDic forKey:ID];
    NSString* fileName = [[NSString alloc]initWithFormat:@"Msg-%@.plist",[userInfo objectForKey:@"usercode"]];
    [msgDic writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName] atomically:YES];
}

-(void)updateBasicData
{
    //初始化组织架构基础数据 将所有数据都加载进来
    basicDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OrgFile.plist"]];
    if (basicDataDic == nil)
        basicDataDic = [[NSMutableDictionary alloc]init];
    
    NSArray* lastGetTmArr = [basicDataDic objectForKey:@"LastGetTm"];
    if (lastGetTmArr==nil || [lastGetTmArr count]!=3)
        lastGetTmArr = @[@"1970-01-01 01:01:01",@"1970-01-01 01:01:01",@"1970-01-01 01:01:01"];
    NSMutableArray* downloadOrgArray = [[NSMutableArray alloc]init];
    NSMutableArray* downloadUserArray = [[NSMutableArray alloc]init];
    NSMutableArray* downloadPosiArray = [[NSMutableArray alloc]init];
    NSMutableArray* downloadAreaArray = [[NSMutableArray alloc]init];
    NSString* tempOrgStr = [[VariableStore getServerUrl] stringByAppendingString:[NSString stringWithFormat:@"/CyxwglWebInService/actionDataSync!getModifiedOrganizations.action?last_update_time=%@",lastGetTmArr[0]]];
    downloadOrgArray = [[[self getActionData:tempOrgStr]objectForKey:@"organizations"]mutableCopy];
    
    tempOrgStr = [[VariableStore getServerUrl] stringByAppendingString:[NSString stringWithFormat:@"/CyxwglWebInService/actionDataSync!getModifiedUsers.action?last_update_time=%@",lastGetTmArr[1]]];
    downloadUserArray = [[[self getActionData:tempOrgStr]objectForKey:@"users"]mutableCopy];
    
    tempOrgStr = [[VariableStore getServerUrl] stringByAppendingString:[NSString stringWithFormat:@"/CyxwglWebInService/actionDataSync!getModifiedPositions.action?last_update_time=%@",lastGetTmArr[0]]];
    downloadPosiArray = [[[self getActionData:tempOrgStr]objectForKey:@"positions"] mutableCopy];
    
    tempOrgStr = [[VariableStore getServerUrl] stringByAppendingString:@"/CyxwglWebInService/systemaction!areaDate.action"];
    downloadAreaArray = [[[self getActionData:tempOrgStr]objectForKey:@"areaList"] mutableCopy];
    
    //更新组织架构
    if ([downloadOrgArray count]>0)
    {
        NSMutableArray* tempAddArray = [[NSMutableArray alloc]init]; //存放新增的数据
        NSMutableArray* tempArr = [[basicDataDic objectForKey:@"organizations"]mutableCopy]; //缓存中的组织结构数据
        if (tempArr == nil)
            tempArr = [[NSMutableArray alloc]init];
        for (int i = 0; i<[downloadOrgArray count]; i++) {
            BOOL bDelete = FALSE;  //删除标志 用于判断是删除还是新增
            for (int k =0; k<[tempArr count]; k++) {
                //当组织id相同 但删除标志步同的时候 需要进行删除更新 1000559
                if(([[tempArr[k] objectForKey:@"orgid"]longValue] == [[downloadOrgArray[i] objectForKey:@"orgid"]longValue]) && ([[tempArr[k] objectForKey:@"isdelete"]intValue] != [[downloadOrgArray[i] objectForKey:@"isdelete"]intValue]))
                {
                    [tempArr replaceObjectAtIndex:k withObject:downloadOrgArray[i]];
                    bDelete = TRUE;
                }
                //当组织id相同 但删除标志相同的时候 不添加（此种情况用于重复下发）
                if(([[tempArr[k] objectForKey:@"orgid"]longValue] == [[downloadOrgArray[i] objectForKey:@"orgid"]longValue]) && ([[tempArr[k] objectForKey:@"isdelete"]intValue] == [[downloadOrgArray[i] objectForKey:@"isdelete"]intValue]))
                {
                    bDelete = TRUE;
                }
            }
            if (!bDelete) {
                [tempAddArray addObject:downloadOrgArray[i]];
            }
        }
        if(tempAddArray != nil && [tempAddArray count] > 0)
        {
            [tempArr addObjectsFromArray:tempAddArray];
            [basicDataDic setObject:tempArr forKey:@"organizations"];
        }
    }
    
    //更新用户信息
    if ([downloadUserArray count] > 0) {
        NSMutableArray* tempAddArray = [[NSMutableArray alloc]init]; //存放新增的数据
        NSMutableArray* tempArr = [[basicDataDic objectForKey:@"users"]mutableCopy]; //缓存中的用户数据
        if (tempArr == nil)
            tempArr = [[NSMutableArray alloc]init];
        for (int i = 0; i<[downloadUserArray count]; i++) {
            BOOL bDelete = FALSE;  //删除标志 用于判断是删除还是新增
            for (int k =0; k<[tempArr count]; k++) {
                //当用户id相同 但删除标志不同的时候 需要进行删除更新
                if(([[tempArr[k] objectForKey:@"userid"]longValue] == [[downloadUserArray[i] objectForKey:@"userid"]longValue]) && ([[tempArr[k] objectForKey:@"isdelete"]intValue] != [[downloadUserArray[i] objectForKey:@"isdelete"]intValue]))
                {
                    [tempArr replaceObjectAtIndex:k withObject:downloadUserArray[i]];
                    bDelete = TRUE;
                }
                //当组织id相同 但删除标志相同的时候 不添加（此种情况用于重复下发）
                if(([[tempArr[k] objectForKey:@"orgid"]longValue] == [[downloadUserArray[i] objectForKey:@"orgid"]longValue]) && ([[tempArr[k] objectForKey:@"isdelete"]intValue] == [[downloadUserArray[i] objectForKey:@"isdelete"]intValue]))
                {
                    bDelete = TRUE;
                }
            }
            if (!bDelete) {
                [tempAddArray addObject:downloadUserArray[i]];
            }
        }
        if(tempAddArray != nil && [tempAddArray count] > 0)
        {
            [tempArr addObjectsFromArray:tempAddArray];
            [basicDataDic setObject:tempArr forKey:@"users"];
        }
    }
    
    //更新岗位信息
    if ([downloadPosiArray count] > 0) {
        NSMutableArray* tempAddArray = [[NSMutableArray alloc]init]; //存放新增的数据
        NSMutableArray* tempArr = [[basicDataDic objectForKey:@"positions"]mutableCopy]; //缓存中的岗位数据
        if (tempArr == nil)
            tempArr = [[NSMutableArray alloc]init];
        for (int i = 0; i<[downloadPosiArray count]; i++) {
            BOOL bDelete = FALSE;  //删除标志 用于判断是删除还是新增
            for (int k =0; k<[tempArr count]; k++) {
                //当岗位id相同 但删除标志不同的时候 需要进行删除更新
                if(([[tempArr[k] objectForKey:@"positionid"]longValue] == [[downloadPosiArray[i] objectForKey:@"positionid"]longValue]) && ([[tempArr[k] objectForKey:@"isdelete"]intValue] != [[downloadPosiArray[i] objectForKey:@"isdelete"]intValue]))
                {
                    [tempArr replaceObjectAtIndex:k withObject:downloadPosiArray[i]];
                    bDelete = TRUE;
                }
                //当组织id相同 但删除标志相同的时候 不添加（此种情况用于重复下发）
                if(([[tempArr[k] objectForKey:@"orgid"]longValue] == [[downloadPosiArray[i] objectForKey:@"orgid"]longValue]) && ([[tempArr[k] objectForKey:@"isdelete"]intValue] == [[downloadPosiArray[i] objectForKey:@"isdelete"]intValue]))
                {
                    bDelete = TRUE;
                }
            }
            if (!bDelete) {
                [tempAddArray addObject:downloadPosiArray[i]];
            }
        }
        if(tempAddArray != nil && [tempAddArray count] > 0)
        {
            [tempArr addObjectsFromArray:tempAddArray];
            [basicDataDic setObject:tempArr forKey:@"positions"];
        }
    }
    
    //更新区域信息
    if ([downloadAreaArray count]>0) {
        areaArray = downloadAreaArray;
        [@{@"area":areaArray} writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"areaFile.plist"] atomically:YES];
    }
    
    //遍历出记录最后更新时间
    
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];    //格式化HH得到24小时制 hh 12小时制
    NSDate *orgDate = [[NSDate alloc]init];
    NSDate *userDate = [[NSDate alloc]init];
    NSDate *posiDate = [[NSDate alloc]init];
    NSArray* tempLastTimeArr = [[NSArray alloc]init];
    //遍历出组织里lastdate最大值
    if ([downloadOrgArray count]>0) {
        tempLastTimeArr = [basicDataDic objectForKey:@"organizations"];
        for (int i = 0; i<[tempLastTimeArr count]; i++) {
            NSDate* tempDate = [fmt dateFromString:[tempLastTimeArr[i] objectForKey:@"lastupdate"]];
            if (i == 0) {
                orgDate = tempDate;
            }
            else
            {
                if ([orgDate timeIntervalSinceDate:tempDate]<0.0) {
                    orgDate = tempDate;
                }
            }
        }
    }

    //遍历出用户里lastdate最大值
    if ([downloadUserArray count]>0) {
        tempLastTimeArr = [basicDataDic objectForKey:@"users"];
        for (int i = 0; i<[tempLastTimeArr count]; i++) {
            NSDate* tempDate = [fmt dateFromString:[tempLastTimeArr[i] objectForKey:@"lastupdate"]];
            if (i == 0) {
                userDate = tempDate;
            }
            else
            {
                if ([userDate timeIntervalSinceDate:tempDate]<0.0) {
                    userDate = tempDate;
                }
            }
        }
    }

    //遍历出岗位里lastdate最大值
    if ([downloadPosiArray count]>0) {
        tempLastTimeArr = [basicDataDic objectForKey:@"positions"];
        for (int i = 0; i<[tempLastTimeArr count]; i++) {
            NSDate* tempDate = [fmt dateFromString:[tempLastTimeArr[i] objectForKey:@"lastupdate"]];
            if (i == 0) {
                posiDate = tempDate;
            }
            else
            {
                if ([posiDate timeIntervalSinceDate:tempDate]<0.0) {
                    posiDate = tempDate;
                }
            }
        }
    }

    NSLog(@"org:%@   user:%@   posi:%@",orgDate,userDate,posiDate);
    lastGetTmArr = @[[fmt stringFromDate:orgDate],[fmt stringFromDate:userDate],[fmt stringFromDate:posiDate]];
    [basicDataDic setObject:lastGetTmArr forKey:@"LastGetTm"];
    
    //将数据保存进本地缓存
    [basicDataDic writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OrgFile.plist"] atomically:YES];
    [self delInvalidBsiData:&basicDataDic];
}

-(void)delInvalidBsiData:(NSMutableDictionary* __strong *)basicDic
{
    if (*basicDic == nil || [[*basicDic allKeys] count]==0)
        return;
    NSMutableArray* tempValidArr = [[NSMutableArray alloc]init];
    //遍历出组织里lastdate最大值
    tempValidArr = [[*basicDic objectForKey:@"organizations"] mutableCopy];
    for (int i = 0; i<[tempValidArr count]; i++) {
        if ([[tempValidArr[i] objectForKey:@"isdelete"] intValue]==1) {
            [tempValidArr removeObjectAtIndex:i];
        }
    }
    if (tempValidArr!=nil)
        [*basicDic setObject:tempValidArr forKey:@"organizations"];
    
    //遍历出用户里lastdate最大值
    tempValidArr = [[*basicDic objectForKey:@"users"] mutableCopy];
    for (int i = 0; i<[tempValidArr count]; i++) {
        if ([[tempValidArr[i] objectForKey:@"isdelete"] intValue]==1) {
            [tempValidArr removeObjectAtIndex:i];
        }
    }
    if (tempValidArr!=nil)
        [*basicDic setObject:tempValidArr forKey:@"users"];
    
    //遍历出岗位里lastdate最大值
    tempValidArr = [[*basicDic objectForKey:@"positions"] mutableCopy];
    for (int i = 0; i<[tempValidArr count]; i++) {
        if ([[tempValidArr[i] objectForKey:@"isdelete"] intValue]==1) {
            [tempValidArr removeObjectAtIndex:i];
        }
    }
    if (tempValidArr!=nil)
        [*basicDic setObject:tempValidArr forKey:@"positions"];
}

@end



































