//
//  TabBarViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/17.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self addChildVC:@"VideoOne"];
    [self addChildVC:@"VideoTwo"];
    [self addChildVC:@"VideoThree"];
    [self addChildVC:@"VideoFour"];
   
}

- (void)addChildVC:(NSString *)storyName {
    
    UIViewController *VC = [UIStoryboard storyboardWithName:storyName bundle:nil].instantiateInitialViewController;
    [self addChildViewController:VC];
}


@end
