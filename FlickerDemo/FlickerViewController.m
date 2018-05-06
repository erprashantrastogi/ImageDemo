//
//  ViewController.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 02/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "FlickerViewController.h"
#import "CollectionViewDataSourceAndDelegate.h"
#import "NetworkManager.h"

@interface FlickerViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar ;
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) CollectionViewDataSourceAndDelegate *dataSourceDelegateObject;

@property (strong, nonatomic) NSTimer *timer;
@end

@implementation FlickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self prepareSubViews];
}

- (void)prepareSubViews {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.dataSourceDelegateObject = [[CollectionViewDataSourceAndDelegate alloc]initWithCollectionView:self.mainCollectionView];;
    
    self.mainCollectionView.dataSource = self.dataSourceDelegateObject;
    self.mainCollectionView.delegate = self.dataSourceDelegateObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark :UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if( searchText.length >= 2){
        
        if( !self.timer ){
            self.timer =  [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(searchTimer) userInfo:nil repeats:false];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (void)searchTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.dataSourceDelegateObject updateWithSearchedText:self.searchBar.text];
}


- (IBAction)actionSheetButtonPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Images Per Row"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Four"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self.dataSourceDelegateObject updateGridWithColumn:4];
                                                          }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Two"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self.dataSourceDelegateObject updateGridWithColumn:2];
                                                           }]; 
    
    UIAlertAction *threeAction = [UIAlertAction actionWithTitle:@"Three"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self.dataSourceDelegateObject updateGridWithColumn:3];
                                                           }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:threeAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
