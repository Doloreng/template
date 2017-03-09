//
//  BaseViewController.h
//  clife
//
//  Created by Kabu_China on 14-8-19.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#define kNUMString @"0123456789"
#define kNUMABCString @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface BaseViewController : UIViewController
@property (nonatomic, retain) UIView *keyboardMoveView;
@property (nonatomic, assign) CGFloat keyboardMoveHeight;
//设置view圆角
-(void)borderView:(UIView*)view cornerRadius:(float)cornerRadius borderColor:(CGColorRef)borderColor;
//添加返回
-(void)addNavibackItem;
//alertMbprogerss
-(void)alertMBProgressTixing:(NSString *)string;
//返回按钮点击
-(void)backPressed:(id)sender;
//返回storyboard
-(UIStoryboard*)getMainStoryBoard;
//设置navi不可见
-(void)setNaviVisiable;
//添加键盘移动通知事件
-(void)addKeyboardMoveNotify;
//移除键盘移动通知事件
-(void)removeKeyboardMoveNotify;
//数据缓冲
-(void)alertMbProgress:(BOOL)show;
-(UIView*)windowView;
@end
