//
//  UIView+LY_CornerRadius.m
//  Example
//
//  Created by muios on 2022/4/11.
//  Copyright © 2022 babo. All rights reserved.
//

#import "UIView+LY_CornerRadius.h"
#import <objc/runtime.h>

/*! runtime set */
#define LYKit_Objc_setObj(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

/*! runtime setCopy */
#define LYKit_Objc_setObjCOPY(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY)

/*! runtime get */
#define LYKit_Objc_getObj objc_getAssociatedObject(self, _cmd)

@implementation UIView (LY_CornerRadius)

- (void)ly_view_setViewRectCornerType:(LYKit_ViewRectCornerType)type          viewCornerRadius:(CGFloat)viewCornerRadius {
    self.ly_viewCornerRadius = viewCornerRadius;
    self.ly_viewRectCornerType = type;
}

/**
 快速切圆角，带边框、边框颜色
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)ly_view_setViewRectCornerType:(LYKit_ViewRectCornerType)type          viewCornerRadius:(CGFloat)viewCornerRadius               borderWidth:(CGFloat)borderWidth               borderColor:(UIColor *)borderColor {
    self.ly_viewCornerRadius = viewCornerRadius;
    self.ly_viewRectCornerType = type;
    self.ly_viewBorderWidth = borderWidth;
    self.ly_viewBorderColor = borderColor;
}

#pragma mark - view 的 角半径，默认 CGSizeMake(0, 0)
- (void)setupViewCornerType {
    
    if (CGRectEqualToRect(self.bounds, CGRectZero)) {
        NSLog(@"******** %s view frame 错误！", __func__);
    }
    UIRectCorner corners;
    CGSize cornerRadii;
    
    cornerRadii = CGSizeMake(self.ly_viewCornerRadius, self.ly_viewCornerRadius);
    
    switch (self.ly_viewRectCornerType) {
        case LYKit_ViewRectCornerTypeBottomLeft: {
            corners = UIRectCornerBottomLeft;
        } break;
        case LYKit_ViewRectCornerTypeBottomRight: {
            corners = UIRectCornerBottomRight;
        } break;
        case LYKit_ViewRectCornerTypeTopLeft: {
            corners = UIRectCornerTopLeft;
        } break;
        case LYKit_ViewRectCornerTypeTopRight: {
            corners = UIRectCornerTopRight;
        } break;
        case LYKit_ViewRectCornerTypeBottomLeftAndBottomRight: {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } break;
        case LYKit_ViewRectCornerTypeTopLeftAndTopRight: {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        } break;
        case LYKit_ViewRectCornerTypeTopLeftAndBottomRight: {
            corners = UIRectCornerTopLeft | UIRectCornerBottomRight;
        } break;
        case LYKit_ViewRectCornerTypeBottomLeftAndTopLeft: {
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
        } break;
        case LYKit_ViewRectCornerTypeBottomRightAndTopRight: {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
        } break;
        case LYKit_ViewRectCornerTypeBottomRightAndTopRightAndTopLeft: {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
        } break;
        case LYKit_ViewRectCornerTypeBottomRightAndTopRightAndBottomLeft: {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
        } break;
        case LYKit_ViewRectCornerTypeAllCorners: {
            corners = UIRectCornerAllCorners;
        } break;
        default:
            break;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     byRoundingCorners:corners
                                                           cornerRadii:cornerRadii];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = self.bounds;
    
    self.layer.mask = shapeLayer;
    
    if (self.ly_viewBorderWidth > 0) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.path = bezierPath.CGPath;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = self.ly_viewBorderColor.CGColor;
        borderLayer.lineWidth = self.ly_viewBorderWidth;
        borderLayer.frame = self.bounds;
        [self.layer addSublayer:borderLayer];
    }
}

#pragma mark - setter / getter
- (void)setLy_viewRectCornerType:(LYKit_ViewRectCornerType)ly_viewRectCornerType {
    LYKit_Objc_setObj(@selector(ly_viewRectCornerType), @(ly_viewRectCornerType));
    [self setupViewCornerType];
}

- (LYKit_ViewRectCornerType)ly_viewRectCornerType {
    return [LYKit_Objc_getObj integerValue];
}

- (void)setLy_viewCornerRadius:(CGFloat)ly_viewCornerRadius {
    LYKit_Objc_setObj(@selector(ly_viewCornerRadius), @(ly_viewCornerRadius));
}

- (CGFloat)ly_viewCornerRadius {
    return [LYKit_Objc_getObj integerValue];
}

- (void)setLy_viewBorderWidth:(CGFloat)ly_viewBorderWidth {
    LYKit_Objc_setObj(@selector(ly_viewBorderWidth), @(ly_viewBorderWidth));
    [self setupViewCornerType];
}

- (CGFloat)ly_viewBorderWidth {
    return [LYKit_Objc_getObj floatValue];
}

- (void)setLy_viewBorderColor:(UIColor *)ly_viewBorderColor {
    LYKit_Objc_setObj(@selector(ly_viewBorderColor), ly_viewBorderColor);
    [self setupViewCornerType];
}

- (UIColor *)ly_viewBorderColor {
    return LYKit_Objc_getObj;
}

@end
