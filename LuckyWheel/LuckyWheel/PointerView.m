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
        
        CGRect newFrame = self.frame;
    
        
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
    CGRect dialRect = self.bounds;
    
    CGFloat layerWidth = CGRectGetWidth(dialRect);
    CGFloat layerHeight = CGRectGetHeight(dialRect);
    CGFloat tailwidth = layerWidth/5.0;

    
    _pointerLayer = [self p_handLayerWithWidth:layerWidth height:layerHeight tailWidth:(CGFloat)tailwidth];
    
    [self.layer addSublayer:_pointerLayer];
    
}


- (CAShapeLayer *) p_handLayerWithWidth:(CGFloat)width height:(CGFloat)height tailWidth:(CGFloat)tailwidth{
    CGPoint dialCenter = CGPointMake(width / 2.0, height / 2.0);
    
    CGFloat layerWidth = width;
    CGFloat layerHeight = height;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGPoint addingPoint, controlPoint1, controlPoint2;
    addingPoint = CGPointMake(dialCenter.x - layerWidth/2.0, dialCenter.y); // 左上顶点
    [bezierPath moveToPoint:addingPoint];
    
    
    
    CGPoint rightTopPoint = CGPointMake(dialCenter.x + layerWidth/2.0 - tailwidth, dialCenter.y - layerHeight / 2.0); // 右上顶点
    [bezierPath addLineToPoint:rightTopPoint];
    
//    controlPoint1 = CGPointMake(dialCenter.x  - layerHeight * 3.0 / 4.0 - tailLength,dialCenter.y  - layerHeight / 2.0); // 最左端圆弧控制点 1
//    controlPoint2 = CGPointMake(dialCenter.x  - layerHeight * 3.0 / 4.0 - tailLength,dialCenter.y  + layerHeight / 2.0); // 最左端圆弧控制点 2
    
    CGPoint rightTailPoint = CGPointMake(dialCenter.x + layerWidth/2.0, dialCenter.y);
    
    [bezierPath addLineToPoint:rightTailPoint];
    
    //[bezierPath addCurveToPoint:addingPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    CGPoint rightBottomPoint = CGPointMake(dialCenter.x + layerWidth/2.0 - tailwidth, dialCenter.y + layerHeight / 2.0); // 右下顶点
    
    [bezierPath addLineToPoint:rightBottomPoint];

    
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = self.bounds;
    
    shapeLayer.fillColor = [UIColor greenColor].CGColor;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    
    return shapeLayer;
}



@end
