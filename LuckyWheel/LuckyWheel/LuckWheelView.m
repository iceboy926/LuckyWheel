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
#define RADAR_ROTATE_SPEED 80.0

#import "LuckWheelView.h"
#import "PointerView.h"

@interface LuckWheelView()
{
    CGPoint  centerPoint;
}

@property (nonatomic, strong)UIButton *centerBtn;
@property (nonatomic, strong)NSMutableArray *titleLabelArray;


@end

@implementation LuckWheelView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    
    return self;
}


- (void)setupView
{
    centerPoint = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    
    [self addSubview:self.pointerVC];
    [self addSubview:self.centerBtn];
   
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(CenterBtnWidth, CenterBtnHeight));
        
    }];
}


#pragma mark lazy load

- (UIButton *)centerBtn
{
    if(_centerBtn == nil)
    {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _centerBtn.layer.cornerRadius = CenterBtnWidth/2.0;
        _centerBtn.layer.borderWidth = 1.0;
        _centerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _centerBtn.layer.masksToBounds = YES;
        [_centerBtn setBackgroundImage:[UIImage imageNamed:@"LuckyCenterButton"] forState:UIControlStateNormal];
        [_centerBtn setBackgroundImage:[UIImage imageNamed:@"LuckyCenterButtonPressed"] forState:UIControlStateHighlighted];
        
        [_centerBtn addTarget:self action:@selector(centerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _centerBtn;
}

- (PointerView *)pointerVC
{
    if(_pointerVC == nil)
    {
        
        _pointerVC = [[PointerView alloc] initWithFrame:CGRectMake(0, centerPoint.y - 10, self.bounds.size.width, 20) withLine:self.radius];
        
    }
    
    return _pointerVC;
}

- (NSMutableArray *)titleLabelArray
{
    if(_titleLabelArray == nil)
    {
        _titleLabelArray = [NSMutableArray array];
    }
    
    return _titleLabelArray;
}

#pragma mark Button-Action

- (void)centerBtnClicked:(UIButton *)sender
{
    [self startRoll];
}


-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y+y2);
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
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
        
        NSLog(@"startAngle is %f TitleCenterAngle is %f", startAngle, TitleCenterAngle);
    
        CGPoint TitleCenterPoint = [self calcCircleCoordinateWithCenter:centerPoint andWithAngle: TitleCenterAngle andWithRadius: radius - 20];//CenterRadiusPoint(centerPoint, TitleCenterAngle, radius - 15);
        
        NSLog(@"title center pos is [%f, %f ]", TitleCenterPoint.x, TitleCenterPoint.y);
        
        
        [self layoutTitleLabel:[arrayResult objectAtIndex:i] withCenter:TitleCenterPoint];

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

- (void)layoutTitleLabel:(NSString *)title withCenter:(CGPoint)centerPos
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
    titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:24.0];

    [self addSubview:titleLabel];
    
    [self bringSubviewToFront:titleLabel];
    
}

- (void)startRoll {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    BOOL indicatorClockwise = YES;

    rotationAnimation.toValue = [NSNumber numberWithFloat: (indicatorClockwise?1:-1) * M_PI * 2.0 ];
    rotationAnimation.duration = 360.f/RADAR_ROTATE_SPEED;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [self.pointerVC.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRoll {
    [self.pointerVC.layer removeAnimationForKey:@"rotationAnimation"];
}



@end
