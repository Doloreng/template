//
//  QUYLActivity.m
//  turnImage
//  Created by shuzhenguo on 14-8-27.
//  Copyright (c) 2014年 shuzhenguo. All rights reserved.
//
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

#import "ZHWActivity.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZHWActivity

static ZHWActivity *activity=nil;


+(ZHWActivity*)getActivity{
    if (activity==nil) {
        activity=[[ZHWActivity alloc]init];
    }
    return activity;
}

/*
 系统
 */
- (UIView *)inView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}
-(void)startActivity:(UIView *)view  AnimatingValue:(CGFloat)value   bufferWidth:(CGFloat )width  bufferHeight:(CGFloat)height   activityConstraint:(BOOL)constraint{

    _animatingValue=value;
    
    self.frame=CGRectMake(0, 0, width, height);
    activity.center=view.center;
    activity.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                          UIViewAutoresizingFlexibleBottomMargin |
                                          UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleRightMargin);
    
//    UIView *view1=[[UIView alloc]init];
    
    [ZHWActivity getActivity].inView.frame=view.frame;
    
    if (constraint) {
        [view addSubview:[ZHWActivity getActivity].inView];
        [ZHWActivity getActivity].inView.hidden=NO;

    }
    [view addSubview:activity];
    

    [activity startAnimating];

}



-(void)stopAnimating:(UIView *)view{

    [activity stopAnimating];

}



- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 28, 28)];
    if (self)
    {
        self.showsTouchWhenHighlighted = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"qy_loading"] forState:UIControlStateNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsTouchWhenHighlighted = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"qy_loading"] forState:UIControlStateNormal];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.showsTouchWhenHighlighted = YES;
        [self setBackgroundImage:[UIImage imageNamed:@"qy_loading"] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)isAnimating
{
    CAAnimation *spinAnimation = [self.layer animationForKey:@"spinAnimation"];
    return (animating || spinAnimation);
}

- (void)startAnimating
{
    self.hidden=NO;
    animating = YES;
    [self spin:_animatingValue];
    
}


- (void)stopAnimating
{
    self.hidden=YES;
    animating = NO;
    
    
    [ZHWActivity getActivity].inView.hidden=YES;
    
    
}

- (void)spin:(int)value
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:_animatingValue*M_PI];
    

    spinAnimation.duration = self.animationDuration;
    spinAnimation.delegate = self;
    [self.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

#pragma mark - Animation Delegates

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (animating)
    {
        [self spin:_animatingValue];
    }
}

#pragma mark - Property Methods

- (CGFloat)animationDuration
{
    if (!_animationDuration)
    {
        _animationDuration = 1.0f;
    }
    return _animationDuration;
}






@end
