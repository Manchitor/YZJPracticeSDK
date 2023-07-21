//
//  SBAIPracticeAnswerReviewCell.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/3.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeAnswerReviewCell.h"
#import "SBAIPractice.h"

@interface SBAIPracticeAnswerReviewCell ()
@property (nonatomic,strong) UILabel *sequenceLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UILabel *scoreLabel;

@end
@implementation SBAIPracticeAnswerReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupui];
    return self;
}

-(void)setupui{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.sequenceLabel];
    [self.sequenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sequenceLabel.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-100);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
}

-(void)setModel:(SBAIPracticeResultModel *)model index:(NSInteger)index{
    _model = model;
    self.sequenceLabel.text = @"1";
    self.contentLabel.text = model.question;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f",model.scoreTotal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ----------懒加载
-(UILabel *)sequenceLabel{
    if (!_sequenceLabel) {
        _sequenceLabel = [[UILabel alloc] init];
        _sequenceLabel.textColor = HEXCOLOR(0x52A0FF);
        _sequenceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
     }
    return _sequenceLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x333333);
        _contentLabel.font = FONT_SYS_NOR(14);
        _contentLabel.numberOfLines = 2;
     }
    return _contentLabel;
}

-(UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = HEXCOLOR(0x333333);
        _scoreLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
     }
    return _scoreLabel;
}
@end
