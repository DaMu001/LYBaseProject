//
//  LYBaseVideoViewController.m
//  Example
//
//  Created by muios on 2022/4/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LYBaseVideoViewController ()
//播放器
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation LYBaseVideoViewController

#pragma mark - 视图即将出现的时候就播放视频，会显着比较流畅
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    //播放视频
    [self.player play];
    //注册通知，app从后台再次进入前台后继续播放视频
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(videoWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(videoWillEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPlayer];
}

- (void)stopPlayer
{
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
}

#pragma mark - 程序进入后台，再次进入前台的时候，继续播放视频
- (void)videoWillEnterForeground
{
    [self.player play];
    NSLog(@"继续 播放");
}

- (void)videoWillEnterBackground
{
    [self.player pause];
    NSLog(@"暂停 播放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 视频播放结束 触发
- (void)playAgain
{
    // 重头再来 seekToTime跳转到相应的时间播放
    [self.player seekToTime:kCMTimeZero];
}

#pragma mark - Lazy
- (AVPlayer *)player
{
    if (!_player) {
        
        //获取本地视频文件路径
        NSString *video_name = [self getVideoFileName];
        NSAssert(![video_name isEqualToString:@""], @"请在子类中配置 视频 文件名称");
        NSString *path = [[NSBundle mainBundle]pathForResource:video_name ofType:@"mp4"];
        NSAssert(path != nil, @"未找到 视频文件..");
        NSURL *url = [NSURL fileURLWithPath:path];
        
        //创建一个播放的item
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
        
        //播放设置
        _player = [AVPlayer playerWithPlayerItem:playItem];
        //永不暂停
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        //设置播放器
        AVPlayerLayer *layerPlay = [AVPlayerLayer playerLayerWithPlayer:_player];
        layerPlay.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layerPlay.videoGravity = AVLayerVideoGravityResizeAspectFill;
        // 将播放器至于底层，不然UI部分会被视频遮挡
        [self.view.layer insertSublayer:layerPlay atIndex:0];
        
        //设置通知，视频播放结束后 从头再次播放，达到循环的效果
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAgain) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _player;
}

- (NSString *)getVideoFileName
{
    return @"";
}

@end
