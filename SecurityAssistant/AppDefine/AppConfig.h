
#define StrFromInt(interValue) [NSString stringWithFormat:@"%d",interValue]


typedef NS_ENUM(NSInteger, c_err_kind)
{
    kFeedback_Type_Task = 1,  //基于任务的异常反馈，执行任务时发起
    kFeedback_Type_Act = 1 << 1,///  没有数据
    kFeedback_Type_Task_Trueorfalse = 1 << 2
};