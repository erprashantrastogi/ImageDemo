//
//  FlickerCollectionViewCell.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "FlickerCollectionViewCell.h"
#import "ImageDownloadManager.h"
#import "FlickerDataModel.h"

@interface FlickerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) __block NSString *imagePathTobeRequest;

@end

@implementation FlickerCollectionViewCell

- (void)updateViewWithDataModel:(FlickerDataModel *)flickerDataModel {
    
    NSLog(@"updateViewWithDataModel");
    
    NSString *thumbnailPath = [flickerDataModel getThubnailPath];
    self.imagePathTobeRequest = thumbnailPath;
    
    [[ImageDownloadManager sharedManager]downloadImageForLink:thumbnailPath completionHandler:^(BOOL success, UIImage *imageObj,NSString *requestPath) {
        if( success ){
            if( [self.imagePathTobeRequest isEqualToString:requestPath]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView transitionWithView:self.imgView
                                      duration:0.2f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        self.imgView.image = imageObj;
                                    } completion:nil];
                });
            }
            else{
                NSLog(@"Not a valid image.");
            }
        }
    }];
}

- (void)prepareForReuse {
    //NSLog(@"prepareForReuse");
    [[ImageDownloadManager sharedManager] reducePriorityForImagePath:self.imagePathTobeRequest];
    self.imgView.image = [UIImage imageNamed:@"placeholder"];
}

@end
