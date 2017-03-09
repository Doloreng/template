//
//  ZBarViewController.m
//  clife
//
//  Created by hongkunpeng on 14/12/23.
//
//

#import "ZBarViewController.h"

@interface ZBarViewController ()
@property (strong, nonatomic)AVCaptureDevice *device;
@property (strong, nonatomic)AVCaptureDeviceInput *input;
@property (strong, nonatomic)AVCaptureMetadataOutput *output;
@property (strong, nonatomic)AVCaptureSession *session;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;
@property (weak, nonatomic) IBOutlet UIView *pickBg;
@property (strong,nonatomic) NSTimer * timer;
@property (assign, nonatomic) BOOL upOrdown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopLayout;
@property (assign, nonatomic) NSInteger num;
@property (assign, nonatomic) CGFloat totalMoveHeight;
@end

@implementation ZBarViewController
@synthesize session,preview,output,input,device,timer,num,upOrdown,delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;
    
//    self.view.backgroundColor=[UIColor colorWithRed:186/255.0 green:189/255.0 blue:194/255.0 alpha:1.0];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    self.totalMoveHeight=self.pickBg.frame.size.height;
    CGFloat centerx=self.view.center.x-self.pickBg.frame.size.width/2+2;
    CGFloat centery=self.view.center.y-self.pickBg.frame.size.height/2+2;
    CGRect frame=CGRectMake(centerx,centery, self.pickBg.frame.size.width-4, self.pickBg.frame.size.height-4);

//    CGRect frame=self.pickBg.frame;
    [self initUI:frame];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        self.lineTopLayout.constant=2*num;
        if (2*num >= self.totalMoveHeight) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        self.lineTopLayout.constant=2*num;
        if (num == 2) {
            upOrdown = NO;
        }
    }
    
}

-(IBAction)backPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        //
        [timer invalidate];
    }];
}

- (void)dealloc {
    
    
    // 1. 如果扫描完成，停止会话
    
    [session stopRunning];
    
    // 2. 删除预览图层
    [preview removeFromSuperlayer];
    [output setMetadataObjectsDelegate:nil queue:nil];
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    UIView *view=touch.view;
    if ([view isEqual:self.view]) {
        [self.timer invalidate];
        self.timer=nil;
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
}
//初始化UI

- (void)initUI:(CGRect)previewFrame {
    
    // Device
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    // Input
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
//        NSLog(@"你手机不支持二维码扫描!");
        [self alertMBProgressTixing:@"你手机不支持二维码扫描!"];
        return;
    }
    // Output
    output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // Session
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    // 条码类型
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    // Preview
    preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = previewFrame;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self startScan];
    
}
//启动扫描
- (void)startScan {
    // Start
    [session startRunning];
    [timer fire];
}
// 此方法是在识别到QRCode，并且完成转换
// 如果QRCode的内容越大，转换需要的时间就越长


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [session stopRunning];
    [timer invalidate];
    timer =nil;
    NSLog(@"二维码扫描结果: %@",stringValue);
    [self dismissViewControllerAnimated:YES completion:^{
        //
        if ([self.delegate respondsToSelector:@selector(zbarResult:)]) {
            [self.delegate zbarResult:stringValue];
        }
    }];
    
    
}
@end
