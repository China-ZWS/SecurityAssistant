//
//  BasicViewModel.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicViewModel : NSObject

+ (NSArray *)filtrateWithUsersOrgid:(NSInteger)orgid;
+ (NSArray *)recombineForOrganizations;
@end
