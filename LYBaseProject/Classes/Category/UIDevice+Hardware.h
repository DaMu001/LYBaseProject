//
//  UIDevice.h
//
//  Created by Geniune on 2021/4/21.
//  Copyright © 2020 Geniune. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 最近更新
//2022年3月
//
//1. iPhone SE（第三代）
//2. iPad Air（第五代）

@interface UIDevice (Hardware)

//注意：请使用真机测试，否则会固定返回simulator
- (NSString *)generation;

@end
