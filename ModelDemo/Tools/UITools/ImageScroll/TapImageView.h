//
//  TapImageView.h
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapImageViewDelegate <NSObject>

- (void) tappedWithObject:(id) sender;

@end

@interface TapImageView : UIImageView

@property (nonatomic, strong) id identifier;
@property (nonatomic, assign) NSInteger type;
//初始化
-(void)initWithTap;
@property (weak) id<TapImageViewDelegate> t_delegate;

@end
