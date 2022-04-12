//
//  UIColor+LY_Hex.h
//  Example
//
//  Created by muios on 2022/4/11.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define LYColorHex(hexString) [UIColor ly_colorFromHexString:hexString]
#define LYColorHexWithAlpha(hexString,value) [UIColor ly_colorFromHexString:hexString alpha:value]
// 随机色
#define LYRandomColor [UIColor ly_randomColor]

/**
 渐变方式
 
 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, GradientChangeDirection) {
    GradientChangeDirectionLevel,
    GradientChangeDirectionVertical,
    GradientChangeDirectionUpwardDiagonalLine,
    GradientChangeDirectionDownDiagonalLine,
};

@interface UIColor (LYHex)

/// 根据色值返回 UIColor , 如果为空,则为 UIColor.clearColor
/// @param hexString 色值
+ (UIColor *)ly_colorFromHexString:(NSString *)hexString;

/// 根据色值返回 UIColor , 如果为空,则为 UIColor.clearColor
/// @param hexString 色值
/// @param alpha 透明度 0.0-1.0
+ (UIColor *)ly_colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/// 渐变色
/// @param size 大小
/// @param direction 放心
/// @param startcolor 开始色
/// @param endColor 结束色
+ (UIColor *)ly_bm_colorGradientChangeWithSize:(CGSize)size
                                  direction:(GradientChangeDirection)direction
                                 startColor:(UIColor *)startcolor
                                   endColor:(UIColor *)endColor ;
/* 根据颜色创建图片 */
+ (UIImage *)ly_imageForColor:(UIColor*)aColor withSize:(CGSize)aSize;

/// 随机颜色
+ (UIColor *)ly_randomColor;

@end
NS_ASSUME_NONNULL_END
