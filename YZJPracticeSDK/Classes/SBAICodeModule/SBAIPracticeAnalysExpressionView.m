//
//  SBAIPracticeAnalysExpressionView.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/3.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeAnalysExpressionView.h"
#import "SBAIPracticeExpressionRadarView.h"
#import "SBAIPractice.h"
#import "SBAIPracticeBubleItem.h"

@interface SBAIPracticeAnalysExpressionView ()
@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *content;

@property (nonatomic,strong) SBAIPracticeExpressionRadarView *radar;
@property (nonatomic,strong) UIView *expressionContent;

@property (nonatomic,strong) NSMutableArray<SBAIPracticeBubleItem *> *itemArray;

@end

@implementation SBAIPracticeAnalysExpressionView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupui];
    }
    return self;
}

-(void)setModel:(SBAIPracticeAnalyzeModel *)model{
    _model = model;
    self.radar.model = model;
    
    [self setItemData];
}

-(void)setupui{
    [self addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    
    [self.bg addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.top.equalTo(self.bg.mas_top).offset(15);
    }];
    
    [self.bg addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.width.height.mas_equalTo(197);
        make.centerX.equalTo(self.bg);
    }];
    
    self.radar = [[SBAIPracticeExpressionRadarView alloc] initWithFrame:CGRectMake(0, 0, 197, 197)];
    [self.content addSubview:self.radar];
    
    [self.bg addSubview:self.expressionContent];
    [self.expressionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bg);
        make.top.equalTo(self.content.mas_bottom).offset(30);
        make.height.mas_equalTo(160);
    }];
}
#pragma mark ----------气泡数据
-(void)setItemData{
    
    NSArray *array = @[@"sb_ai_emoji_dz",@"sb_ai_emoji_jz",@"sb_ai_emoji_sq",@"sb_ai_emoji_qq",@"sb_ai_emoji_lm",@"sb_ai_emoji_pd",@"sb_ai_emoji_xx"];
    for (int index = 0; index < array.count; index++) {
        //随机宽高 40~70
        int w = arc4random()%30 + 40;
        int h = w + 12;

        //随机x SCREEN_WIDTH - 30  - w
        int x = arc4random()%((int)SCREEN_WIDTH - 30 - w);
        //随机y 150  - h
        int y = arc4random()%(150 - h);
        
        SBAIPracticeBubleItem *item = [[SBAIPracticeBubleItem alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [item setupEmoji:array[index] speed:(SCREEN_WIDTH - 30)/10.0 transverse:(arc4random()%2 == 1) longitudinal:(arc4random()%2 == 1)];
        
        [self.itemArray addObject:item];
        
        [self.expressionContent addSubview:item];

    }
}

-(void)startAnimation{
    for (SBAIPracticeBubleItem *item in self.itemArray) {
        [self startA:item];
        [self startB:item];
    }
}

-(void)startA:(SBAIPracticeBubleItem *)item{

    if (self.isfinish) {
        return;
    }
    NSLog(@"startA");
    //速度计算
    CGFloat sppe = item.speed;
    
    //x 将要移动的距离右边
//    int Xr = arc4random()%(int)(SCREEN_WIDTH-30 - item.frame.origin.x - item.frame.size.width);
//    int Xl = arc4random()%(int)(item.frame.origin.x);
    
    int Xr = (SCREEN_WIDTH-60 - item.frame.origin.x - item.frame.size.width);
    int Xl = (item.frame.origin.x);

    //随机此次移动方向 transverse
    
    //方向临界值判断 10
    if (Xl<10) {
        item.transverse = YES;
    }
    if (Xr<10) {
        item.transverse = NO;
    }
    
    //动画时间计算
    CGFloat time = 0;
    if (!item.transverse) {
        time = Xl/sppe;
    }else{
        time = Xr/sppe;
    }
    
    [UIView animateWithDuration: time  animations:^{
        if (!item.transverse) {
            item.frame = CGRectMake(item.frame.origin.x - Xl, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
        }else{
            item.frame = CGRectMake(item.frame.origin.x + Xr, item.frame.origin.y,item.frame.size.width, item.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self startA:item];
    }];
}

-(void)startB:(SBAIPracticeBubleItem *)item{

    if (self.isfinish) {
        return;
    }
    NSLog(@"startB");

    //速度计算
    CGFloat sppe = item.speed;
    
    
    //x 将要移动的距离右边
//    int Xr = arc4random()%(int)(200 - self.item.frame.origin.y - 40);
//    int Xl = arc4random()%(int)(self.item.frame.origin.y);
    int Xr = (160 - item.frame.origin.y - item.frame.size.height);
    int Xl = (item.frame.origin.y);

    //随机此次移动方向 transverse
    
    //方向临界值判断 10
    if (Xl<10) {
        item.longitudinal = YES;
    }
    if (Xr<10) {
        item.longitudinal = NO;
    }
    
    //动画时间计算
    CGFloat time = 0;
    if (!item.longitudinal) {
        time = Xl/sppe;
    }else{
        time = Xr/sppe;
    }
    
    [UIView animateWithDuration: time  animations:^{
        if (!item.longitudinal){
            item.frame = CGRectMake(item.frame.origin.x, item.frame.origin.y - Xl, item.frame.size.width, item.frame.size.height);
        }else{
            item.frame = CGRectMake(item.frame.origin.x, item.frame.origin.y + Xr, item.frame.size.width, item.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self startB:item];
    }];
}

#pragma mark ----------懒加载
-(UIView *)bg{
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = [UIColor whiteColor];
        _bg.layer.cornerRadius = 5;
        _bg.clipsToBounds = YES;
    }
    return _bg;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = FONT_SYS_MEDIUM(15);
        _titleLabel.text = @"表情分析";
    }
    return _titleLabel;
}

-(UIView *)content{
    if (!_content) {
        _content = [[UIView alloc] init];
        _content.backgroundColor = [UIColor whiteColor];
    }
    return _content;
}

-(UIView *)expressionContent{
    if (!_expressionContent) {
        _expressionContent = [[UIView alloc] init];
        _expressionContent.backgroundColor = [UIColor clearColor];
    }
    return _expressionContent;
}

-(NSMutableArray<SBAIPracticeBubleItem *> *)itemArray{
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

@end
