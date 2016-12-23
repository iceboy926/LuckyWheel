//
//  ViewController.m
//  LuckyWheel
//
//  Created by 金玉衡 on 16/12/22.
//  Copyright © 2016年 MDS. All rights reserved.
//

#define RADAR_ROTATE_SPEED 80.0
#define CenterBtnWidth 70
#define CenterBtnHeight CenterBtnWidth
#define ARC4RANDOM_MAX      0x100000000

#import "ViewController.h"
#import "LuckWheelView.h"

@interface ViewController ()

@property (nonatomic, strong) LuckWheelView *luckWheelVC;
@property (nonatomic, strong) PointerView *pointerVC;      //指针
@property (nonatomic, strong)UIButton *centerBtn;

@end

@implementation ViewController


- (BOOL)shouldAutorotate{ // 是否支持旋转
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{ // 支持旋转的方向

    return UIInterfaceOrientationMaskAll;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *bgImage = [UIImage imageNamed:@"radar_background"];
    
//    UIImage *outImage = [self imageFromImage:bgImage inRect:CGRectMake(0, MAX_HEIGHT/2, 40, 40)];
//    
//    UIImage *newImage =  [outImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    
    UIColor *bgColor = [UIColor colorWithPatternImage:bgImage];
    self.view.backgroundColor = bgColor;
    
    
    [self.view addSubview:self.luckWheelVC];
    [self.view addSubview:self.pointerVC];
    [self.view addSubview:self.centerBtn];
    
    
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(CenterBtnWidth, CenterBtnHeight));
        
    }];
    
    [self.luckWheelVC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(MIN(MAX_WIDTH, MAX_HEIGHT), MIN(MAX_WIDTH, MAX_HEIGHT)));
    }];
    
    [self.pointerVC mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(20, MIN(MAX_WIDTH, MAX_HEIGHT)));
    }];
    
    [self addRotationGesture];
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
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
        _luckWheelVC.luckyNumber = 18;
        _luckWheelVC.userInteractionEnabled = YES;
    }
    
    return _luckWheelVC;
}

- (PointerView *)pointerVC
{
    if(_pointerVC == nil)
    {
        CGFloat pointWidth = 20;
        CGFloat pointHeight = MIN(MAX_WIDTH, MAX_HEIGHT);
        CGFloat x = MIN(MAX_WIDTH, MAX_HEIGHT)/2.0 - pointWidth/2.0;
        CGFloat y = (MAX(MAX_WIDTH,MAX_HEIGHT) - MIN(MAX_WIDTH, MAX_HEIGHT))/2.0;
        
        _pointerVC = [[PointerView alloc] initWithFrame:CGRectMake(x, y, pointWidth, pointHeight) withLine:MIN(MAX_WIDTH, MAX_HEIGHT)/2.0];
        
    }
    
    return _pointerVC;
}

- (UIButton *)centerBtn
{
    if(_centerBtn == nil)
    {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _centerBtn.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        _centerBtn.layer.cornerRadius = CenterBtnWidth/2.0;
        //_centerBtn.layer.borderWidth = 0.0;
        //_centerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _centerBtn.layer.masksToBounds = YES;
        [_centerBtn setBackgroundImage:[UIImage imageNamed:@"cai"]forState:UIControlStateNormal];
        [_centerBtn setBackgroundImage:[UIImage imageNamed:@"cai"] forState:UIControlStateHighlighted];
        
        [_centerBtn addTarget:self action:@selector(centerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _centerBtn;
}

- (void)addRotationGesture
{
    UISwipeGestureRecognizer *swipergesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureTouched:)];
    
    swipergesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.luckWheelVC addGestureRecognizer:swipergesture];
    
    
    swipergesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureTouched:)];
    
    swipergesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.luckWheelVC addGestureRecognizer:swipergesture];
    
    
    swipergesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureTouched:)];
    
    swipergesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    [self.luckWheelVC addGestureRecognizer:swipergesture];
    
    
    swipergesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureTouched:)];
    
    swipergesture.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.luckWheelVC addGestureRecognizer:swipergesture];
    
}


- (void)rotationGestureTouched:(UISwipeGestureRecognizer *)swipergesture
{
    if(swipergesture.direction == UISwipeGestureRecognizerDirectionRight || swipergesture.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@" right ");
        
        [self startRollWithClockwise:YES];
    }
    else if(swipergesture.direction == UISwipeGestureRecognizerDirectionLeft || swipergesture.direction == UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@" left ");
        [self startRollWithClockwise:NO];
    }
    
}

- (void)centerBtnClicked:(UIButton *)sender
{
    
}

- (void)startRollWithClockwise:(BOOL)blClockwise {
    
    //float val = (((double)arc4random() / ARC4RANDOM_MAX) * 2.0);
    
    int randomInt = (arc4random()%8) + 8;
  
    float randomPI = (((double)arc4random() / ARC4RANDOM_MAX) * 2.0*M_PI);
    
    float randomDuration = ((((double)arc4random() / ARC4RANDOM_MAX) * 10.0f));
    while(randomDuration < 3.5 || randomDuration > 8.9)
    {
        randomDuration = (((double)arc4random() / ARC4RANDOM_MAX) * 10.0);
    }
    
    
    NSLog(@"randomPI is %f randomInt is %d randomDuration is %f", randomPI, randomInt, randomDuration);
    
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    

    rotationAnimation.toValue = [NSNumber numberWithFloat: (blClockwise?1:-1) *(randomInt *2.0*M_PI + randomPI )];
    rotationAnimation.duration = randomDuration;
    rotationAnimation.cumulative = YES;
    //rotationAnimation.repeatCount = INT_MAX;
    //rotationAnimation.repeatDuration = 5.0;
    
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.delegate = self;
    [self.luckWheelVC.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation start");
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)
    {
        NSLog(@"animation stop.....");
    }
}





@end
