//
//  UIColor+LY_Hex.m
//  Example
//
//  Created by muios on 2022/4/11.
//  Copyright © 2022 babo. All rights reserved.
//

#import "UIColor+LY_Hex.h"
#import "LYStringMacrocDefine.h"

@implementation UIColor (LY_Hex)

+ (UIColor *)ly_colorFromHexString:(NSString *)hexString
{
    if (LYStringIsNull(hexString)) {
        return [UIColor clearColor];
    }
    if([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }
    unsigned hexNum;
    if ( ![[NSScanner scannerWithString:hexString] scanHexInt:&hexNum] ) {
        return nil;
    }
    
    return [UIColor colorWithRed:((float)((hexNum & 0xFF0000) >> 16))/255.0 green:((float)((hexNum & 0xFF00) >> 8))/255.0 blue:((float)(hexNum & 0xFF))/255.0 alpha:1.0];
}
+ (UIColor *)ly_colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    if (LYStringIsNull(hexString)) {
        return [UIColor clearColor];
    }
    if([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }
    unsigned hexNum;
    if ( ![[NSScanner scannerWithString:hexString] scanHexInt:&hexNum] ) {
        return nil;
    }
    
    return [UIColor colorWithRed:((float)((hexNum & 0xFF0000) >> 16))/255.0 green:((float)((hexNum & 0xFF00) >> 8))/255.0 blue:((float)(hexNum & 0xFF))/255.0 alpha:alpha];
    
}

//绘制渐变色颜色的方法
+ (UIColor *)ly_bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(GradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return [UIColor clearColor];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == GradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(1.0, 1.0);
    }
    if (direction == GradientChangeDirectionUpwardDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case GradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case GradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case GradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case GradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0, @1];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

/* 根据颜色创建图片 */
+ (UIImage *)ly_imageForColor:(UIColor*)aColor withSize:(CGSize)aSize
{
    if (!aColor) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, aSize.width, aSize.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIColor *)ly_randomColor
{
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

@end
