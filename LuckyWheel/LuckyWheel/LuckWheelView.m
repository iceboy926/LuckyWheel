//
//  LuckWheelView.m
//  LuckyWheel
//
//  Created by 金玉衡 on 16/12/22.
//  Copyright © 2016年 MDS. All rights reserved.
//

#define CenterBtnWidth 80
#define CenterBtnHeight CenterBtnWidth

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)
#define ARC4RANDOM_MAX      0x100000000


#import "LuckWheelView.h"
#import "PointerView.h"

@interface LuckWheelView()
{
    CGPoint  centerPoint;
}

@property (nonatomic, strong)NSMutableArray *titleLabelArray;


@end

@implementation LuckWheelView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark lazy load


- (NSMutableArray *)titleLabelArray
{
    if(_titleLabelArray == nil)
    {
        _titleLabelArray = [NSMutableArray array];
    }
    
    return _titleLabelArray;
}

#pragma mark Button-Action



-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y+y2);
}

- (void)setLuckyNumber:(NSInteger)luckyNumber
{
    _luckyNumber = luckyNumber;
    
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    [self setNeedsDisplay];
}

- (void)resetLuckWheel
{
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    centerPoint = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat radius = 100;
    if (self.radius) {
        radius = self.radius;
    }
    

    //边框圆
    CGContextSetRGBStrokeColor(context, 1, 0, 1, 0.5);//画笔线的颜色(透明度渐变)
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, 2*M_PI, 0); //添加一个圆
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke); //绘制路径

    //绘制每个个扇形
    NSInteger luckyNum = 12;
    if(self.luckyNumber)
    {
        luckyNum = self.luckyNumber;
    }
    
    NSMutableArray *arrayNumber = [NSMutableArray array];
    
    for (int i = 1; i <= luckyNum; i++) {
        
        [arrayNumber addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSMutableArray *arrayResult = [self getRandomTitle:arrayNumber];

    // 圆的半径
    //CGFloat r = radius;
    
    // 转盘每一扇形的角度
    CGFloat angle = M_PI/180 * 360/luckyNum;
    
    CGFloat perAngle = 360.0/luckyNum;
    
    for (NSInteger i = 0; i < luckyNum; i++) {
        
        CGFloat startAngle, endAngle;
        
        
        float val = (((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
        
        CGFloat R = arc4random()%255, G = arc4random()%255, B = arc4random()%255, A = val - floor(val);
        
        CGFloat alphaColor = ((A > 0.5) ? A : (1.0 - A));
        
        
        startAngle = i *M_PI / 180 *perAngle;
        endAngle = (i+1)*M_PI/180 *perAngle;
        
        UIColor *aColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alphaColor];
        
        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, 0.5);//线的宽度
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);
        
        //以self.radius为半径围绕圆心画指定角度扇形
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius,  startAngle, endAngle, 0);
        
        CGContextClosePath(context);
    
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
        

        
        CGFloat  TitleCenterAngle = i*perAngle + perAngle/2.0;
        
        //NSLog(@"startAngle is %f TitleCenterAngle is %f", startAngle, TitleCenterAngle);
    
        CGPoint TitleCenterPoint = [self calcCircleCoordinateWithCenter:centerPoint andWithAngle: TitleCenterAngle andWithRadius: radius - 20];//CenterRadiusPoint(centerPoint, TitleCenterAngle, radius - 15);
        
        //NSLog(@"title center pos is [%f, %f ]", TitleCenterPoint.x, TitleCenterPoint.y);
        
        
        [self layoutTitleLabel:[arrayResult objectAtIndex:i] withCenter:TitleCenterPoint angle:(CGFloat)angle*i];

    }
    

    
}

- (NSMutableArray *)getRandomTitle:(NSMutableArray *)originDataArray
{
    NSInteger orignCount = [originDataArray count];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < orignCount; i++) {
    
        NSInteger left = originDataArray.count;
        NSInteger random = arc4random()%left;
        
        id object = [originDataArray objectAtIndex:random];
        
        [resultArray addObject:object];
        
        [originDataArray removeObjectAtIndex:random];
    }

    
    
    return resultArray;
}

- (void)layoutTitleLabel:(NSString *)title withCenter:(CGPoint)centerPos angle:(CGFloat)angle
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = centerPos;
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.masksToBounds = YES;

    
    CGFloat R = arc4random()%255, G = arc4random()%255, B = arc4random()%255;
    
    titleLabel.textColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:26.0];

    [self addSubview:titleLabel];
    
   

    
    // 设置锚点（以视图上的哪一点为旋转中心，（0，0）是左下角，（1，1）是右上角，（0.5，0.5）是中心）
   //titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
   //titleLabel.layer.position = CGPointMake(self.radius, self.radius);
    titleLabel.transform = CGAffineTransformMakeRotation(angle);
    
}




@end
