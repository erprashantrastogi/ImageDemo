//
//  DownloadManager.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "ImageDownloadManager.h"
#import <AFNetworking.h>

@interface ImageDownloadManager()

@property (nonatomic,strong) NSCache *imageCache;
//@property (nonatomic,strong) NSURLSession *commonURLSession;

@property (nonatomic,strong) NSOperationQueue *mainOperationQueue;
@property (nonatomic,strong) NSMutableDictionary *urlToDataTaskMapping;
@property (nonatomic,strong) NSMutableDictionary *urlToCompletionHandlerMapping;

@end

@implementation ImageDownloadManager

+ (ImageDownloadManager *)sharedManager {
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[ImageDownloadManager alloc] init];
        ImageDownloadManager *manager = (ImageDownloadManager *)_sharedObject;
        
        [manager setImageCache:[NSCache new]];
        [manager setUrlToDataTaskMapping:[NSMutableDictionary new]];
        [manager setUrlToCompletionHandlerMapping:[NSMutableDictionary new]];
        manager.mainOperationQueue = [[NSOperationQueue alloc]init];
        
    });
    return _sharedObject;
}

- (void)downloadImageForLink:(NSString *)imageLink
           completionHandler:(void (^)(BOOL success , UIImage *imageObj,NSString *requestPath))completionHandler {
    
    NSURL *imageServerURL = [NSURL URLWithString:imageLink];
    if( !imageServerURL ){
        NSLog(@"imageServerURL is not valid %@",imageServerURL);
        completionHandler(false,nil,nil);
    }
    
    [self.urlToCompletionHandlerMapping setObject:completionHandler forKey:imageLink];
    UIImage *imageObject = [self.imageCache objectForKey:imageLink];
    
    if( imageObject ){
        // Found in Cache, return immediately
        void (^handler)(BOOL success , UIImage *imageObj,NSString *requestPath) =  [self.urlToCompletionHandlerMapping objectForKey:imageLink];
        handler(true,imageObject,imageLink);
        [self.urlToCompletionHandlerMapping removeObjectForKey:imageLink];
        [self.urlToDataTaskMapping removeObjectForKey:imageLink];
    }
    else{
        
        // Check if any data task is created for same.
        NSURLSessionDownloadTask *downloadTask = [self.urlToDataTaskMapping objectForKey:imageLink];
        if( downloadTask ) {
            // Download task is already there. increase the priority and update the completion handler
            downloadTask.priority = NSURLSessionTaskPriorityHigh;
        }
        else {
            // Create a download task
            NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession] downloadTaskWithURL:imageServerURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                
                NSString *imageServerPath = [response.URL absoluteString];
                void (^handler)(BOOL success , UIImage *imageObj,NSString *requestPath) =  [self.urlToCompletionHandlerMapping objectForKey:imageServerPath];
                
                if( imageServerPath ){
                    [self.urlToCompletionHandlerMapping removeObjectForKey:imageServerPath];
                }
                
                NSLog(@"Response");
                if( !error ){
                    
                    UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
                    [self.imageCache setObject:downloadedImage forKey:imageServerPath];
                    if( handler) {
                        handler(true,downloadedImage,imageServerPath);
                    }
                    else
                    {
                        //
                    }
                }
                else{
                    if( handler) {
                        handler(false,nil,nil);
                    }
                }
                [self.urlToDataTaskMapping removeObjectForKey:imageLink];
            }];
            
            [self.urlToDataTaskMapping setObject:downloadPhotoTask forKey:imageLink];
            // 4
            [downloadPhotoTask resume];
            
        }
    }
    
}

- (void)reducePriorityForImagePath:(NSString *)imageLink{
    NSURLSessionDownloadTask *downloadPhotoTask = [self.urlToDataTaskMapping objectForKey:imageLink];
    [downloadPhotoTask setPriority:0];
}

//+(void)downloadImageForLink:(NSString *)imageLink
//          completionHandler:(void (^)(NSString *requestPath , UIImage *imageObj,NSURL *filePath, NSError *error))completionHandler {
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *path = [self getPathForSaveImageForLink:imageLink];
//    NSURL *musicURL = [NSURL URLWithString:imageLink];
//    NSURLRequest *request = [NSURLRequest requestWithURL:musicURL];
//    //NSString *localPath = [self getAudioFileLocalPath:imageLink];
//    
//    NSURLSessionTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//        
//    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//        if( [response isKindOfClass:[NSURLResponse class]]){
//            
//            CGFloat statusCode =  [(NSHTTPURLResponse *)response statusCode];
//            if( statusCode != 200){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //[CommonFunctions showNotificationWithMessage:@"Some error occured."];
//                });
//                return nil;
//            }
//        }
//        
//        return [NSURL fileURLWithPath:path];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        
//        if( ! error ){
//            /*NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:RPSSessionManager.localAudioUrlDictionary];
//            [mutableDict setObject:localPath forKey:[response.URL absoluteString]];
//            RPSSessionManager.localAudioUrlDictionary = mutableDict;
//             */
//        }
//        NSString *requestPath = [response.URL absoluteString];
//        UIImage *imageObj = [UIImage imageWithContentsOfFile:path ];
//        completionHandler(requestPath,imageObj,filePath,error);
//    }];
//    [task resume];
//}
//
//+(NSString *)getPathForSaveImageForLink:(NSString *)link
//{
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/ImageFolder"];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    
//    NSString *localFilePath  = [self getAudioFileLocalPath:link];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:localFilePath];
//    
//    return path;
//}
//
//+(NSString *)getAudioFileLocalPath:(NSString *)audioLink{
//    
//    NSString *encodedURL = [self cacheKeyForString:audioLink];
//    NSString *localPath = [NSString stringWithFormat:@"/ImageFolder/%@",encodedURL];
//    localPath = [NSString stringWithFormat:@"%@.%@", localPath, [audioLink pathExtension]];
//    
//    return localPath;
//}
//
//+ (NSString *)cacheKeyForString:(NSString *)stringName
//{
//    if( stringName  && stringName.length > 0){
//        NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
//        NSArray *componenents = [stringName componentsSeparatedByCharactersInSet:charactersToRemove];
//        NSString *key = [componenents componentsJoinedByString:@"_"];
//        
//        return key;
//    }
//    else
//    {
//        NSLog(@"Develpoer Issue: Need to be check Audio Link is %@",stringName);
//        return stringName;
//    }
//}
@end
