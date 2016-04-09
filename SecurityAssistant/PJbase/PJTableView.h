//
//  PJTableView.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/4/7.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "BaseTableView.h"

@interface PJTableView : BaseTableView
@property (nonatomic, copy) void(^deleteDatas)(id datas);
@end
