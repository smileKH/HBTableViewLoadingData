//
//  HBMJRefreshTableView.m
//  HBTableViewLoadingData
//
//  Created by Mac on 2020/11/26.
//  Copyright © 2020 yanruyu. All rights reserved.
//

#import "HBMJRefreshTableView.h"
#import <Masonry.h>
#import <MJRefresh.h>
//strong weak  self
#define WEAKSELF typeof(self) __weak weakSelf = self
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf
@interface HBMJRefreshTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *allData;
//当前页
@property (nonatomic , assign)int pageNo;
//每页大小
@property (nonatomic , assign)int pageSize;
@end

@implementation HBMJRefreshTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.pageSize = 10;
    self.allData = [NSMutableArray array];
    //添加子视图
    [self addSubViewUI];
    //添加刷新
    [self addRefresh];
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
- (void)addRefresh{
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求数据
        weakSelf.pageNo = 1;
        [weakSelf requestListData];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //请求数据
        weakSelf.pageNo++;
        [weakSelf requestListData];
    }];
    //自动触发时间，如果为 -1, 则为无限触发
    footer.autoTriggerTimes = -1;
    //当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新，设置为-1则是未到满屏的时候刷新
    footer.triggerAutomaticallyRefreshPercent = -1;
    self.tableView.mj_footer = footer;
}
- (void)endRefresh{
    if (self.tableView.mj_header.refreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.refreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark ==========模拟加载数据==========
-(void)requestListData{
    //模拟请求网络数据
     WEAKSELF;
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
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            //[weakSelf dissmissHud];
            [weakSelf.allData addObjectsFromArray:arr];
            [weakSelf endRefresh];
            if (arr.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
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
