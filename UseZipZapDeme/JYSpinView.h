//
//  JYSpinView.h
//  UseZipZapDeme
//
//  Created by 改车吧 on 2017/1/4.
//  Copyright © 2017年 jianye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MMSpinViewDirection) {
    MMSpinViewDirectionForward,
    MMSpinViewDirectionBackward,
    MMSpinViewDirectionMax = 999
};



@interface JYSpinView : UIView


@property (nonatomic, assign)   NSInteger currentIndex;
@property (nonatomic, assign)   double panDistance;

@property (nonatomic, assign) MMSpinViewDirection direction;

@end
