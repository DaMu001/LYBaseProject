//
//  LYDataEntity.h
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 babo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 请求实体，承载请求参数 */
@interface LYDataEntity : NSObject

/** 请求路径 */
@property (nonatomic, copy) NSString *urlString;
/** 请求参数 */
@property (nonatomic, copy) id parameters;

#pragma mark - 适配 AFN 4.0
/** 请求头， 适配新版本 */
@property(nonatomic, strong) NSDictionary *headers;

/**
 将传入 的 string 参数序列化，body 请求
 */
@property(nonatomic, assign) BOOL isSetQueryStringSerialization;

@end

