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
    
    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    red.backgroundColor = LYColorHexWithAlpha(@"#e34a45",0.2);
    red.ly_viewCornerRadius = 20;
    red.ly_viewRectCornerType = LYKit_ViewRectCornerTypeTopLeft;
    red.ly_viewBorderColor = UIColor.blueColor;
    red.ly_viewBorderWidth = 10;
    [self.view addSubview:red];
}


@end
