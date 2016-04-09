//
//  FileAddView.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/4.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileAddView : UICollectionView

+ (id)showInViewWithframe:(CGRect)frame success:(void(^)(id datas))success refreshHeight:(void(^)())refreshHeight;
@end
