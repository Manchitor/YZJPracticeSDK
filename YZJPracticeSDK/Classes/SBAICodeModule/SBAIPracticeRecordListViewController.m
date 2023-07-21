//
//  SBAIPracticeRecordListViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/9.
//

#import "SBAIPracticeRecordListViewController.h"
#import "SBAIPracticeRecordCell.h"
#import "SBAIPracticeAnalyseViewController.h"
#import "SBAIPracticeRequest.h"
#import "SBAIPractice.h"


@interface SBAIPracticeRecordListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)NSMutableArray <SBAIPracticeTrainingRecordModel *>*dataArray;

@property (nonatomic,assign) NSInteger page;
@end

@implementation SBAIPracticeRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupconfig];//初始化页面配置
    
    [self setupui];//初始化UI
    
    [self loaddata];//请求数据
}

#pragma mark ----------初始化页面配置
-(void)setupconfig{
    self.page = 1;
    self.navigationItem.title = @"练习记录";
    self.view.backgroundColor = HEXCOLOR(0xf9f9f9);
}

#pragma mark ----------初始化页面
-(void)setupui{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(15);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(0);
    }];
    //底线上面 mas_bottomLayoutGuideTop
}

#pragma mark ----------请求数据
-(void)loaddata{
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];

    MJWeakSelf;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:loginModel.userId forKey:@"userId"];
    [params setValue:@(self.page) forKey:@"page"];
    [params setValue:@"10" forKey:@"limit"];
    
    
    [SBAIPracticeRequest sb_exerciseTrainingRecoedRequest:params Success:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        
        if (isSuccess) {
            if (weakSelf.page == 1){
                weakSelf.dataArray = [SBAIPracticeTrainingRecordModel mj_objectArrayWithKeyValuesArray:[responseObject.data objectForKey:@"list"]];
            }else{
                [weakSelf.dataArray addObjectsFromArray: [SBAIPracticeTrainingRecordModel mj_objectArrayWithKeyValuesArray:[responseObject.data objectForKey:@"list"]]];
            }
            [weakSelf.tableview reloadData];
        }else{
            if (weakSelf.page > 1) {
                weakSelf.page--;
            }
            tf_toastMsg(responseObject.msg);
        }
    }];
}

#pragma mark ----------TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView emptyViewWithCount:self.dataArray.count imageName:@"sb_ai_data_empty_list" title:@"暂无数据"];

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SBAIPracticeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SBAIPracticeRecordCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SBAIPracticeAnalyseViewController *vc = [[SBAIPracticeAnalyseViewController alloc] init];
    vc.Id = self.dataArray[indexPath.row].id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------懒加载页面控件
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = TABLEVIEW_INIT(UITableViewStylePlain, self);
        [_tableview registerClass:[SBAIPracticeRecordCell class] forCellReuseIdentifier:NSStringFromClass([SBAIPracticeRecordCell class])];

        MJWeakSelf;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf loaddata];
        }];
        _tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf loaddata];
        }];
    }
    return _tableview;
}
-(NSMutableArray<SBAIPracticeTrainingRecordModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
