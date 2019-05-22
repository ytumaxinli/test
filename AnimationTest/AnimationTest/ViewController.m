//
//  ViewController.m
//  AnimationTest
//
//  Created by stone on 2019/5/14.
//  Copyright © 2019 stone. All rights reserved.
//

#import "ViewController.h"
#import "TYAlterVIew.h"
#import <Masonry.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSTimer *timer;
@property (strong, nonatomic) UIWindow *alertWindow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"title";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@(50));
    }];
    
    
    //    // Do any additional setup after loading the view.
    //    TYPercentView *persentView = [[TYPercentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    [[UIApplication sharedApplication].keyWindow addSubview:persentView];
    //    [persentView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(@(100));
    //        make.centerX.equalTo(self.view);
    //        make.width.height.equalTo(@(100));
    //    }];
    //
    //    __block CGFloat percent = 0;
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        percent = percent + 0.02;
    //        [persentView setPercent:percent];
    //    }];
}

- (void)btnAction
{
    [self showImagePickerVC:nil];
    
    
    //    TYAlterVIew *alterView = [[TYAlterVIew alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    alterView.backgroundColor = [UIColor blackColor];
    //    alterView.opaque = 0.6;
    //    [alterView setBlock:^{
    //        [self showAlertBtnPressed:nil];
    //    }];
    //    [[UIApplication sharedApplication].keyWindow addSubview:alterView];
}


- (void)showAlertBtnPressed:(id)sender {
    
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"iPhoneX" ofType:@"png"];
    //    long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    //    NSLog(@"%lld",size);
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我要在最上面"
                                                                             message:@"谁也别惹我"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              //        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                              //        [appDelegate.window makeKeyAndVisible];
                                                              [self showImagePickerVC:nil];
                                                          }];
    [alertController addAction:confirmAction];
    
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)showImagePickerVC:(id)sender {
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.delegate = self;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    NSURL *imagePath = info[@"UIImagePickerControllerReferenceURL"];
    
    if ([[[imagePath scheme] lowercaseString] isEqualToString:@"assets-library"]) {
        
        // Load from asset library async
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                @try {
                    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:imagePath
                                   resultBlock:^(ALAsset *asset){
                                       ALAssetRepresentation *rep = [asset defaultRepresentation];
                                       CGImageRef iref = [rep fullScreenImage];
                                       if (iref) {
                                           
                                           //进行UI修改
                                           dispatch_sync(dispatch_get_main_queue(), ^{
                                               //                                               UIImage *image = [[UIImage alloc] initWithCGImage:iref];
                                               //                                               NSData *data = UIImageJPEGRepresentation(image, 1);
                                               //                                               NSString *tempPath = NSTemporaryDirectory();
                                               //                                               NSString *sourcePath = [tempPath stringByAppendingPathComponent:@"aa.jpg"];
                                               //                                               [[NSFileManager defaultManager] createFileAtPath:sourcePath contents:data attributes:nil];
                                               //                                               NSFileHandle *fileHadle = [NSFileHandle fileHandleForWritingAtPath:sourcePath];
                                               //                                               [data writeToFile:tempPath atomically:YES];
                                               //                                               [fileHadle writeData:data];
                                               //                                               [fileHadle closeFile];
                                               
                                               unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:@"/Users/stone/Desktop/com.stone.www.AnimationTest\ 2019-05-22\ 23\:11.57.307.xcappdata/AppData/tmp/aa.jpg " error:nil].fileSize;
                                               NSLog(@"%lld",size);
                                               
                                               
                                           });
                                           
                                       }
                                       
                                   }
                                  failureBlock:^(NSError *error) {
                                      
                                      NSLog(@"从图库获取图片失败: %@",error);
                                      
                                  }];
                } @catch (NSException *e) {
                    NSLog(@"从图库获取图片异常: %@", e);
                }
            }
        });
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (UIWindow *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIViewController *viewController = [[UIViewController alloc] init];
        _alertWindow.rootViewController = viewController;
    }
    
    return _alertWindow;
}

@end
