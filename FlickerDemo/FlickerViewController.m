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
//    if( searchText.length > 3){
//        [self.dataSourceDelegateObject updateWithSearchedText:searchText];
//    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if( searchBar.text.length > 2){
        [self.dataSourceDelegateObject updateWithSearchedText:searchBar.text];
    }
}

@end
