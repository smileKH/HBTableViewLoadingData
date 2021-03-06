//
//  HBJudgeDataLoadingVC.m
//  HBTableViewLoadingData
//
//  Created by Mac on 2020/11/26.
//  Copyright © 2020 yanruyu. All rights reserved.
//

#import "HBJudgeDataLoadingVC.h"
#import <Masonry.h>
#import <MJRefresh.h>
//strong weak  self
#define WEAKSELF typeof(self) __weak weakSelf = self
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf
@interface HBJudgeDataLoadingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *allData;
//当前页
@property (nonatomic , assign)int pageNo;
//每页大小
@property (nonatomic , assign)int pageSize;
@property (nonatomic ,assign)BOOL isLoading;//判断是否加载
@end

@implementation HBJudgeDataLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.pageSize = 20;
    self.allData = [NSMutableArray array];
    self.isLoading = YES;
    //添加子视图
    [self addSubViewUI];
    //请求数据
    [self requestListData];
}
#pragma mark ==========添加子视图==========
-(void)addSubViewUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark ==========模拟加载数据==========
-(void)requestListData{
    //模拟请求网络数据
     WEAKSELF;
    self.isLoading = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.0);
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<self.pageSize; i++) {
            NSString *str = @"哈哈哈哈哈";
            [arr addObject:str];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.pageNo == 1 && weakSelf.allData.count) { //清空
                [weakSelf.allData removeAllObjects];
            }
            self.isLoading = NO;
            //[weakSelf dissmissHud];
            [weakSelf.allData addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
        });
    });
}
#pragma mark ==========tableViewDelegate==========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allData.count;
}
#pragma mark ==========tableview代理方法==========
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //系统Cell及代码创建Cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.allData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading == YES) {
        return;
    }
    // 80%出现后，需要去加载数据
    if (indexPath.row > self.allData.count * 0.8) {
        self.pageNo++;
        [self requestListData];
    }
    
}
#pragma mark ==========tableViewGetter==========
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.backgroundColor = [UIColor whiteColor];
            //设置分割线样式
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            //cell的分割线距视图距离
            tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
            //隐藏底部多余分割线
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            //隐藏头部多余间距
            tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
            //iOS11默认开启Self-Sizing，需关闭才能设置Header,Footer高度
            tableView.estimatedRowHeight = 66;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.rowHeight = 50 ;
            tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
            tableView ;
        }) ;
    }
    return _tableView;
}

@end
