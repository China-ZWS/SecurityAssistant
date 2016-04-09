//
//  UsersViewController.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/9.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJTableViewController.h"

@interface UsersViewController : PJTableViewController

- (id)initWithParameters:(id)parameters caches:(NSMutableArray *)caches selected:(void(^)(id datas))selected;


@end
