//
//  JYSpinView.m
//  UseZipZapDeme
//
//  Created by 改车吧 on 2017/1/4.
//  Copyright © 2017年 jianye. All rights reserved.
//

#import "JYSpinView.h"
#import <ZipZap.h>


@interface JYSpinView ()<UIGestureRecognizerDelegate>
{
    /**
     *  展示车部件的ImageView
     */
    UIImageView *_dipan;
    UIImageView *_body;

    //    UIImageView *_qianlian;
    //    UIImageView *_weibu;
    //    UIImageView *_cequn;
    //    UIImageView *_yeziban;
    //    UIImageView *_zhongwang;
    //    UIImageView *_inside;
    //    UIImageView *_mask;
    //    UIImageView *_shadow;
    //    UIImageView *_paidi;
    //    UIImageView *_taban;
    //    UIImageView *_paiqi;
    //    UIImageView *_qianchun;
    
    /**
     *  用来计算偏移增减量的几个变量
     */
    NSInteger _currentSpace;
    NSInteger _currentNumber;
    NSInteger _currentImageNuber;
    


}
@property (nonatomic, strong)   NSArray  *dipanArray;
@property (nonatomic, strong)   NSArray  *bodyArray;


@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) CGPoint   touchPoint;
@property (nonatomic, assign) NSInteger touchIndex;

@end

@implementation JYSpinView

- (instancetype)init{
    
    if (self = [super init]) {
        
        _panDistance = 20;
        _direction = MMSpinViewDirectionForward;

        
        _dipan = [[UIImageView alloc] initWithFrame:self.bounds];
        //_dipan.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //_dipan.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_dipan];
        
        _body = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_body];
        
        
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPan:)];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.maximumNumberOfTouches = 1;
        panGesture.delegate = self;
        panGesture.cancelsTouchesInView = NO;
        [self addGestureRecognizer:panGesture];
        
        
        [self loadImageArray:_bodyArray fromZip:@"/body_10002.zip"];

    }
    
    return self;
}

#pragma mark - zip文件读取数据
- (void)loadImageArray:(NSArray *)array fromZip:(NSString *)path {
    
    if (!path) return;
    
    __block NSArray *blockArray = array;
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        ZZArchive* oldArchive = [ZZArchive archiveWithURL:[NSURL fileURLWithPath:path] error:nil];

        NSMutableArray *mutArray = [NSMutableArray array];

        for ( ZZArchiveEntry *entry in oldArchive.entries )
        {
            //avoid the damn __MACOS problem on mac
            if ( [entry.fileName rangeOfString:@"/"].location != NSNotFound )
            {
                continue;
            }
            
            NSData *data = [entry newDataWithError:nil];
            
            UIImage * image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            
            [mutArray addObject:image];
        }

        dispatch_async (dispatch_get_main_queue (), ^{
            
            if ( !weakSelf )
            {
                return;
            }
            
            //weakSelf.dataSource = weakSelf;
            //weakSelf.imagesArray = mutArray;
            
            blockArray = mutArray;

        });

        
    });
    
}

#pragma mark - 滑动手势
- (void)actionPan:(UIPanGestureRecognizer*)gesture{
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.touchIndex = self.currentIndex;
            self.touchPoint = [gesture locationInView:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint pt = [gesture locationInView:self];
            
            double offset = pt.x - self.touchPoint.x;
            
            if ( self.direction == MMSpinViewDirectionBackward )
            {
                offset = -offset;
            }
            
            NSInteger index = (int)(((offset+self.panDistance/2.0f) + (1000*self.panDistance) )/ self.panDistance) - 1000 + self.touchIndex;
            
            if ( index != self.currentIndex )
            {
                self.currentIndex = (index + self.imageCount*1000) % self.imageCount;
                
                
                //                if ( [self.delegate respondsToSelector:@selector(spinImageView:didSpinToIndex:)] )
                //                {
                //                    [self.delegate spinImageView:self didSpinToIndex:index];
                //                }
            }
            
            break;
        }
    
        default:
            break;
    }

}

//平移手势处理方法
- (void) handlePan:(UIPanGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        _currentNumber = 0;
        _currentSpace = 0;
        return;
    }
    CGPoint translation = [recognizer translationInView:self];
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
    //[self setCarImage:_currentImageNuber];
    NSLog(@"左移");
}
//右移手势
- (void)rightMove{
    _currentImageNuber --;
    if (_currentImageNuber < 0) {
        _currentImageNuber = 23;
    }
    //[self setCarImage:_currentImageNuber];
    NSLog(@"右移");
}




@end









