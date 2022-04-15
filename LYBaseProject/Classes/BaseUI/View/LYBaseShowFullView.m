//
//  LYBaseShowView.m
//  Example
//
//  Created by muios on 2022/4/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseShowFullView.h"

@interface LYBaseShowFullView ()

@property (strong, nonatomic) UIButton * ly_showBgBtn;

@end

@implementation LYBaseShowFullView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (self = [super initWithFrame:rect]) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.ly_showBgBtn];
        self.ly_showBgBtn.frame = rect;
    }
    return self;
}

- (void)buildView
{
    
}

+ (instancetype)showInView:(UIView *)toView
{
    LYBaseShowFullView *showView = [[LYBaseShowFullView alloc] initWithFrame:CGRectZero];
    [toView addSubview:showView];
    return showView;
}

+ (void)hiddenView:(UIView *)toView
{
    [toView removeFromSuperview];
}

- (void)onClickDiss:(UIButton *)sender
{
    [self removeFromSuperview];
    [self onClickShowViewDissmiss];
}

- (void)onClickShowViewDissmiss
{
    
}

- (void)dealloc
{
    NSLog(@"%@ 释放了！！！",[self class]);
}

#pragma mark - Lazy
- (UIButton *)ly_showBgBtn
{
    if (!_ly_showBgBtn) {
        _ly_showBgBtn = [[UIButton alloc] init];
        [_ly_showBgBtn setBackgroundColor:UIColor.clearColor];
        [_ly_showBgBtn addTarget:self action:@selector(onClickDiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ly_showBgBtn;
}

@end
