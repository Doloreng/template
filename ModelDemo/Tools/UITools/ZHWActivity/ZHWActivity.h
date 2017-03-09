//
//  QUYLActivity.h
//  turnImage
//  Created by shuzhenguo on 14-8-27.
//  Copyright (c) 2014年 shuzhenguo. All rights reserved.
//
/*
 
 1.如果全屏蔽，网络出现异常，界面卡死，审核被拒    (不覆盖状态栏)
 
*/
#import <UIKit/UIKit.h>

@interface ZHWActivity : UIButton
{
    BOOL animating;
    
    CGFloat  _animatingValue;
    
}
@property(nonatomic,strong)UIView *bgView;
@property (nonatomic) CGFloat animationDuration;
+(ZHWActivity *)getActivity;
/*
 
 需要缓冲图片qy_loading.png
*/

//初始化缓冲
/*
 参数介绍
 view           显示状态的view
 value          状态的速度，2为正常速度
 width          状态的width
 height          状态的height
 constraint     是否屏蔽屏幕点击
 
 */
-(void)startActivity:(UIView *)view  AnimatingValue:(CGFloat)value   bufferWidth:(CGFloat )width  bufferHeight:(CGFloat)height   activityConstraint:(BOOL)constraint;

//判断动画
- (BOOL)isAnimating;

//消失
- (void)stopAnimating;

//转动速度


@end
