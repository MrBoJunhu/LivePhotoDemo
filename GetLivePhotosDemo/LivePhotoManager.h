//
//  LivePhotoManager.h
//  GetLivePhotosDemo
//
//  Created by BillBo on 2017/8/23.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

typedef void(^resultBlock)(NSData *data , NSString *originalFilename);

typedef void(^ResultPath)(NSString *filePath, NSString *fileName);

@interface LivePhotoManager : NSObject

+(LivePhotoManager *)shareLivePhotoManager;


/**
 获取照片

 @param asset asset description
 @param result result description
 */
- (void)getImageFromPHAsset:(PHAsset *)asset complete:(resultBlock)result;


/**
 获取视频路径

 @param asset asset description
 @param result result description
 */
- (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result;
/**
 获取视频

 @param asset asset description
 @param result result description
 */
- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(resultBlock)result;


/**
 保存视频到相册

 @param url url description
 */
- (void)saveVideoWithVideoURL:(NSURL *)url;

@end
