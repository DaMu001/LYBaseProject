//
//  LYBaseMacros.h
//  Example
//
//  Created by muios on 2022/4/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/// 获取 keywindow
static inline UIWindow * LYKeyWindow()
{
    if(@available(iOS 13.0, *)) {
        NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene* windowScene = (UIWindowScene*)array[0];
        //如果是普通App开发，可以使用
        UIWindow* mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
        if(mainWindow) {
            return mainWindow;
        }else{
            return [UIApplication sharedApplication].windows.firstObject;
        }
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
}

/// 机型是否是 刘海屏
static inline BOOL LYIsIPhonex()
{
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    return isPhoneX;
}

/// 屏幕的宽度
static inline CGFloat LYScreenWidth()
{
    return [UIScreen mainScreen].bounds.size.width;
}

/// 屏幕的高度
static inline CGFloat LYScreenHeight()
{
    return [UIScreen mainScreen].bounds.size.height;
}

#pragma mark - 屏幕上各位置的高度
/// 获取 状态栏(包括安全区域) 高度
static inline CGFloat LYStatusBarHeight()
{
    CGFloat statusBarHeight = 0.0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

/// 顶部安全区 高度
static inline CGFloat LYSafeDistanceTop()
{
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 底部安全区 高度
static inline CGFloat LYSafeDistanceBottom()
{
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}

/// 获取导航栏高度
static inline CGFloat LYNavigationBarHeight()
{
    return 44.0f;
}

/// 获取导航栏 + 状态 整体的高度
static inline CGFloat LYNavigationFullHeight()
{
    return LYStatusBarHeight() + LYNavigationBarHeight();
}

/// 底部tabbar 高度
static inline CGFloat LYTabBarHeight()
{
    return 44.0f;
}

/// 底部tabbar 高度 (包括安全区)
static inline CGFloat LYTabBarFullHeight()
{
    return LYTabBarHeight() + LYSafeDistanceBottom();
}

#pragma mark - App名称相关
/// 获取APP的名字
static inline NSString * LYAppName()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

/// 获取APP的版本号
static inline NSString * LYAppVersion()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

/// 获取获取App短式版本号
static inline NSString * LYAppVersionShort()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - 简易函数
/// 获取一个随机整数范围在：[0,i)包括0，不包括i
static inline NSInteger LYRandomNumber(NSInteger i)
{
    return arc4random() % i;
}

#pragma mark - UI 适配
/// UI 设置规范的 宽高
static CGFloat standard_width = 1.0;
static CGFloat standard_height = 1.0;
/// 尺寸适配 水平方向
static inline CGFloat LYAdapterH(CGFloat horizontal)
{
    return floorf((LYScreenWidth() / standard_width) * (horizontal));
}

/// 尺寸适配 垂直方向
static inline CGFloat LYAdapterV(CGFloat vertical)
{
    return floorf((LYScreenHeight() / standard_height) * (vertical));
}

/// 尺寸适配- size 适配 长方形
static inline CGSize LYAdapterSize(CGFloat width, CGFloat height)
{
    return CGSizeMake(LYAdapterH(width), LYAdapterV(height));
}

/// 尺寸适配- size 适配 以 垂直方向 单边 (宽或者高)为基准的 正方形
static inline CGSize ly_adapterSizeWithUnilateral(CGFloat single)
{
    return CGSizeMake(LYAdapterV(single), LYAdapterV(single));
}

#pragma clang diagnostic pop

//*****************以下为宏区域**********************//
#if DEBUG
#define   NSLogFUNC NSLog(@"%s", __func__);
#define NSLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }

#else
#define NSLog(...)
#define   NSLogFUNC (...);
#endif
