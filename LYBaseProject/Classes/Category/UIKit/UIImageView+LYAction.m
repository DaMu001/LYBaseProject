//
//  UIImageView+LYAction.m
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import "UIImageView+LYAction.h"
#import <objc/runtime.h>

@interface UIImageView ()

@property(nonatomic ,copy) ImageViewActionCallBack callBack;

@end

@implementation UIImageView (LYAction)

- (void)addGestureRecognizerTarget:(nullable id)target action:(nullable SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)addGestureRecognizerBlockAction:(ImageViewActionCallBack)action
{
    self.callBack = action;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCallBack:)];
    [self addGestureRecognizer:tap];
}

- (void)onClickCallBack:(UITapGestureRecognizer *)tap
{
    if (self.callBack) {
        self.callBack(self,tap);
    }
}

- (void)setCallBack:(ImageViewActionCallBack)callBack
{
    objc_setAssociatedObject(self,@selector(callBack), callBack,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ImageViewActionCallBack)callBack
{
    return objc_getAssociatedObject(self,@selector(callBack));
}

@end
