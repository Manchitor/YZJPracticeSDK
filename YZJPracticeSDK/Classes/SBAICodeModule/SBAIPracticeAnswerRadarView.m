//
//  SBAIPracticeAnswerRadarView.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/10.
//

#import "SBAIPracticeAnswerRadarView.h"
#import "SBAIPractice.h"

#define P_M(x,y) CGPointMake(x, y)

@interface SBAIPracticeAnswerRadarView ()
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *valueArray;

@end
@implementation SBAIPracticeAnswerRadarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setModel:(SBAIPracticeAnalyzeModel *)model{
    _model = model;
    [self.valueArray removeAllObjects];

    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scorePolite]];
    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scoreHitrate]];
    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scoreCorrect]];
    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scoreComplete]];
    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scoreCoherence]];
    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scoreLogic]];
    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scoreCater]];
    [self.valueArray addObject:[NSString stringWithFormat:@"%d",model.scorePositive]];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (!self.valueArray.count){
        NSLog(@"无数据");
        return;
    }
    //画虚线的
    CGFloat dashPattern[] = {2,1};// 实线长为2，空白为1
    
    CGFloat lineWidth = 0.5;
    
    //半径
    CGFloat radius = self.frame.size.width/2.0;
    
    //圆环个数
    int count = 5;
    
    //圆环间距
    int margin = 30;
    
    //区域是否绘制曲线边线
    BOOL isCurve = NO;
    
    //1.绘制圆环
    for (int i = 0; i<count; i++) {
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(i*margin, i*margin, self.frame.size.width-(i*(margin *2)), self.frame.size.width-(i*(margin *2)))];
//        [path setLineDash:dashPattern count:1 phase:1];//虚线
        path.lineWidth = lineWidth;
        [HEXCOLOR(0xE1E9F1) set];
        path.lineCapStyle = kCGLineCapRound; //线条拐角
        path.lineJoinStyle = kCGLineJoinRound; //终点处理
        [path stroke];
    }
    
    //2.绘制穿插线（从圆心到最大圆斜线）
    for (int i = 0; i<self.valueArray.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(radius,radius)];
        CGPoint point = [self calcCircleCoordinateWithCenter:CGPointMake(radius,radius) andWithAngle:i*(360/self.valueArray.count) andWithRadius:radius];
        [path addLineToPoint:point];
        [path setLineWidth:lineWidth];
