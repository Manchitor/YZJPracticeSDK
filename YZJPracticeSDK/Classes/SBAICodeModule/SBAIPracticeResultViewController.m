//
//  SBAIPracticeResultViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/9.
//

#import "SBAIPracticeResultViewController.h"
#import "SBAIPracticeResultInfoCell.h"
#import "SBAIPracticeResultAnalyzeCell.h"
#import "SBAIPracticeResultExplainCell.h"
#import "SBAIPractice.h"

@interface SBAIPracticeResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableview;

@end

@implementation SBAIPracticeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupconfig];//初始化页面配置
    
    [self setupui];//初始化UI
    
}

#pragma mark ----------初始化页面配置
-(void)setupconfig{
    self.navigationItem.title = @"练习详情";
    self.view.backgroundColor = HEXCOLOR(0xF9F9F9);
}

#pragma mark ----------初始化页面
-(void)setupui{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(0);
    }];
    //底线上面 mas_bottomLayoutGuideTop
}

-(void)setDataModel:(SBAIPracticeResultModel *)dataModel{
    _dataModel = dataModel;
    [self.tableview reloadData];
}

#pragma mark ----------TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        SBAIPracticeResultInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SBAIPracticeResultInfoCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataModel;
        return cell;
    }else if (indexPath.row == 1){
        SBAIPracticeResultAnalyzeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SBAIPracticeResultAnalyzeCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataModel;
        return cell;
    }else if (indexPath.row == 2){
        SBAIPracticeResultExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SBAIPracticeResultExplainCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataModel;
        return cell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark ----------懒加载页面控件
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = TABLEVIEW_INIT(UITableViewStylePlain, self);
        [_tableview registerClass:[SBAIPracticeResultInfoCell class] forCellReuseIdentifier:NSStringFromClass([SBAIPracticeResultInfoCell class])];
        [_tableview registerClass:[SBAIPracticeResultAnalyzeCell class] forCellReuseIdentifier:NSStringFromClass([SBAIPracticeResultAnalyzeCell class])];
        [_tableview registerClass:[SBAIPracticeResultExplainCell class] forCellReuseIdentifier:NSStringFromClass([SBAIPracticeResultExplainCell class])];

        
    }
    return _tableview;
}


@end
