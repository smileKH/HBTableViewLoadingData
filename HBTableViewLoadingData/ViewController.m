//
//  ViewController.m
//  HBTableViewLoadingData
//
//  Created by Mac on 2020/11/26.
//  Copyright © 2020 yanruyu. All rights reserved.
//

#import "ViewController.h"
#import "HBMJRefreshTableView.h"
#import "HBJudgeDataLoadingVC.h"
#import "HBSwitchLoadinDataVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *arr = @[@"方法一",@"方法二",@"方法三"];
    for (int i=0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100+(40+20)*i, 100, 40);
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
#pragma mark ==========点击事件==========
-(void)clickBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            {
                //方法一：MJRefresh
                HBMJRefreshTableView *vc = [[HBMJRefreshTableView alloc]init];
                vc.title = @"MJRefresh";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
            {   //方法二：通过判断数据加载
                HBJudgeDataLoadingVC *vc = [[HBJudgeDataLoadingVC alloc]init];
                vc.title = @"通过判断数据加载";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            {
                HBSwitchLoadinDataVC *vc = [[HBSwitchLoadinDataVC alloc]init];
                vc.title = @"通过数据开关判断另一种方式";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        default:
            break;
    }
}

@end
