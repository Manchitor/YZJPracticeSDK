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


/// 单一弹框类型
typedef NS_ENUM(NSInteger, SBAIPracticeListType) {
    /// 未完成
    SBAIPracticeListTypeWait             = 0,
    /// 已完成
    SBAIPracticeListTypeFinish           = 1,
    /// 已过期
    SBAIPracticeListTypeExpired          = 2,
    /// 未通过
    SBAIPracticeListTypeUnpass           = 3,
    /// 全部
    SBAIPracticeListTypeAll              = 4,
    
};

@interface SBAIPracticeListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSMutableArray <SBAIPracticeModel *>*dataArray;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UIView *searchView;

@property (nonatomic,strong) UIImageView *searchImg;

@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,strong) UIView *typeview;

@property (nonatomic,strong) UIButton *allBtn;

@property (nonatomic,strong) UIButton *waitBtn;

@property (nonatomic,strong) UIButton *finishBtn;

@property (nonatomic,strong) UIButton *unpassBtn;

@property (nonatomic,strong) UIButton *expiredBtn;

@property (nonatomic,strong) NSMutableArray<UIButton *> *buttonArray;

@property (nonatomic,assign) SBAIPracticeListType type;//业务状态:0-去完成；1-已完成；2-已过期; 3-未通过
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
    self.view.backgroundColor = HEXCOLOR(0xF9F9F9);
    self.navigationItem.title = @"陪练列表";
    self.type = SBAIPracticeListTypeAll;
}

#pragma mark ----------初始化页面
-(void)setupui{
    
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self.searchView addSubview:self.searchImg];
    [self.searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView.mas_left).offset(12);
        make.centerY.equalTo(self.searchView);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.searchView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchImg.mas_right).offset(8);
        make.top.bottom.equalTo(self.searchView);
        make.right.equalTo(self.searchView.mas_right);
    }];
    
    [self.view addSubview:self.typeview];
    [self.typeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    CGFloat width = (SCREEN_WIDTH - 70)/5.0;
    CGFloat margin = 10;

    [self.typeview addSubview:self.allBtn];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeview.mas_left).offset(15);
        make.width.mas_equalTo(width);
        make.centerY.equalTo(self.typeview);
        make.height.mas_equalTo(26);
    }];
    
    [self.typeview addSubview:self.waitBtn];
    [self.waitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allBtn.mas_right).offset(margin);
        make.width.mas_equalTo(width);
        make.centerY.equalTo(self.typeview);
        make.height.mas_equalTo(26);
    }];
    
    [self.typeview addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitBtn.mas_right).offset(margin);
        make.width.mas_equalTo(width);
        make.centerY.equalTo(self.typeview);
        make.height.mas_equalTo(26);
    }];
    
    [self.typeview addSubview:self.unpassBtn];
    [self.unpassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishBtn.mas_right).offset(margin);
        make.width.mas_equalTo(width);
        make.centerY.equalTo(self.typeview);
        make.height.mas_equalTo(26);
    }];
    
    [self.typeview addSubview:self.expiredBtn];
    [self.expiredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unpassBtn.mas_right).offset(margin);
        make.width.mas_equalTo(width);
        make.centerY.equalTo(self.typeview);
        make.height.mas_equalTo(26);
    }];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeview.mas_bottom).offset(10);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(0);
    }];//底线上面 mas_bottomLayoutGuideTop
    
    [self.buttonArray addObjectsFromArray:@[self.allBtn,self.waitBtn,self.finishBtn,self.unpassBtn,self.expiredBtn]];
}

-(void)typeButtonEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    
    for (UIButton *btn in self.buttonArray) {
        btn.backgroundColor = HEXCOLOR(0xF6F6F6);
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    }
    
    sender.backgroundColor = HEXCOLOR(0xECF5FF);
    [sender setTitleColor:HEXCOLOR(0x52A0FF) forState:UIControlStateNormal];
    
    self.type = (SBAIPracticeListType)sender.tag;
    
    self.page = 1;
    self.searchTextField.text = @"";
    [self loaddata];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length) {
        self.page = 1;
        [self loaddata];
    }
    
    [self.searchTextField resignFirstResponder];
    
    return YES;
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
    if (self.type != SBAIPracticeListTypeAll) {
        [params setValue:@(self.type) forKey:@"businessStatus"];
    }
    if (!tf_isEmptyString(self.searchTextField.text)) {
        [params setValue:self.searchTextField.text forKey:@"exerciseName"];
    }

    
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

