//
//  BasicViewModel.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "BasicViewModel.h"

@implementation BasicViewModel
+ (NSArray *)filtrateWithUsersOrgid:(NSInteger)orgid;
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orgid == %d",orgid];
    NSArray *users = [[NetDown shareTaskDataMgr] basicDataDic][@"users"];
    NSArray *datas = [users filteredArrayUsingPredicate:predicate];
    return datas;
}

+ (NSArray *)recombineForOrganizations;
{
    NSArray *organizations = [[NetDown shareTaskDataMgr] basicDataDic][@"organizations"];
    return  [self getDatas:organizations parentorgid:-1 index:0 carriers:[NSMutableArray array]];
}

+ (NSArray *)getDatas:(NSArray *)organizations parentorgid:(NSInteger)parentorgid index:(NSInteger)index carriers:(NSMutableArray *)carriers
{
    if (index == organizations.count)
    {
        return carriers;
    }
    
    NSDictionary *dic = organizations[index];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    
    if ([dic[@"parentorgid"] integerValue] == parentorgid)
    {
        newDic[@"childDatas"] = [self getDatas:organizations parentorgid:[dic[@"orgid"] integerValue] index:0 carriers:[NSMutableArray array]];
        [carriers addObject:newDic];
    }
    return [self getDatas:organizations parentorgid:parentorgid index:index + 1 carriers:carriers];
}

@end
