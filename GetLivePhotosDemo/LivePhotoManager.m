//
//  LivePhotoManager.m
//  GetLivePhotosDemo
//
//  Created by BillBo on 2017/8/23.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "LivePhotoManager.h"

@interface LivePhotoManager()

@end

@implementation LivePhotoManager

+ (LivePhotoManager *)shareLivePhotoManager{
    
    static LivePhotoManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)getImageFromPHAsset:(PHAsset *)asset complete:(resultBlock)result {
    
    __block NSData *data;
    
    PHAssetResource *resource = [PHAssetResource assetResourcesForAsset:asset].firstObject;
    
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
  
        //区分 PHAsset 是否是一个图片类型的 Asset
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        
        imageRequestOptions.version = PHImageRequestOptionsVersionCurrent;
        
        imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        imageRequestOptions.synchronous = YES;
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
           
            data = [NSData dataWithData:imageData];
            
        }];
        
    }

    if (data.length > 0 ) {
        
        result(data, resource.originalFilename);
    }else{
        result(nil, resource.originalFilename);
    }

}



- (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result {
   
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
    
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
        
            assetRes.type == PHAssetResourceTypeVideo) {
            
            resource = assetRes;
        
        }
    
    }
    
    NSString *fileName = @"tempAssetVideo.mov";
    
    if (resource.originalFilename) {
    
        fileName = resource.originalFilename;
    
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
    
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        
        options.version = PHImageRequestOptionsVersionCurrent;
        
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 result(PATH_MOVIE_FILE, fileName);
                                                             }
                                                         }];
    } else {
       
        result(nil, nil);
  
    }

}

- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(resultBlock)result {
    
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
    
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
        
            assetRes.type == PHAssetResourceTypeVideo) {
            
            resource = assetRes;
        
        }
    
    }
    
    NSString *fileName = @"tempAssetVideo.mov";
    
    if (resource.originalFilename) {
    
        fileName = resource.originalFilename;
    
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
    
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        
        options.version = PHImageRequestOptionsVersionCurrent;
        
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                            
                                                             if (error) {
                                                             
                                                                 result(nil, nil);
                                                            
                                                             } else {
                                                                 
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                             
                                                                 result(data, fileName);
                                                             
                                                             }
                                                             
                                                             [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         
                                                         }];
    } else {
      
        result(nil, nil);
    
    }

}


- (void)saveVideoWithVideoURL:(NSURL *)url {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];

        [request addResourceWithType:PHAssetResourceTypePairedVideo
                             fileURL:url
                             options:nil];

        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
       
        if (success) {
            
            NSLog(@"保存成功呢!");
        }else{
            
            NSLog(@"保存失败!");
        }
        
    }];
    
}


@end
