//
//  DrawLineBaseView.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/12.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "DrawLineBaseView.h"

@implementation DrawLineBaseView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawLine:[UIColor redColor] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(100, 100) isDash:YES];
}
//画线
-(void)drawLine:(UIColor*)color startPoint:(CGPoint)start endPoint:(CGPoint)end isDash:(BOOL)dash{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    //设置颜色
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    //设置线宽为1
    CGContextSetLineWidth(ctx, 1.0);
    if (dash) {
        CGFloat lengths[]={2,2};
        CGContextSetLineDash(ctx, 0, lengths, 2);
    }else{
        CGContextSetLineDash(ctx, 0, 0, 0);
    }
    CGContextMoveToPoint(ctx, start.x, start.y);
    CGContextAddLineToPoint(ctx, end.x, end.y);
    CGContextStrokePath(ctx);
    //    CGContextClosePath(ctx);
}

//绘制圆形
-(void)drawArc:(CGPoint)point radius:(CGFloat)radius color:(UIColor*)color isFill:(BOOL)isFill{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (isFill) {
        //填充圆，无边框
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGContextAddArc(context, point.x, point.y, radius, 0, 2*PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFill);//绘制填充
    }else{
        //边框圆
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 1.0);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, point.x, point.y, radius, 0, 2*PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    }
}
//绘制三角形
-(void)drawTriangle:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(point.x, point.y-3);//坐标1
    sPoints[1] =CGPointMake(point.x-2.55, point.y+1.5);//坐标2
    sPoints[2] =CGPointMake(point.x+2.55, point.y+1.5);//坐标3
    if (isFill) {
        CGContextAddLines(context, sPoints, 3);//添加线
        CGContextClosePath(context);//封起来
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    }else{
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextAddLines(context, sPoints, 3);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
}
//绘制正方形
-(void)drawSquare:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (isFill) {
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGContextFillRect(context,CGRectMake(point.x-3, point.y-3, 6, 6));//填充框
    }else{
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokeRect(context,CGRectMake(point.x-3, point.y-3, 6, 6));//画方框
    }
    
}
//绘制矩形
-(void)drawRectangle:(CGRect)rect color:(UIColor *)color isFill:(BOOL)isFill{
    CGMutablePathRef path = CGPathCreateMutable();
    
    //将矩形添加到路径中
    CGPathAddRect(path,NULL,rect);
    //获取上下文
    CGContextRef currentContext =
    UIGraphicsGetCurrentContext();
    
    //将路径添加到上下文
    
    CGContextAddPath(currentContext, path);
    
    //设置矩形填充色
    
    [color setFill];
    
    //矩形边框颜色
    
    [color setStroke];
    //边框宽度
    CGContextSetLineWidth(currentContext,1.0f);
    
    
    //绘制
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
}
//绘制菱形
-(void)drawRhomb:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint sPoints[4];//坐标点
    sPoints[0] =CGPointMake(point.x, point.y-4);//坐标1
    sPoints[1] =CGPointMake(point.x-3, point.y);//坐标2
    sPoints[2] =CGPointMake(point.x, point.y+4);//坐标3
    sPoints[3] =CGPointMake(point.x+3, point.y);//坐标4
    if (isFill) {
        CGContextAddLines(context, sPoints, 4);//添加线
        CGContextClosePath(context);//封起来
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    }else{
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextAddLines(context, sPoints, 4);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
}
//绘制五角星
-(void)drawStar:(CGPoint)point color:(UIColor*)color isFill:(BOOL)isFill{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint sPoints[10];//坐标点
    CGFloat center=4;
    sPoints[0] =CGPointMake(point.x, point.y-center);//坐标1
    sPoints[2] =CGPointMake(point.x-sinf([self duFromromdu:72])*center, point.y-cosf([self duFromromdu:72])*center);//坐标2
    sPoints[4] =CGPointMake(point.x-sinf([self duFromromdu:36])*center, point.y+cosf([self duFromromdu:36])*center);//坐标3
    sPoints[6] =CGPointMake(point.x+sinf([self duFromromdu:36])*center, point.y+cosf([self duFromromdu:36])*center);//坐标4
    sPoints[8] =CGPointMake(point.x+sinf([self duFromromdu:72])*center, point.y-cosf([self duFromromdu:72])*center);//坐标5
    
    sPoints[1] =CGPointMake(point.x-sinf([self duFromromdu:36])*center/2, point.y-cosf([self duFromromdu:36])*center/2);//坐标1
    sPoints[3] =CGPointMake(point.x-sinf([self duFromromdu:72])*center/2, point.y+cosf([self duFromromdu:72])*center/2);//坐标2
    sPoints[5] =CGPointMake(point.x, point.y+center/2);//坐标3
    sPoints[7] =CGPointMake(point.x+sinf([self duFromromdu:72])*center/2, point.y+cosf([self duFromromdu:72])*center/2);//坐标4
    sPoints[9] =CGPointMake(point.x+sinf([self duFromromdu:36])*center/2, point.y-cosf([self duFromromdu:36])*center/2);//坐标5
    
    if (isFill) {
        CGContextAddLines(context, sPoints, 10);//添加线
        CGContextClosePath(context);//封起来
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    }else{
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextAddLines(context, sPoints, 10);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
}
//度数
-(CGFloat)duFromromdu:(CGFloat)num{
    return M_PI/(180/num);
}
//绘制圆角矩形
-(void)drawRoundRect:(CGRect)rect color:(UIColor*)color radius:(CGFloat)radius{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    //画圆矩形
    
    //设置线宽
    CGContextSetLineWidth(ctx, 1.0);
    
    //设置填充颜色和画笔颜色
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    
    
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextAddPath(ctx, clippath);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
