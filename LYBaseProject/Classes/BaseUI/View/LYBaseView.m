//
//  LYBaseView.m
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseView.h"

@implementation LYBaseView

- (void)dealloc
{
    NSLog(@"%@ 释放了！！！",[self class]);
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self buildInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self buildInitFrame:frame];
    }
    return self;
}

- (void)buildInit
{

}

- (void)buildInitFrame:(CGRect)frame
{

}


@end
