//
//  BaseViewController.m
//  clife
//
//  Created by Kabu_China on 14-8-19.
//
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()
@property (assign, nonatomic) CGRect originalViewFrame;
@end

@implementation BaseViewController
@synthesize originalViewFrame;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    originalViewFrame=self.view.frame;
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置键盘移动的view的基础数值
-(void)setKeyboardMoveView:(UIView *)keyboardMoveView{
    _keyboardMoveView=keyboardMoveView;
    originalViewFrame=keyboardMoveView.frame;
}
//添加键盘移动通知事件
-(void)addKeyboardMoveNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//移除键盘移动通知事件
-(void)removeKeyboardMoveNotify{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
//加载网页
-(void)loadDetailHtml:(NSString*)htmlstr textView:(UITextView*)textView{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlstr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    textView.attributedText = attributedString;
}

//添加返回
-(void)addNavibackItem{
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed:)];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed:)];
    self.navigationItem.leftBarButtonItem=backItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
//设置view圆角
-(void)borderView:(UIView*)view cornerRadius:(float)cornerRadius borderColor:(CGColorRef)borderColor{
    if (!borderColor) {
        borderColor=[UIColor clearColor].CGColor;
    }
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=cornerRadius;
//    view.layer.borderWidth=borderWidth;
    view.layer.borderColor=borderColor;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
//设置标题文字颜色
-(void)setNaviTitleColor:(UIColor*)color{
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:color,NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}
//设置navi不可见
-(void)setNaviVisiable{
    [self.navigationController setNavigationBarHidden:YES];
}
//返回按钮点击
-(void)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//数据缓冲
-(void)alertMbProgress:(BOOL)show{
    UIWindow *window=[UIApplication sharedApplication].windows.firstObject;
    if (show) {
        [MBProgressHUD showHUDAddedTo:window animated:YES];
    }else{
        [MBProgressHUD hideHUDForView:window animated:YES];
        if ([MBProgressHUD allHUDsForView:window].count) {
            [MBProgressHUD hideAllHUDsForView:window animated:YES];
        }
        
    }
}
//alertMbprogerss
-(void)alertMBProgressTixing:(NSString *)string{
    UIWindow *window=[UIApplication sharedApplication].windows.firstObject;
    MBProgressHUD*hud= [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode=MBProgressHUDModeText;
    hud.labelText=string;
    hud.labelFont=[UIFont systemFontOfSize:16];
    if (string.length>11) {
        hud.labelFont=[UIFont systemFontOfSize:12];
    }
    __weak UIWindow *blockview=window;
    dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
    dispatch_after(poptime, dispatch_get_main_queue(), ^(void){
        //
        [MBProgressHUD hideHUDForView:blockview animated:YES];
        if ([MBProgressHUD allHUDsForView:blockview].count) {
            [MBProgressHUD hideAllHUDsForView:blockview animated:YES];
        }
    });
}
//返回storyboard
-(UIStoryboard*)getMainStoryBoard{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return main;
}
//
-(UIView*)windowView{
    //    NSLog(@"全屏父 %@",self.parentViewController.parentViewController);
//    UIView *view=[UIApplication sharedApplication].windows.firstObject;
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *view=delegate.window;
    NSLog(@"window %@",view);
    return view;
}
#pragma mark keybard move
//键盘通知事件
- (void)keyboardWillShow:(NSNotification*)notification {
    [self selfViewAnimation:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self selfViewAnimation:notification up:NO];
}

//随键盘移动的动画
-(void)selfViewAnimation:(NSNotification*)notify up:(BOOL)isUp{
    NSDictionary *userInfo = [notify userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    UIView *moveview=self.keyboardMoveView?self.keyboardMoveView:self.view;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (isUp) {
        CGFloat keyboardTop = keyboardRect.size.height;
        if (originalViewFrame.size.width==0) {
            originalViewFrame=moveview.frame;
        }
        CGRect newFram = originalViewFrame;
        if (self.keyboardMoveHeight==0) {
            newFram.origin.y=newFram.origin.y-keyboardTop;
        }else{
           newFram.origin.y=newFram.origin.y-self.keyboardMoveHeight;
        }
        
        moveview.frame=newFram;
    }else {
        moveview.frame=originalViewFrame;
    }
    [UIView commitAnimations];
    
}


@end
