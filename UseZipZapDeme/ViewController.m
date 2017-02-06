//
//  ViewController.m
//  UseZipZapDeme
//
//  Created by 改车吧 on 2017/1/4.
//  Copyright © 2017年 jianye. All rights reserved.
//

#import "ViewController.h"
#import <ZipZap.h>
#import "GarageVC.h"
@interface ViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(60, 500, 100, 30);
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitle:@"读取" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    presentBtn.frame = CGRectMake(260, 500, 100, 30);
    [presentBtn setBackgroundColor:[UIColor orangeColor]];
    [presentBtn setTitle:@"present" forState:UIControlStateNormal];
    [presentBtn addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentBtn];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 333.33, 149)];
    imgView.backgroundColor = [UIColor colorWithRed:199/255.0 green:234/255.0 blue:240/255.0 alpha:1];
    _imageView = imgView;
    [self.view addSubview:imgView];
}

- (void)buttonClick{
    
    __weak typeof(self) weakSelf = self;
    
    //开辟异步线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path = [[NSBundle mainBundle].resourcePath stringByAppendingString:@"/car.zip"];
        
        ZZArchive *archive = [ZZArchive archiveWithURL:[NSURL fileURLWithPath:path] error:nil];
        
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (ZZArchiveEntry *archiveEntry  in archive.entries) {
            
            
            //if ( [archiveEntry.fileName rangeOfString:@"/"].location != NSNotFound )
            //{
            //    continue;
            //}
            
            NSData *data = [archiveEntry newDataWithError:nil];
            
            UIImage * image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            
            [array addObject:image];
            
            
        }
        
        //获取主线程
        dispatch_async (dispatch_get_main_queue (), ^{
            
            if ( !weakSelf )
            {
                return;
            }
            
            weakSelf.dataArray = array;
            
            [weakSelf loadImageFromZip];
            
        });
        
    });
    
}

- (void)nextView{
    
    GarageVC *nextVC = [[GarageVC alloc] init];
    
    [self presentViewController:nextVC animated:YES completion:^{
        
    }];
    
}

- (void)loadImageFromZip{
    
    if (!_dataArray.count) return;
    
    self.imageView.image = [self.dataArray lastObject];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end






