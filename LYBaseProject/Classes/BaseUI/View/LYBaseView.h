//
//  LYBaseView.h
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYBaseView : UIView
/// 当使用 `init` 方法初始化的时候,可以直接重新此方法布局UI. 节省时间
- (void)buildInit;
/// 当使用 `initFrame` 方法初始化的时候,可以直接重新此方法布局UI 节省时间
- (void)buildInitFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
