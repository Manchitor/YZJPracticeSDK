//
//  SBAIPracticeBubleItem.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/6.
//

#import "SBAIPracticeBubleItem.h"

#import "SBAIPractice.h"

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RandomColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface SBAIPracticeBubleItem ()
//表情
@property (nonatomic,copy) NSString *emoji;

@property (nonatomic,strong) UIImageView *emojiImgView;

@property (nonatomic,strong) UILabel *emojiLabel;

@end

@implementation SBAIPracticeBubleItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupconfig];
        [self setupui];

    }
    return self;
}

-(void)setupEmoji:(NSString *)emoji speed:(CGFloat)speed transverse:(BOOL)transverse longitudinal:(BOOL)longitudinal{
    
    self.emoji = emoji;
    self.speed = speed;
    self.transverse = transverse;
    self.longitudinal = longitudinal;
    
    self.emojiImgView.image = [UIImage sb_imageNamedFromMyBundle:emoji];
    
    //    NSArray *array = @[@"sb_ai_emoji_dz",@"sb_ai_emoji_jz",@"sb_ai_emoji_sq",@"sb_ai_emoji_qq",@"sb_ai_emoji_lm",@"sb_ai_emoji_pd",@"sb_ai_emoji_xx"];

    if ([emoji isEqualToString:@"sb_ai_emoji_dz"]) {
        self.emojiLabel.text = @"端庄";
        self.emojiLabel.textColor = HEXCOLORA(0xFF837A, 1);
        self.emojiLabel.layer.borderColor = HEXCOLORA(0xFF837A, 1).CGColor;
    }else if ([emoji isEqualToString:@"sb_ai_emoji_sq"]) {
        self.emojiLabel.text = @"生气";
        self.emojiLabel.textColor = HEXCOLORA(0x00C4C4, 1);
        self.emojiLabel.layer.borderColor = HEXCOLORA(0x00C4C4, 1).CGColor;
    }else if ([emoji isEqualToString:@"sb_ai_emoji_jz"]) {
        self.emojiLabel.text = @"紧张";
        self.emojiLabel.textColor = HEXCOLORA(0x4F7BD3, 1);
        self.emojiLabel.layer.borderColor = HEXCOLORA(0x4F7BD3, 1).CGColor;
    }else if ([emoji isEqualToString:@"sb_ai_emoji_qq"]) {
        self.emojiLabel.text = @"亲切";
        self.emojiLabel.textColor = HEXCOLORA(0xFFB20E, 1);
        self.emojiLabel.layer.borderColor = HEXCOLORA(0xFFB20E, 1).CGColor;
    }else if ([emoji isEqualToString:@"sb_ai_emoji_pd"]) {
        self.emojiLabel.text = @"平淡";
        self.emojiLabel.textColor = HEXCOLORA(0x51CEFF, 1);
        self.emojiLabel.layer.borderColor = HEXCOLORA(0x51CEFF, 1).CGColor;
    }else if ([emoji isEqualToString:@"sb_ai_emoji_xx"]) {
        self.emojiLabel.text = @"信心";
        self.emojiLabel.textColor = HEXCOLORA(0xFF7A0E, 1);
        self.emojiLabel.layer.borderColor = HEXCOLORA(0xFF7A0E, 1).CGColor;
    }else if ([emoji isEqualToString:@"sb_ai_emoji_lm"]) {
        self.emojiLabel.text = @"冷漠";
        self.emojiLabel.textColor = HEXCOLORA(0x51A6FF, 1);
        self.emojiLabel.layer.borderColor = HEXCOLORA(0x51A6FF, 1).CGColor;
    }
    
        
}

#pragma mark ------ UI
-(void)setupui{
    self.backgroundColor = [UIColor clearColor];

    self.emojiImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    [self addSubview:self.emojiImgView];
    
    self.emojiLabel.frame = CGRectMake((self.frame.size.width - 40)/2.0, self.frame.size.height - 6 - 18, 40, 18);
    [self addSubview:self.emojiLabel];
}

-(void)setupconfig{
    //背景色
//    self.backgroundColor = RandomColor;
    
    //速度 按最长 10s走完
    self.speed = (SCREEN_WIDTH - 30) /10.0;
    
    //横向 正反方向
    self.transverse = (arc4random()%2 == 1);
    //纵向 正反方向
    self.longitudinal = (arc4random()%2 == 1);
    
}

#pragma mark ----------懒加载
-(UIImageView *)emojiImgView{
    if (!_emojiImgView) {
        _emojiImgView = [[UIImageView alloc] init];
        _emojiImgView.contentMode = UIViewContentModeScaleAspectFill;
        //default value
    }
    return _emojiImgView;
}

-(UILabel *)emojiLabel{
    if (!_emojiLabel) {
        _emojiLabel = [[UILabel alloc] init];
        _emojiLabel.font = [UIFont systemFontOfSize:12];
        _emojiLabel.layer.cornerRadius = 9;
        _emojiLabel.layer.borderWidth = 1;
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        _emojiLabel.backgroundColor = [UIColor whiteColor];
        _emojiLabel.clipsToBounds = YES;
        //default value
        _emojiLabel.textColor = HEXCOLORA(0xFF837A, 1);
        _emojiLabel.layer.borderColor = HEXCOLORA(0xFF837A, 1).CGColor;

    }
    return _emojiLabel;
}
@end
