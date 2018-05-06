//
//  ImageOperation.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 06/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "ImageOperation.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageDownloadManager.h"

@interface ImageOperation (){
    BOOL        executing;
    BOOL        finished;
    NSURL        *urlToDownloadImage;
}

@end

@implementation ImageOperation

- (void)start {
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (id)initWithImageURL:(NSURL *)imageURL {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
        urlToDownloadImage = imageURL;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)main {
    @try {
        
        // Do the main work of the operation here.
        NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession] downloadTaskWithURL:urlToDownloadImage completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            if( !error ){
                
                UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
                [self completeOperationWithDownloadedImage:downloadedImage];
            }
            else{
            }
        }];
        
        [downloadPhotoTask resume];
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

- (void)completeOperationWithDownloadedImage:(UIImage *)downloadedImage {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    [[ImageDownloadManager sharedManager]imageDownloadedCompleteForURL:urlToDownloadImage withImage:downloadedImage];
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
