//
//  ViewController.m
//  GetLivePhotosDemo
//
//  Created by BillBo on 2017/8/23.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

#import "LivePhotoManager.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerController;

@end

@implementation ViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];

}

- (IBAction)chooseAction:(id)sender {
    
    self.pickerController = [[UIImagePickerController alloc] init];
    
    self.pickerController.delegate = self;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"普通相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"LivePhoto" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:self.pickerController animated:YES completion:^{
            
        }];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:action1];
    
    [alertC addAction:action2];
    
    [alertC addAction:cancel];
    
    [self presentViewController:alertC animated:YES completion:^{

        
        
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    /*
     info :
     {
     UIImagePickerControllerMediaType = "public.image";
     UIImagePickerControllerOriginalImage = "<UIImage: 0x170287f80> size {3024, 4032} orientation 3 scale 1.000000";
     UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=294FC62C-6BAF-49AE-B6C6-22CE1A03FA4D&ext=JPG";
     }
     
     */

    //获取路径
    NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
    
    PHAsset *asset = fetchResult.firstObject;
    
    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        
        NSLog(@"选中的是LIVEPHOTO");
        
        [[LivePhotoManager shareLivePhotoManager] getVideoPathFromPHAsset:asset Complete:^(NSString *filePath, NSString *fileName) {
            
            NSLog(@"filePath : %@ 🍎  fileName : %@", filePath, fileName);
            
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
       
        }];
    
    }else{
     
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        activityView.hidesWhenStopped = YES;
        
        [self.view addSubview:activityView];

    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    

}

// 视频保存回调

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    if (error == nil) {

        NSLog(@"保存视频到相册成功!");
        
    }else{
        
        NSLog(@"保存视频到相册失败!");
        
    }
    
}

@end
