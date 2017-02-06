//
//  GarageVC.m
//  UseZipZapDeme
//
//  Created by 改车吧 on 2017/1/4.
//  Copyright © 2017年 jianye. All rights reserved.
//

#import "GarageVC.h"
#import "MMSpinImageView.h"
#import <Masonry.h>
@interface GarageVC ()<MMSpinImageViewDelegate>
{
    /**
     *  用来展示的主View
     *  表示当前车辆的Str (当前为 bc_ 或 BMW5_) 实体文件夹名字一样
     */
    UIView      *_carView;
    NSString    *_typeStr;
    /**
     *  展示车部件的ImageView
     */
    MMSpinImageView *_dipan;
    MMSpinImageView *_qianlian;
    MMSpinImageView *_weibu;
    MMSpinImageView *_cequn;
    MMSpinImageView *_yeziban;
    MMSpinImageView *_zhongwang;
    MMSpinImageView *_body;
    MMSpinImageView *_inside;
    MMSpinImageView *_mask;
    MMSpinImageView *_shadow;
    MMSpinImageView *_paidi;
    MMSpinImageView *_taban;
    MMSpinImageView *_paiqi;
    MMSpinImageView *_qianchun;
    /**
     *  用来计算偏移增减量的几个变量
     */
    NSInteger _currentSpace;
    NSInteger _currentNumber;
    NSInteger _currentImageNuber;

}
@end


static NSString *kDipan = @"dipan";
static NSString *kQianlian = @"qianlian";
static NSString *kWeibu = @"weibu";
static NSString *kCequn = @"cequn";
static NSString *kYeziban = @"yeziban";
static NSString *kZhongwang = @"zhongwang";
static NSString *kPaiqi = @"paiqi";
static NSString *kBody = @"body";
static NSString *kInside = @"inside";
static NSString *kMask = @"mask";
static NSString *kShadow = @"shadow";
static NSString *kQianchun = @"qianchun";
static NSString *kPaidi = @"paidi";
static NSString *kTaban = @"taban";

@implementation GarageVC
- (id)init{
    
    if (self = [super init]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //滑动手势
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
//    [self.view addGestureRecognizer:panGestureRecognizer];//添加平移手势
    
    //    放置车辆图片的View
    _carView = [[UIView alloc] init];
    [self.view addSubview:_carView];
    [_carView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(-20);
        make.width.mas_equalTo(623);
        make.height.mas_equalTo(350);
    }];
    
    _dipan = [[MMSpinImageView alloc] initWithFrame:CGRectMake(0, 0, 600, 340)];
    _dipan.delegate = self;
    [_carView addSubview:_dipan];
    
    _body = [[MMSpinImageView alloc] initWithFrame:CGRectMake(0, 0, 600, 340)];
    _body.delegate = self;
    [_carView addSubview:_body];

    
    
    [self actionFile];
    
    
    

}
//平移手势处理方法
- (void) handlePan:(UIPanGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        _currentNumber = 0;
        _currentSpace = 0;
        return;
    }
    CGPoint translation = [recognizer translationInView:self.view];
    if(translation.x < 20.f && translation.x > -20.f) return;
    NSInteger number = translation.x / 20.f;
    if (_currentNumber == number) return;
    _currentNumber = number;
    // NSLog(@"当前数字---------------  %ld,_currentSpace %ld",_currentNumber,_currentSpace);
    _currentSpace = _currentNumber - _currentSpace;//  bug!
    // NSLog(@"_currentSpace增减量 %ld",_currentSpace);
    if (_currentSpace < 0) {
        [self leftMove];
    }else{
        [self rightMove];
    }
    _currentSpace = _currentNumber;
    
}
//左移手势
- (void)leftMove{
    _currentImageNuber ++;
    if (_currentImageNuber > 23) {
        _currentImageNuber = 0;
    }
    
    
    //[self spinImageView:_body didSpinToIndex:_currentImageNuber];

}
//右移手势
- (void)rightMove{
    _currentImageNuber --;
    if (_currentImageNuber < 0) {
        _currentImageNuber = 23;
    }
    //[self spinImageView:_body didSpinToIndex:_currentImageNuber];
    
}

- (void) actionFile
{
    [_dipan loadDataFromZip:[[NSBundle mainBundle].resourcePath stringByAppendingString:@"/car.zip"]];
    [_body loadDataFromZip:[[NSBundle mainBundle].resourcePath stringByAppendingString:@"/body_10002.zip"]];
    
}
//- (void)spinImageView:(MMSpinImageView *)view didSpinToIndex:(NSInteger)index{
//    [view.delegate spinImageView:view didSpinToIndex:index];
//}

- (void)spinImageView:(MMSpinImageView *)view didSelectAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
