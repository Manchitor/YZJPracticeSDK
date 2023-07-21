//
//  SBAIPracticeAnslyseReviewView.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/3.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeAnslyseReviewView.h"
#import "SBAIPracticeAnswerReviewCell.h"
#import "SBAIPractice.h"

@interface SBAIPracticeAnslyseReviewView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *content;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)NSMutableArray *dataArray;


@end
@implementation SBAIPracticeAnslyseReviewView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self setupui];
    }
    return self;
}

-(void)setupui{
    [self addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);

    }];
    
    [self.content addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_left).offset(15);
        make.top.equalTo(self.content.mas_top).offset(15);
    }];
    
    [self.content addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self.content).offset(0);
        make.bottom.equalTo(self.content.mas_bottom).offset(0);
    }];
}

-(void)setModel:(SBAIPracticeAnalyzeModel *)model{
    _model = model;
    self.dataArray = [NSMutableArray arrayWithArray:model.staffEntities];
    [self.tableview reloadData];
}

#pragma mark ----------TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SBAIPracticeAnswerReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SBAIPracticeAnswerReviewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.dataArray[indexPath.row] index:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemBlock){
        self.itemBlock(self.dataArray[indexPath.row]);
    }
}

#pragma mark ----------懒加载页面控件

-(UIView *)content{
    if (!_content) {
        _content = [[UIView alloc] init];
        _content.backgroundColor = [UIColor whiteColor];
        _content.layer.cornerRadius = 5;
        _content.clipsToBounds = YES;
    }
    return _content;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = FONT_SYS_MEDIUM(15);
        _titleLabel.text = @"答题回顾";
    }
    return _titleLabel;
}

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = TABLEVIEW_INIT(UITableViewStylePlain, self);
        [_tableview registerClass:[SBAIPracticeAnswerReviewCell class] forCellReuseIdentifier:NSStringFromClass([SBAIPracticeAnswerReviewCell class])];
    }
    return _tableview;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)dealloc{
    self.itemBlock = nil;
}

@end
