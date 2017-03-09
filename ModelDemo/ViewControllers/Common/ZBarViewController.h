//
//  ZBarViewController.h
//  clife
//
//  Created by hongkunpeng on 14/12/23.
//
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
@protocol ZBarDelegate <NSObject>
-(void)zbarResult:(NSString*)result;
@end
@interface ZBarViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (assign, nonatomic) id <ZBarDelegate> delegate;
@end
