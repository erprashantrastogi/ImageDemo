//
//  DownloadManager.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "ImageDownloadManager.h"
#import <AFNetworking.h>
#import "ImageOperation.h"

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
        manager.mainOperationQueue.maxConcurrentOperationCount = 3;
        
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
        ImageOperation *imageOperation = [self.urlToDataTaskMapping objectForKey:imageLink];
        if( imageOperation ) {
            // Download task is already there. increase the priority and update the completion handler
            imageOperation.queuePriority = NSOperationQueuePriorityVeryHigh;
        }
        else {
            
            ImageOperation *imageOperation = [[ImageOperation alloc]initWithImageURL:imageServerURL];
            imageOperation.queuePriority = NSOperationQueuePriorityVeryHigh;
            [self.mainOperationQueue addOperation:imageOperation];
            
            [self.urlToDataTaskMapping setObject:imageOperation forKey:imageLink];
        }
    }
    
}

- (void)reducePriorityForImagePath:(NSString *)imageLink{
    ImageOperation *imageOperation = [self.urlToDataTaskMapping objectForKey:imageLink];
    imageOperation.queuePriority = NSOperationQueuePriorityVeryLow;
}

- (void)imageDownloadedCompleteForURL:(NSURL *)imageURL withImage:(UIImage *)image {
    
    NSString *imagePath = [imageURL absoluteString];
    [self.imageCache setObject:image forKey:imagePath];
    
    void (^handler)(BOOL success , UIImage *imageObj,NSString *requestPath) =  [self.urlToCompletionHandlerMapping objectForKey:imagePath];
    
    if( handler ){
        handler(true,image,imagePath);
    }else {
        NSLog(@"Handler not found");
    }
    
    [self.urlToCompletionHandlerMapping removeObjectForKey:imagePath];
    [self.urlToDataTaskMapping removeObjectForKey:imagePath];
}

- (void)cancelAllImageOperation {
    [self.mainOperationQueue cancelAllOperations];
}
@end
