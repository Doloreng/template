//
//  UIAlertView+Block.h
//  two
//
//  Created by Eason on 15/8/9.
//  Copyright (c) 2015年 eason. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteBlock) (NSInteger buttonIndex);
@interface UIAlertView(Block)
//-(void) handlerClickedButton:(void (^)(NSInteger btnIndex))aBlock;
// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;
@end
