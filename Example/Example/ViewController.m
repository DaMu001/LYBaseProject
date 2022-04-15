//
//  ViewController.m
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 babo. All rights reserved.
//

#import "ViewController.h"
#import "LYBaseProjectHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the  view.
    
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = LYColorHexWithAlpha(@"#e34a45",0.2);
    red.ly_viewCornerRadius = 20;
//    red.ly_viewRectCornerType = LYKit_ViewRectCornerTypeTopLeft;
    red.ly_viewBorderColor = UIColor.blueColor;
    red.ly_viewBorderWidth = 10;
    [self.view addSubview:red];
    
//    [red mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(100);
//        make.size.mas_equalTo(CGSizeMake(200, 200));
//    }];
    
    UIView *yellow = [[UIView alloc] init];
    yellow.backgroundColor = UIColor.yellowColor;
//    yellow.ly_viewCornerRadius = 20;
//    yellow.ly_viewRectCornerType = LYKit_ViewRectCornerTypeTopLeft;
//    yellow.ly_viewBorderColor = UIColor.blueColor;
//    yellow.ly_viewBorderWidth = 10;
    [self.view addSubview:yellow];
    
    UIView *blue = [[UIView alloc] init];
    blue.backgroundColor = UIColor.blueColor;
//    blue.ly_viewCornerRadius = 20;
//    blue.ly_viewRectCornerType = LYKit_ViewRectCornerTypeTopLeft;
//    blue.ly_viewBorderColor = UIColor.blueColor;
//    blue.ly_viewBorderWidth = 10;
    [self.view addSubview:blue];
    
    

    
    UIImageView *img = [[UIImageView alloc] init];
//    [img addGestureRecognizerTarget:self action:@selector(onClick:)];
    [img addGestureRecognizerBlockAction:^(UIImageView * _Nonnull imageView, UITapGestureRecognizer * _Nonnull tap) {
        NSLog(@"UITapGestureRecognizerUITapGestureRecognizer");
    }];
    [self.view addSubview:img];
    
    
    NSArray *vs = @[red,yellow,blue,img];
//    [vs mas_distributeSudokuViewsWithFixedItemWidth:100 fixedItemHeight:200 warpCount:2 topSpacing:10 bottomSpacing:20 leadSpacing:10 tailSpacing:10];
    [vs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [vs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(100);
    }];
    
    CGFloat t1 = LYSafeDistanceTop();
    CGFloat t2 = LYSafeDistanceBottom();
    CGFloat t3 = LYStatusBarHeight();
    CGFloat t4 = LYNavigationFullHeight();
    CGFloat t5 = LYTabBarFullHeight();

    
    NSLog(@"");
}


@end
