//
//  LYBaseVideoViewController.h
//  Example
//
//  Created by muios on 2022/4/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 背景-视频播放控制器
@interface LYBaseVideoViewController : UIViewController
/// 获取 需要播放的 视频 播放文件名称
- (NSString *)getVideoFileName;

@end

NS_ASSUME_NONNULL_END
