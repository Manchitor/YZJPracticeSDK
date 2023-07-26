//
//  SBAIPracticeRecordMainViewController.m
//  Pods
//
//  Created by 刘永吉 on 2023/7/25.
//

#import "SBAIPracticeRecordMainViewController.h"
#import "SBAIPracticeRecordListViewController.h"
#import "SBAIPractice.h"

@interface SBAIPracticeRecordMainViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIView *head;

@property (nonatomic,strong) UIButton *passBtn;

@property (nonatomic,strong) UIButton *unpassBtn;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UIScrollView *scro;

@property (nonatomic,strong) SBAIPracticeRecordListViewController *passvc;

@property (nonatomic,strong) SBAIPracticeRecordListViewController *unpassvc;

@end

@implementation SBAIPracticeRecordMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupui];
}

-(void)setupui{
    [self.view addSubview:self.head];
    [self.head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(35);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
    }];
    
    [self.head addSubview:self.passBtn];
    [self.passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.left.equalTo(self.head.mas_left).offset((SCREEN_WIDTH/2.0 -80)/2.0);
        make.top.equalTo(self.head.mas_top);
        make.bottom.equalTo(self.head.mas_bottom);
    }];
    
    [self.head addSubview:self.unpassBtn];
    [self.unpassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.right.equalTo(self.head.mas_right).offset(-(SCREEN_WIDTH/2.0 -80)/2.0);
        make.top.equalTo(self.head.mas_top);
        make.bottom.equalTo(self.head.mas_bottom);
    }];
    
    [self.head addSubview:self.line];
    self.line.frame = CGRectMake((SCREEN_WIDTH/2.0 -28)/2.0 , 33, 28, 2);
   
    
    [self.view addSubview:self.scro];
    [self.scro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.head.mas_bottom);
        make.left.equalTo(self.head.mas_left);
        make.right.equalTo(self.head.mas_right);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(0);
    }];
    
    [self.scro addSubview:self.passvc.view];
    [self.passvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scro);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT - 35 - NAV_HEIGHT);
    }];
    
    [self.scro addSubview:self.unpassvc.view];
    [self.unpassvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scro.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.equalTo(self.scro.mas_left).offset(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT - 35 - NAV_HEIGHT);
    }];
}

#pragma mark ----------页面事件
-(void)passBtnEvent{
    [self.passBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.unpassBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake((SCREEN_WIDTH/2.0 -28)/2.0 , 33, 28, 2);
    }];
    self.scro.contentOffset = CGPointMake(0, 0);

}

-(void)unpassBtnEvent{
    [self.unpassBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.passBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake((SCREEN_WIDTH/2.0 -28)/2.0 + SCREEN_WIDTH/2.0, 33, 28, 2);
    }];
    self.scro.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [self passBtnEvent];
    }else if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self unpassBtnEvent];
    }
}

#pragma mark ----------懒加载
-(UIView *)head{
    if (!_head) {
        _head = [[UIView alloc] init];
        _head.backgroundColor = [UIColor whiteColor];
    }
    return _head;
}

-(UIButton *)passBtn{
    if (!_passBtn) {
        _passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passBtn setTitle:@"合格记录" forState:UIControlStateNormal];
        [_passBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _passBtn.titleLabel.font = FONT_SYS_NOR(14);
        [_passBtn addTarget:self action:@selector(passBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passBtn;
}

-(UIButton *)unpassBtn{
    if (!_unpassBtn) {
        _unpassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unpassBtn setTitle:@"不合格记录" forState:UIControlStateNormal];
        [_unpassBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        _unpassBtn.titleLabel.font = FONT_SYS_NOR(14);
        [_unpassBtn addTarget:self action:@selector(unpassBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unpassBtn;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0x0B457F);
        _line.layer.cornerRadius = 1;
        _line.clipsToBounds = YES;
    }
    return _line;
}

-(UIScrollView *)scro{
    if (!_scro) {
        _scro = [[UIScrollView alloc] init];
        _scro.backgroundColor = [UIColor clearColor];
        _scro.delegate = self;
        _scro.contentSize = CGSizeMake(SCREEN_WIDTH *2, 0);
    }
    return _scro;
}

-(SBAIPracticeRecordListViewController *)passvc{
    if (!_passvc) {
        _passvc = [[SBAIPracticeRecordListViewController alloc] init];
        _passvc.isPass = YES;
        _passvc.exerciseId = self.exerciseId;
        [self addChildViewController:_passvc];
    }
    return _passvc;
}

-(SBAIPracticeRecordListViewController *)unpassvc{
    if (!_unpassvc) {
        _unpassvc = [[SBAIPracticeRecordListViewController alloc] init];
        _unpassvc.isPass = NO;
        _unpassvc.exerciseId = self.exerciseId;
        [self addChildViewController:_unpassvc];
    }
    return _unpassvc;
}
@end
