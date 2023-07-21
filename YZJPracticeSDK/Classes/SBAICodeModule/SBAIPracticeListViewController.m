//
//  SBAIPracticeListViewController.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/6/29.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeListViewController.h"
#import "SBAIPracticeRecordListViewController.h"
#import "SBAIPracticeIntroduceViewController.h"

#import "SBAIPractice.h"

#import "SBAIPracticeRequest.h"
#import "SBAIPracticeListCell.h"

@interface SBAIPracticeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)    UITableView *tableview;

@property (nonatomic,strong)    NSMutableArray <SBAIPracticeModel *>*dataArray;

@property (nonatomic,assign)    NSInteger page;

@property (nonatomic,strong)    UIButton *recordListButton;

@end

@implementation SBAIPracticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupconfig];//初始化页面配置
    
    [self setupui];//初始化UI
    
    [self loaddata];//请求数据
}

#pragma mark ----------初始化页面配置
-(void)setupconfig{
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"陪练列表";
}

#pragma mark ----------初始化页面
-(void)setupui{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(10);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(0);
    }];//底线上面 mas_bottomLayoutGuideTop
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.recordListButton];
    
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
    
    
    [SBAIPracticeRequest sb_exerciseListRequest:params Success:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        
        if (isSuccess) {
            if (weakSelf.page == 1){
                weakSelf.dataArray = [SBAIPracticeModel mj_objectArrayWithKeyValuesArray:[responseObject.data objectForKey:@"list"]];
            }else{
                [weakSelf.dataArray addObjectsFromArray: [SBAIPracticeModel mj_objectArrayWithKeyValuesArray:[responseObject.data objectForKey:@"list"]]];
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

-(void)recordListButtonEvent{
    SBAIPracticeRecordListViewController *vac = [[SBAIPracticeRecordListViewController alloc] init];
    [self.navigationController pushViewController:vac animated:YES];
}

#pragma mark ---------开始陪练按钮点击事件
-(void)practiceButtonEvent:(SBAIPracticeModel *)item{
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];
    if (item.supervision && !loginModel.faceFlag){//需要人脸
        //        SBAIFaceGuideViewController *vc = [[SBAIFaceGuideViewController alloc] initWithNibName:@"SBAIFaceGuideViewController" bundle:[NSBundle mainBundle]];
        //        SBAIBaseNavViewController *nav = [[SBAIBaseNavViewController alloc] initWithRootViewController:vc];
        //        nav.modalPresentationStyle = UIModalPresentationCustom;
        //        [self presentViewController:nav animated:YES completion:nil];
    }else{
//        SBAIPracticeIntroduceViewController *vc = [[SBAIPracticeIntroduceViewController alloc] init];
//        vc.exerciseId = item.exerciseId;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
    SBAIPracticeIntroduceViewController *vc = [[SBAIPracticeIntroduceViewController alloc] init];
    vc.exerciseId = item.exerciseId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView emptyViewWithCount:self.dataArray.count imageName:@"sb_ai_data_empty_list" title:@"暂无数据"];
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SBAIPracticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SBAIPracticeListCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    MJWeakSelf;
        cell.practiceBlock = ^(SBAIPracticeModel * _Nonnull item) {
            [weakSelf practiceButtonEvent:item];
        };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark ----------懒加载页面控件
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = TABLEVIEW_INIT(UITableViewStylePlain, self);
        [_tableview registerClass:[SBAIPracticeListCell class] forCellReuseIdentifier:NSStringFromClass([SBAIPracticeListCell class])];
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

-(NSMutableArray<SBAIPracticeModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(UIButton *)recordListButton{
    if (!_recordListButton) {
        _recordListButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [_recordListButton addTarget:self action:@selector(recordListButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [_recordListButton setTitle:@"陪练记录" forState:UIControlStateNormal];
        _recordListButton.titleLabel.font = FONT_SYS_NOR(14);
        [_recordListButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _recordListButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        _recordListButton.backgroundColor = [UIColor clearColor];
    }
    return _recordListButton;
}
@end
