//
//  LuckWheelView.h
//  LuckyWheel
//
//  Created by 金玉衡 on 16/12/22.
//  Copyright © 2016年 MDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointerView.h"

@interface LuckWheelView : UIView

@property (nonatomic, assign) CGFloat radius;           //半径
@property (nonatomic, assign) BOOL indicatorClockwise;           //是否顺时针
@property (nonatomic, strong) UIView *pointsView;       //目标点视图
@property (nonatomic, strong) PointerView *pointerVC;      //指针
@property (nonatomic, assign) NSInteger  luckyNumber;



@end
