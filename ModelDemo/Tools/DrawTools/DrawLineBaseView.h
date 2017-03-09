//
//  DrawLineBaseView.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/12.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PI 3.14159265358979323846
@interface DrawLineBaseView : UIView
//画线
-(void)drawLine:(UIColor*)color startPoint:(CGPoint)start endPoint:(CGPoint)end isDash:(BOOL)dash;
//绘制圆形
-(void)drawArc:(CGPoint)point radius:(CGFloat)radius color:(UIColor*)color isFill:(BOOL)isFill;
//绘制三角形
-(void)drawTriangle:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill;
//绘制正方形
-(void)drawSquare:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill;
//绘制菱形
-(void)drawRhomb:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill;
//绘制五角星
-(void)drawStar:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill;
//绘制矩形
-(void)drawRectangle:(CGRect)rect color:(UIColor*)color isFill:(BOOL)isFill;
//绘制圆角矩形
-(void)drawRoundRect:(CGRect)rect color:(UIColor*)color radius:(CGFloat)radius;
@end
