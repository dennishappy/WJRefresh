//
//  ViewController.m
//  WJRefresh
//
//  Created by 吴计强 on 16/4/6.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//

#import "ViewController.h"
#import "WJRefresh.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)   UITableView     *mtableView;
@property (nonatomic,strong) NSMutableArray  *dataSource;
@property (nonatomic,strong) WJRefresh *refresh;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WJRefresh";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}

- (void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    [self.view addSubview:tableView];
    self.mtableView = tableView;
    
    /* 初始化控件 */
    _refresh = [[WJRefresh alloc]init];
    __weak typeof(self)weakSelf = self;
    [_refresh addHeardRefreshTo:tableView heardBlock:^{
        [weakSelf createData];
    } footBlok:^{
        [weakSelf createFootData];
    }];
    [_refresh beginHeardRefresh];
    
}


- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataSource removeAllObjects];
        self.dataSource = [NSMutableArray array];
        for (int i = 100; i < 120; i ++) {
            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.mtableView reloadData];
        [_refresh endRefresh];
    });

}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 200; i < 210; i ++) {
            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.mtableView reloadData];
        [_refresh endRefresh];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
