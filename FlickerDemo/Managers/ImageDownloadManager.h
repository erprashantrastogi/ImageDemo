//
//  DownloadManager.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDownloadManager : NSObject

+ (ImageDownloadManager *)sharedManager;

- (void)downloadImageForLink:(NSString *)imageLink
          completionHandler:(void (^)(BOOL success , UIImage *imageObj,NSString *requestPath))completionHandler ;


- (void)reducePriorityForImagePath:(NSString *)imageLink;
- (void)cancelAllImageOperation;

//+(void)downloadImageForLink:(NSString *)imageLink
//          completionHandler:(void (^)(NSString *requestPath , UIImage *imageObj,NSURL *filePath, NSError *error))completionHandler ;

- (void)imageDownloadedCompleteForURL:(NSURL *)imageURL withImage:(UIImage *)image;
@end
