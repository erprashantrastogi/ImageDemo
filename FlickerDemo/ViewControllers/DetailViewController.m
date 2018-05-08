//
//  DetailViewController.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 07/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageDownloadManager.h"
#import "FlickerDataModel.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.thumbnailImage;
    
    [[ImageDownloadManager sharedManager]downloadImageForLink:[self.flickerDataModel getLargeImagePath] completionHandler:^(BOOL success, UIImage *imageObj, NSString *requestPath) {
        if( success ){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = imageObj;
            });
        }
    }];
}

@end
