//
//  UIImageView+LY_Category.h
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageViewActionCallBack)(UIImageView *imageView,UITapGestureRecognizer *tap);

@interface UIImageView (LY_Category)

/// 添加手势点击事件
/// @param target self
/// @param action 事件
- (void)addGestureRecognizerTarget:(nullable id)target action:(nullable SEL)action;

/// 添加手势事件
/// @param action 事件回调
- (void)addGestureRecognizerBlockAction:(ImageViewActionCallBack)action;

@end

NS_ASSUME_NONNULL_END