#pragma mark ---------开始陪练按钮点击事件
-(void)practiceButtonEvent:(SBAIPracticeModel *)item{
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];
    
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

-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = HEXCOLOR(0xf8f8f8);
        _searchView.layer.cornerRadius = 15;
        _searchView.clipsToBounds = YES;
    }
    return _searchView;
}

-(UIImageView *)searchImg{
    if (!_searchImg) {
        _searchImg = [[UIImageView alloc] init];
        _searchImg.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_other_search"];
        
    }
    return _searchImg;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.textColor = HEXCOLOR(0x333333);
        _searchTextField.font = FONT_SYS_NOR(14);
        _searchTextField.placeholder = @"搜索";
        [_searchTextField setPlaceholderColor:HEXCOLOR(0xcccccc)];
        _searchTextField.delegate = self;
    }
    return  _searchTextField;
}

-(UIView *)typeview{
    if (!_typeview) {
        _typeview = [[UIView alloc] init];
        _typeview.backgroundColor = [UIColor whiteColor];
    }
    return _typeview;
}

-(UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allBtn setTitleColor:HEXCOLOR(0x52A0FF) forState:UIControlStateNormal];
        _allBtn.titleLabel.font = FONT_SYS_NOR(12);
        _allBtn.layer.cornerRadius = 13;
        _allBtn.clipsToBounds = YES;
        _allBtn.backgroundColor = HEXCOLOR(0xECF5FF);
        _allBtn.tag = SBAIPracticeListTypeAll;
        [_allBtn addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}

-(UIButton *)waitBtn{
    if (!_waitBtn) {
        _waitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_waitBtn setTitle:@"待完成" forState:UIControlStateNormal];
        [_waitBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _waitBtn.titleLabel.font = FONT_SYS_NOR(12);
        _waitBtn.layer.cornerRadius = 13;
        _waitBtn.clipsToBounds = YES;
        _waitBtn.backgroundColor = HEXCOLOR(0xF6F6F6);
        _waitBtn.tag = SBAIPracticeListTypeWait;
        [_waitBtn addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _waitBtn;
}

-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = FONT_SYS_NOR(12);
        _finishBtn.layer.cornerRadius = 13;
        _finishBtn.clipsToBounds = YES;
        _finishBtn.backgroundColor = HEXCOLOR(0xF6F6F6);
        _finishBtn.tag = SBAIPracticeListTypeFinish;
        [_finishBtn addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

-(UIButton *)unpassBtn{
    if (!_unpassBtn) {
        _unpassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unpassBtn setTitle:@"未通过" forState:UIControlStateNormal];
        [_unpassBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _unpassBtn.titleLabel.font = FONT_SYS_NOR(12);
        _unpassBtn.layer.cornerRadius = 13;
        _unpassBtn.clipsToBounds = YES;
        _unpassBtn.backgroundColor = HEXCOLOR(0xF6F6F6);
        _unpassBtn.tag = SBAIPracticeListTypeUnpass;
        [_unpassBtn addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unpassBtn;
}

-(UIButton *)expiredBtn{
    if (!_expiredBtn) {
        _expiredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expiredBtn setTitle:@"已过期" forState:UIControlStateNormal];
        [_expiredBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _expiredBtn.titleLabel.font = FONT_SYS_NOR(12);
        _expiredBtn.layer.cornerRadius = 13;
        _expiredBtn.clipsToBounds = YES;
        _expiredBtn.backgroundColor = HEXCOLOR(0xF6F6F6);
        _expiredBtn.tag = SBAIPracticeListTypeExpired;
        [_expiredBtn addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expiredBtn;
}


-(NSMutableArray<UIButton *> *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

@end
