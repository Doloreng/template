//
//  ViewController.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "ViewController.h"
#import "DataEngine.h"
#import "UIImage+ImageEffects.h"
#import "NSDate+Formatter.h"
#import "NSString+Encryption.h"
#import "AESEnryption.h"
#import "NSDownLoaderManger.h"
#import "DrawLineBaseView.h"
#import "FileDirManager.h"
#import "SysCommunication.h"
#import "NSData+Encryption.h"
#import "SysIPAddress.h"
#import "UIAlertView+Block.h"
#import "ZHWActivity.h"
#import "ZBarViewController.h"
typedef enum {
    StringNum=0,
    DateNum,
    AESNum,
    FileDirNum,
    SysInfoNum,
    DownLoadNum,
    UploadNum,
    ImageMask,
    ImageCutRect,
    ImageCutRount,
    DrawLineNum,
    AlertNewNum,
    CicleAlertNum,
    ZBarNum
    
}TestType;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet DrawLineBaseView *drawView;
@property (weak, nonatomic) IBOutlet UITextView *outPutTextView;
@property (weak, nonatomic) IBOutlet UIImageView *testImgView;
@property (weak, nonatomic) IBOutlet UITableView *listVc;
@property (strong , nonatomic) NSMutableArray *listArray;
@end

@implementation ViewController
@synthesize outPutTextView,listArray,listVc,drawView;
- (void)viewDidLoad {
    [super viewDidLoad];
    listArray=[[NSMutableArray alloc]initWithObjects:@"字符串：MD5,Base64",@"日期和字符串转换",@"AES加密",@"获取文档目录",@"系统工具",@"下载测试",@"上传测试",@"图片添加遮罩",@"图片按照方形剪切",@"图片按照圆形剪切",@"绘图与划线",@"弹框控件-关联对象",@"加载方式",@"二维码", nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didSelectRow:(NSInteger)selectRow{
    self.drawView.hidden=YES;
    self.testImgView.hidden=YES;
    self.testImgView.image=[UIImage imageNamed:@"test.jpg"];
    switch (selectRow) {
        case StringNum:
        {
            NSMutableString *muStr=[NSMutableString new];
            NSString *str=@"Hello China";
            [muStr appendFormat:@"源字符串：%@\n",str];
            [muStr appendFormat:@"md5转换后: %@\n",[str md5]];
//            NSString *sstr=@"Hello China";
            NSString *base64=[str encodeBase64String];
            [muStr appendFormat:@"base64加密: %@\n",base64];
            [muStr appendFormat:@"base64解密: %@\n",[base64 decodeBase64String]];
            NSString *charstr=@"HelloChina";
            [muStr appendFormat:@"HelloChina 过滤掉 China: %@\n",[charstr characterSet:@"China"]];
            
            outPutTextView.text=muStr;
        }
            break;
        case DateNum:
        {
            NSMutableString *muStr=[NSMutableString new];
            //yyyy-MM-dd HH:mm:ss
            NSString *format=@"yyyy-MM-dd HH:mm:ss";
            NSString *sourceStr=@"2015-06-12 05:06:04";
            NSDate *date=[NSDate dateFromString:sourceStr format:format];
            [muStr appendFormat:@"原时间字符串：%@\n",sourceStr];
            [muStr appendFormat:@"时间转换格式：%@\n",format];
            [muStr appendFormat:@"结果时间：%@\n",date];
            [muStr appendFormat:@"转换时区时间：%@\n",[NSDate getLocalDate:date]];
            NSString *dformat=@"yyyy-MM-dd";
            NSDate *ddate=[NSDate date];
            [muStr appendFormat:@"前一天的日期：%@\n",[NSDate getDateSinceDay:-1 format:dformat date:ddate]];
            
            outPutTextView.text=muStr;
        }
            break;
        case AESNum:
        {
            NSMutableString *muStr=[NSMutableString new];
            NSString *sourcestr=@"Hello China";
            NSString *key=@"^&&**^*((((";
            [muStr appendFormat:@"测试源字符串：%@\n测试Key: %@\n\n",sourcestr,key];
            NSData *sourceData=[sourcestr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *encodeData= [AESEnryption encryptAES256WithKey:key sourceData:sourceData];
            [muStr appendFormat:@"AES加密后的字符串: %@\n",[encodeData OutputDataToUTF8String]];
            NSData *decodeData=[AESEnryption decryptAES256WithKey:key sourceData:encodeData];
            [muStr appendFormat:@"AES解密密后的字符串: %@\n",[decodeData OutputDataToUTF8String]];
            outPutTextView.text=muStr;
        }
            break;
        case FileDirNum:
        {
            NSMutableString *muStr=[NSMutableString new];
            [muStr appendFormat:@"程序主目录:\n %@ \n\n",[FileDirManager homePath]];
            [muStr appendFormat:@"程序目录，不能存任何东西:\n %@ \n\n",[FileDirManager appPath]];
            [muStr appendFormat:@"文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据:\n %@ \n\n",[FileDirManager docPath]];
            [muStr appendFormat:@"配置目录，配置文件存这里:\n %@ \n\n",[FileDirManager libPrefPath]];
            [muStr appendFormat:@"缓存目录，系统永远不会删除这里的文件，ITUNES会删除:\n %@ \n\n",[FileDirManager libCachePath]];
            [muStr appendFormat:@"临时缓存目录，APP退出后，系统可能会删除这里的内容:\n %@ \n\n",[FileDirManager tmpPath]];
            
            outPutTextView.text=muStr;
            
        }
            break;
        case SysInfoNum:
        {
            NSMutableString *muStr=[NSMutableString new];
            [muStr appendFormat:@"系统版本号：%@\n",[SysCommunication sysVersion]];
            [muStr appendFormat:@"app版本号：%@\n",[SysCommunication appVersion]];
            [muStr appendFormat:@"app版本号：%@\n",[SysCommunication appBundleIdentifier]];
            [muStr appendFormat:@"IP4地址：%@\n",[SysIPAddress getIPAddress:YES]];
            [muStr appendFormat:@"IP6地址：%@\n",[SysIPAddress getIPAddress:NO]];
            [muStr appendFormat:@"检查麦克风可用：%d\n",[SysCommunication microphoneAvailable]];
            [muStr appendFormat:@"检查是否存在摄像头：%d\n",[SysCommunication cameraAvailable]];
            [muStr appendFormat:@"检查是否存在前置摄像头：%d\n",[SysCommunication frontCameraAvailable]];
            [muStr appendFormat:@"检测照片库可用：%d\n",[SysCommunication photoLibraryAvailable]];
            [muStr appendFormat:@"检查是否支持视频录制：%d\n",[SysCommunication videoCameraAvailable]];
            [muStr appendFormat:@"检测摄像头闪光灯是否存在：%d\n",[SysCommunication cameraFlashAvailable]];
            [muStr appendFormat:@"检测陀螺仪是否存在：%d\n",[SysCommunication gyroscopeAvailable]];
            [muStr appendFormat:@"检查设备使用的是否视网膜屏：%d\n",[SysCommunication retinaDisplayCapable]];
            
            [SysCommunication touchAuthenticateWithMessage:@"这是测试Touch" onSuccess:^(id obj) {
                //
                [muStr appendString:@"获取成功了"];
            } onError:^(NSError *error) {
                //
                [muStr appendFormat:@"未能获取touch %@",error];
            }];
            //拨打电话
            [SysCommunication telephoneWithPhoneNum:@"18310656693"];
            //发送短信
            [SysCommunication messageWithPhoneNum:@"18310656693"];
            //发送邮件
            [SysCommunication emailWithAddress:@"kunpeng.hong@bj.china.com"];
            outPutTextView.text=muStr;
        }
            break;
        case DownLoadNum:
        {
            //http://adcdownload.apple.com/WWDC_2015/Xcode_7_beta/Xcode_7_beta.dmg
            NSString *urlstr=@"http://pic.miercn.com/uploads/allimg/150609/40-150609151941.jpg";
//            NSString *urlstr=@"http://dl1sw.baidu.com/cb23fa31aaf3c/afdpo.exe";
            NSDownLoaderManger *manager=[NSDownLoaderManger new];
            [manager downloadFileWithUrl:urlstr filePathURL:nil saveName:@"beautiful.jpg" progress:nil success:^(id successObj) {
                //
                NSURL *path=successObj;
                NSLog(@"下载成功了 %@",path);
            } failure:^(NSError *error) {
                //
                NSLog(@"下载失败了 %@",error);
            }];
        }
            break;
        case UploadNum:
        {
            NSURL *pathurl=[[NSBundle mainBundle]URLForResource:@"test" withExtension:@"jpg"];
            NSString *urlstr=@"http://pic.miercn.com/uploads/allimg/";
            NSDownLoaderManger *manager=[NSDownLoaderManger new];
            [manager uploadFileWithFilePath:pathurl hostUrl:urlstr progress:nil success:^(id successObj) {
                //
                NSLog(@"上传成功了");
            } failure:^(NSError *error) {
                //
                NSLog(@"上传失败了 %@",error);
            }];
        }
            break;
        case ImageMask:
        {
            self.testImgView.hidden=NO;
            UIImage *source=self.testImgView.image;
            
            self.testImgView.image=[source applyLightEffect];
        }
            break;
        case ImageCutRect:
        {
            self.testImgView.hidden=NO;
            UIImage *source=self.testImgView.image;
            self.testImgView.image=[source getSubImage:CGRectMake(0, 20, 100, 100)];
        }
            break;
        case ImageCutRount:
        {
            
            self.testImgView.hidden=NO;
            UIImage *source=self.testImgView.image;
            self.testImgView.image=[source circleParam:100];
        }
            break;
        case DrawLineNum:
        {
            drawView.hidden=NO;
            
        }
            break;
        case AlertNewNum:
        {
            NSString *alert=@"关联消息";
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"消息" message:alert delegate:nil cancelButtonTitle:@"不查看" otherButtonTitles:@"去看看", nil];
            [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                //
                if (buttonIndex==1) {
                    outPutTextView.text=@"点击了【去看看】";
                }else{
                    outPutTextView.text=@"点击了【不查看】";
                }
                
            }];
            
        }
            break;
        case CicleAlertNum:
        {
            ZHWActivity *zhView=[ZHWActivity getActivity];
            [zhView startActivity:self.view AnimatingValue:2 bufferWidth:30 bufferHeight:30 activityConstraint:NO];
            dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
            dispatch_after(poptime, dispatch_get_main_queue(), ^{
                //
                [zhView stopAnimating];
            });
            
        }
            break;
        case ZBarNum:
        {
            ZBarViewController *zbVc=[[ZBarViewController alloc]initWithNibName:@"ZBarViewController" bundle:nil];
            [self presentViewController:zbVc animated:YES completion:^{
                //
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"TestTileIdentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    NSString *name=[listArray objectAtIndex:indexPath.row];
    cell.textLabel.text=name;
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectRow:indexPath.row];
}

@end
