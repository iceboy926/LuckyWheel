//
//  PointerView.m
//  LuckyWheel
//
//  Created by 金玉衡 on 16/12/22.
//  Copyright © 2016年 MDS. All rights reserved.
//

#import "PointerView.h"

@interface PointerView()

@property (nonatomic, assign)CGFloat pointerLength;
@property (nonatomic, strong)CAShapeLayer *pointerLayer;

@end
@implementation PointerView

- (instancetype)initWithFrame:(CGRect)frame withLine:(CGFloat)length
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.pointerLength = length;
        
//        self.frame = newFrame;
//        
//        self.layer.anchorPoint = CGPointMake(0.5, 0);
//        
//        self.layer.position = CGPointMake(self.layer.position.x+(0.5-0.5)*self.frame.size.width, self.layer.position.y+(0-0.5)*self.frame.size.height);

        
        [self setup];
    
    }
    return self;
}


- (void)setup
{
    CGRect dialRect = self.frame;
    
    CGFloat layerWidth = CGRectGetWidth(dialRect);
    CGFloat layerHeight = CGRectGetHeight(dialRect);
    CGFloat tailheight = layerHeight/8.0;

    
    _pointerLayer = [self p_handLayerWithWidth:layerWidth height:layerHeight tailHeight:(CGFloat)tailheight];
    
    [self.layer addSublayer:_pointerLayer];
    
}


- (CAShapeLayer *) p_handLayerWithWidth:(CGFloat)width height:(CGFloat)height tailHeight:(CGFloat)tailheight{
    CGPoint dialCenter = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);//CGPointMake(width / 2.0, height / 2.0);
    
    NSLog(@"dialCenter is [%f, %f]", dialCenter.x, dialCenter.y);
    CGFloat pointWidth = width/2.0;
    CGFloat pointHeight = height/2.0 - 25;
    
    NSLog(@"pointWidth pointHeight is [%f, %f]", pointWidth, pointHeight);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGPoint addingPoint, controlPoint1, controlPoint2;
    addingPoint = CGPointMake(dialCenter.x, dialCenter.y); // 左上顶点
    [bezierPath moveToPoint:addingPoint];
    
    
    
    CGPoint leftTopPoint = CGPointMake(dialCenter.x - pointWidth/2.0, dialCenter.y - pointHeight + tailheight);
    
    //CGPointMake(dialCenter.x + pointWidth - tailwidth, dialCenter.y - pointHeight / 2.0); // 左上顶点
    [bezierPath addLineToPoint:leftTopPoint];
    
//    controlPoint1 = CGPointMake(dialCenter.x  - layerHeight * 3.0 / 4.0 - tailLength,dialCenter.y  - layerHeight / 2.0); // 最左端圆弧控制点 1
//    controlPoint2 = CGPointMake(dialCenter.x  - layerHeight * 3.0 / 4.0 - tailLength,dialCenter.y  + layerHeight / 2.0); // 最左端圆弧控制点 2
    
    CGPoint leftTailPoint = CGPointMake(dialCenter.x, dialCenter.y - pointHeight);
    
    [bezierPath addLineToPoint:leftTailPoint];
    
    //[bezierPath addCurveToPoint:addingPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    CGPoint rightTopPoint = CGPointMake(dialCenter.x + pointWidth/2.0, dialCenter.y - pointHeight + tailheight); // 右下顶点
    
    [bezierPath addLineToPoint:rightTopPoint];

    
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = self.bounds;
    
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    return shapeLayer;
}



@end
