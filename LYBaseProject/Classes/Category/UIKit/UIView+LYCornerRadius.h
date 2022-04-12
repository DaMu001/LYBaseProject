//
//  UIView+LYCornerRadius.h
//  Example
//
//  Created by muios on 2022/4/11.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 *  设置 viewRectCornerType 样式，
 *  注意：LYKit_ViewRectCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，
 */
typedef NS_ENUM(NSInteger, LYKit_ViewRectCornerType) {
    
    /*!
     *  设置全部四个角 圆角半径
     */
    LYKit_ViewRectCornerTypeAllCorners = 0,
    /*!
     *  设置下左角 圆角半径
     */
    LYKit_ViewRectCornerTypeBottomLeft,
    /*!
     *  设置下右角 圆角半径
     */
    LYKit_ViewRectCornerTypeBottomRight,
    /*!
     *  设置上左角 圆角半径
     */
    LYKit_ViewRectCornerTypeTopLeft,
    /*!
     *  设置下右角 圆角半径
     */
    LYKit_ViewRectCornerTypeTopRight,
    /*!
     *  设置下左、下右角 圆角半径
     */
    LYKit_ViewRectCornerTypeBottomLeftAndBottomRight,
    /*!
     *  设置上左、上右角 圆角半径
     */
    LYKit_ViewRectCornerTypeTopLeftAndTopRight,
    /*!
     *  设置上左、下右角 圆角半径
     */
    LYKit_ViewRectCornerTypeTopLeftAndBottomRight,
    /*!
     *  设置下左、上左角 圆角半径
     */
    LYKit_ViewRectCornerTypeBottomLeftAndTopLeft,
    /*!
     *  设置下右、上右角 圆角半径
     */
    LYKit_ViewRectCornerTypeBottomRightAndTopRight,
    /*!
     *  设置上左、上右、下右角 圆角半径
     */
    LYKit_ViewRectCornerTypeBottomRightAndTopRightAndTopLeft,
    /*!
     *  设置下右、上右、下左角 圆角半径
     */
    LYKit_ViewRectCornerTypeBottomRightAndTopRightAndBottomLeft,
};

@interface UIView (LYCornerRadius)

/**
 设置 view ：圆角，如果要全部设置四个角的圆角，可以直接用这个方法，必须要在设置 frame 之后，注意：如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效
 */
@property (nonatomic, assign) CGFloat ly_viewCornerRadius;

/**
 设置 viewRectCornerType 样式，注意：LYKit_ViewRectCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效,
 必须要保证 view 已经获取frame. 如果使用 `Masonry` 布局, 则需要在 布局完成后, 调用  `[view layoutIfNeeded]; ` 来强制更新布局后, 再设置 `LYKit_ViewRectCornerType`.
 使用示例: view.ly_viewCornerRadius = 5; view.ly_viewRectCornerType = LYKit_ViewRectCornerTypeAllCorners;
 */
@property (nonatomic, assign) LYKit_ViewRectCornerType ly_viewRectCornerType;

/**
  设置 view ：边框边线宽度
 */
@property(nonatomic, assign) CGFloat ly_viewBorderWidth;

/**
 设置 view ：边框边线颜色
 */
@property(nonatomic, strong) UIColor *ly_viewBorderColor;


/**
 快速切圆角
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 */
- (void)ly_view_setViewRectCornerType:(LYKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius;

/**
 快速切圆角，带边框、边框颜色

 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)ly_view_setViewRectCornerType:(LYKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;


@end

NS_ASSUME_NONNULL_END
