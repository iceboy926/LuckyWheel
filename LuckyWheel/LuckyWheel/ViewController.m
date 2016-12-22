//
//  ViewController.m
//  LuckyWheel
//
//  Created by 金玉衡 on 16/12/22.
//  Copyright © 2016年 MDS. All rights reserved.
//

#import "ViewController.h"
#import "LuckWheelView.h"

@interface ViewController ()

@property (nonatomic, strong) LuckWheelView *luckWheelVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.luckWheelVC];
    
    //[self addUIConstriants];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (LuckWheelView *)luckWheelVC
{
    if(_luckWheelVC == nil)
    {
        _luckWheelVC = [[LuckWheelView alloc] initWithFrame:CGRectMake(0, (MAX(MAX_WIDTH,MAX_HEIGHT) - MIN(MAX_WIDTH, MAX_HEIGHT))/2.0, MIN(MAX_WIDTH, MAX_HEIGHT), MIN(MAX_WIDTH, MAX_HEIGHT))];
        _luckWheelVC.radius = MIN(MAX_WIDTH, MAX_HEIGHT)/2.0;
    }
    
    return _luckWheelVC;
}

- (void)addUIConstriants
{
    [self.luckWheelVC mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(MIN(MAX_WIDTH, MAX_HEIGHT), MIN(MAX_WIDTH, MAX_HEIGHT)));
        make.center.equalTo(self.view);
        
    }];
}

@end
