//
//  SafetyScrollView.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/8.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJScrollView.h"



@interface SafetyScrollView : PJScrollView
@property (nonatomic, copy) void (^name)(NSString *);
@property (nonatomic, copy) void (^recipient)(NSString *);
@property (nonatomic, copy) void (^cc)(NSString *cc);
@property (nonatomic, copy) void (^hazardSourcesme)(id);
@property (nonatomic, copy) void (^occurDate)(NSString *);
@property (nonatomic, copy) void (^processingDate)(NSString *);

@property (nonatomic, copy) void (^code)(id);
@property (nonatomic, copy) void (^resultCode)(NSString *);
@property (nonatomic, copy) void (^contents)(NSString *);
@property (nonatomic, copy) void (^files)(id datas);
@property (nonatomic, copy) void (^pushInRecipient)(id);
@property (nonatomic, copy) void (^pushInCC)(id);

@property (nonatomic) id datas;

+ (id)showInView:(UIView *)showInView;

@end