//        [path setLineDash:dashPattern count:1 phase:1];//虚线
        [HEXCOLOR(0xE1E9F1) setStroke];
        [path stroke];
    }
    
    //value array里面的最大值
    float maxValue = [[self.valueArray valueForKeyPath:@"@max.intValue"] floatValue];
    if (maxValue == 0) {
        NSLog(@"数据最大值为0，无比例可计算");
    }
    //3.获取数据源的每项point
    NSMutableArray *pointArray = [[NSMutableArray alloc] init];
    NSMutableArray *itemPointArray = [[NSMutableArray alloc] init];

    for (int index = 0; index < self.valueArray.count; index++) {
        //data point
        CGFloat a ;
        if (maxValue == 0){
            a =  0;
        }else{
            a =  [self.valueArray[index] floatValue]/maxValue * radius;
        }
        CGPoint point = [self calcCircleCoordinateWithCenter:CGPointMake(radius, radius) andWithAngle:index*(360/self.valueArray.count) andWithRadius:a];
        NSValue *value = [NSValue valueWithCGPoint:point];
        [pointArray addObject:value];
        
        //item point
        CGPoint itemPoint = [self calcCircleCoordinateWithCenter:CGPointMake(radius, radius) andWithAngle:index*(360/self.valueArray.count) andWithRadius:radius];
        NSValue *valuePoint = [NSValue valueWithCGPoint:itemPoint];
        [itemPointArray addObject:valuePoint];
    }
    
    //4.绘制图层
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    for (int index = 0; index < pointArray.count; index++) {
        
        CGPoint point = [pointArray[index] CGPointValue];

        if (index == 0) {
            [path moveToPoint:[pointArray[index] CGPointValue]];
        }else{
            //画曲线 找出控制点
            if (isCurve) {
                CGPoint nextP = [pointArray[index-1] CGPointValue];
                
                CGPoint control1 = P_M(point.x + (nextP.x - point.x) / 2.0, nextP.y);
                CGPoint control2 = P_M(point.x + (nextP.x - point.x) / 2.0, point.y);
                
                [path addCurveToPoint:point controlPoint1:control1 controlPoint2:control2];
            }
        }
        
        [path addLineToPoint:point];
        
        //5.绘制各每项数据顶点小圆点
        UIView *doi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        doi.backgroundColor = HEXCOLOR(0x7B87D9);
        doi.layer.masksToBounds = YES;
        doi.layer.cornerRadius = 5/2.0;
        doi.center = point;
        [self addSubview:doi];
    }
    [[HEXCOLOR(0xA0ADFF) colorWithAlphaComponent:0.6] setFill];//区域颜色
    [path fill];
    
    //6.绘制边框折线
    UIBezierPath* brokenpath = [UIBezierPath bezierPath];
    brokenpath.lineWidth = 1.0;
    brokenpath.lineCapStyle = kCGLineCapRound; //线条拐角
    brokenpath.lineJoinStyle = kCGLineJoinRound; //终点处理
    for (int index = 0; index < pointArray.count; index++) {
        
        CGPoint point = [pointArray[index] CGPointValue];

        if (index == 0) {
            [brokenpath moveToPoint:point];
        }else{
            [brokenpath addLineToPoint:point];
        }
    }
    [brokenpath addLineToPoint:[pointArray[0] CGPointValue]];//闭合
    [HEXCOLOR(0x7B87D9) setStroke];
    [brokenpath stroke];
    
    
    //7.绘制每项的标题
    for (int index = 0; index < itemPointArray.count; index++) {
        
        CGPoint p = [itemPointArray[index] CGPointValue];
        CGFloat width = [self sb_string_max_size:[UIFont systemFontOfSize:12] text:self.titleArray[index] maxWidth:MAXFLOAT].width;
        UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        item.text = self.titleArray[index];
        item.font = [UIFont systemFontOfSize:12];
        item.textColor = HEXCOLOR(0x666666);
        CGFloat angle = index*(360/self.valueArray.count);//角度
        
        if (angle == 0) {
            item.center = CGPointMake(p.x + width/2.0, p.y);
        }else if (angle < 90){
            item.center = CGPointMake(p.x + width/2.0, p.y - 10);
        }else if (angle == 90){
            item.center = CGPointMake(p.x , p.y-10);
        }else if (angle < 180){
            item.center = CGPointMake(p.x - width/2.0, p.y - 10);
        }else if (angle == 180){
            item.center = CGPointMake(p.x - width/2.0 , p.y);
        }else if (angle < 270){
            item.center = CGPointMake(p.x - width/2.0 , p.y + 10);
        }else if (angle == 270){
            item.center = CGPointMake(p.x , p.y+10);
        }else if (angle > 270){
            item.center = CGPointMake(p.x + width/2.0 , p.y + 10);
        }
        
        [self addSubview:item];
    }
    
}

#pragma mark 计算圆圈上点在IOS系统中的坐标
-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

- (CGSize)sb_string_max_size:(UIFont *)font text:(NSString *)text maxWidth:(CGFloat)maxWidth {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attribute
                                     context:nil];
    return rect.size;
}


-(NSMutableArray *)titleArray{
    if (!_titleArray){
        _titleArray = [NSMutableArray arrayWithArray:@[@"礼貌用语",@"关键词命中率",@"表述准确",@"内容完整",@"语言连贯",@"语言逻辑",@"语言亲和",@"积极态度"]];
    }
    return _titleArray;
}

-(NSMutableArray *)valueArray{
    if (!_valueArray){
        _valueArray = [[NSMutableArray alloc] init];
    }
    return _valueArray;
}
@end
