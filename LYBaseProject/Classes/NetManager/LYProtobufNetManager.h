//
//  LYProtobufNetManager.h
//  Example
//
//  Created by damu on 2022/3/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseNetManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYProtobufNetManager : LYBaseNetManager

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类LYNetManager单例
 */
+ (instancetype)sharedProtobufNetManager;

@end

NS_ASSUME_NONNULL_END
