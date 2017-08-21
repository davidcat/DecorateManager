//
//  ViewController.m
//  树轴
//
//  Created by Harry on 2017/3/12.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "ViewController.h"
#import "AchievementView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AchievementView *view = [[AchievementView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 500)];
    view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *mArr = [NSMutableArray array];
    NSArray *left = @[@"测试1",@"测试2",@"测试3",@"测试4",@"测试5"];
    NSArray *right = @[@"20,000",@"1,5000",@"10,0,00",@"5,000",@"1000"];
    for (int i = 0; i < left.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[AchievementViewLeftTextSymbol] = left[i];
        dic[AchievementViewRightTextSymbol] = right[i];
        dic[AchievementViewTextColorSymbol] = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        dic[AchievementViewLeftFontSymbol] = [UIFont systemFontOfSize:12];
        dic[AchievementViewRightFontSymbol] = [UIFont systemFontOfSize:16];

        [mArr addObject:dic];
    }
    
    view.dataArr = mArr;
    view.numValue = @"5123";

    
  
    [self.view addSubview:view];
}


@end
