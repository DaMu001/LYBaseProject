//
//  LYFormNetManager.m
//  Example
//
//  Created by damu on 2022/3/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYFormNetManager.h"

@interface LYFormNetManager ()

@end

@implementation LYFormNetManager

+ (instancetype)sharedFromNetManager
{
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static id sharedFromNetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFromNetManager = [[super allocWithZone:NULL] init];
    });
    return sharedFromNetManager;
}

+ (void)initialize
{
    [self setupFormNetManager];
}

+ (void)setupFormNetManager
{
    LYFormNetManager.sharedFromNetManager.sessionManager = [AFHTTPSessionManager manager];
    /*! 设置请求超时时间，默认：30秒 */
    LYFormNetManager.sharedFromNetManager.timeoutInterval = 15;
    /*! 打开状态栏的等待菊花 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 设置响应数据的基本类型 */
    LYFormNetManager.sharedFromNetManager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*",nil];
    
    LYFormNetManager.sharedFromNetManager.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    LYFormNetManager.sharedFromNetManager.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self ly_setValue:@"*/*" forHTTPHeaderKey:@"Accept"];
    [self ly_setValue:@"application/x-www-form-urlencoded" forHTTPHeaderKey:@"Content-Type"];
}

+ (LYBaseNetManager *)getAFHTTPSessionManager
{
    return LYFormNetManager.sharedFromNetManager;
}

/**
 *  自定义请求头
 */
+ (void)ly_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey
{
    [LYFormNetManager.sharedFromNetManager.sessionManager.requestSerializer setValue:value forHTTPHeaderField:HTTPHeaderKey];
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    [super setTimeoutInterval:timeoutInterval];
    LYFormNetManager.sharedFromNetManager.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (void)setHttpHeaderFieldDictionary:(NSDictionary *)httpHeaderFieldDictionary
{
    [super setHttpHeaderFieldDictionary:httpHeaderFieldDictionary];
    if (![httpHeaderFieldDictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    NSArray *keyArray = httpHeaderFieldDictionary.allKeys;
    
    if (keyArray.count <= 0) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    
    for (NSInteger i = 0; i < keyArray.count; i ++) {
        NSString *keyString = keyArray[i];
        NSString *valueString = httpHeaderFieldDictionary[keyString];
        
        [LYFormNetManager ly_setValue:valueString forHTTPHeaderKey:keyString];
    }
}

+ (void)ly_clearAuthorizationHeader {
    [LYFormNetManager.sharedFromNetManager.sessionManager.requestSerializer clearAuthorizationHeader];
}

@end
