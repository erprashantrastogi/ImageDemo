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
    // Do any additional setup after loading the view.
    [[ImageDownloadManager sharedManager]downloadImageForLink:[self.flickerDataModel getLargeImagePath] completionHandler:^(BOOL success, UIImage *imageObj, NSString *requestPath) {
        if( success ){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = imageObj;
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
