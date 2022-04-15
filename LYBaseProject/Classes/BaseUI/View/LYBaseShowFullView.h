//
//  LYBaseShowView.h
//  Example
//
//  Created by muios on 2022/4/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 全屏  弹出的 view
@interface LYBaseShowFullView : UIView

/// 子类重写此方法 即可 自定义此类
- (void)buildView;

/// 点击整个 背景关闭事件后, 需要子类处理的
- (void)onClickShowViewDissmiss;

/// 添加view
/// @param toView 添加到哪个view上. keywindow 或者 self.view 都可以
+ (instancetype)showInView:(UIView *)toView;

+ (void)hiddenView:(UIView *)toView;

@end

NS_ASSUME_NONNULL_END
