//
//  CollectionViewDataSourceAndDelegate.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "CollectionViewDataSourceAndDelegate.h"
#import "FlickerCollectionViewCell.h"
#import "FlickerDataModel.h"
#import "Constants.h"
#import "NetworkManager.h"
#import "ImageDownloadManager.h"
#import "FooterReuseableView.h"

@class FlickerDataModel;
@interface CollectionViewDataSourceAndDelegate()

@property BOOL isFetchRequestInProgress;
@property NSInteger totalPagesOnServer;
@property NSInteger pageNumber;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSString *searchedText;
@property (nonatomic,strong) NSMutableArray<FlickerDataModel *> *arrayOfFlickerDataModel;

@property NSInteger columnPerRow;

@end

@implementation CollectionViewDataSourceAndDelegate

- (id)initWithCollectionView:(UICollectionView *)collectionView {
    
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        
        [self.collectionView registerClass:[FooterReuseableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myfooter"];
        
        self.arrayOfFlickerDataModel = [NSMutableArray new];
        self.columnPerRow = 2;
    }
    return self;
}

#pragma mark : UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if( section == 0){
        return self.arrayOfFlickerDataModel.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickerDataModel *dataModel = [self.arrayOfFlickerDataModel objectAtIndex:indexPath.row];
    [(FlickerCollectionViewCell *)cell updateViewWithDataModel:dataModel];
    
    if( indexPath.row+1 == self.arrayOfFlickerDataModel.count ){
        [self fetchData];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"FlickerCollectionViewCell";
    FlickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark : UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat collectionViewWidth = collectionView.frame.size.width;
    CGFloat spaces = (self.columnPerRow - 1) * 10;
    CGFloat cellWidth = (collectionViewWidth - spaces ) / self.columnPerRow;
    
    return CGSizeMake(cellWidth, cellWidth);
}

- (void)updateWithSearchedText:(NSString *)searchedText {
    self.isFetchRequestInProgress = false;
    [[ImageDownloadManager sharedManager]cancelAllImageOperation];
    self.searchedText = searchedText;
    
    self.pageNumber = 0;
    [self.arrayOfFlickerDataModel removeAllObjects];
    [self.collectionView reloadData];
    
    [self fetchData];
}

- (void)fetchData{
    
    if( self.isFetchRequestInProgress ){
        return;
    }
    
    self.isFetchRequestInProgress = true;
    NSString *path = [self getSearchPath];
    [NetworkManager getObjectWithURLPath:path params:nil success:^(id responseObject) {
        
        BOOL isValidResponse = [[responseObject objectForKey:@"stat"]isEqualToString:@"ok"];
        if( isValidResponse ){
            NSDictionary *photosDict = [responseObject objectForKey:@"photos"];
            self.pageNumber = [[photosDict objectForKey:@"page"] integerValue];
            self.totalPagesOnServer = [[photosDict objectForKey:@"pages"] integerValue];
            
            NSMutableArray *listOfPhotos = [photosDict objectForKey:@"photo"];
            NSMutableArray *arrayOfNewData = [self getFlickerDataModelFromServrResponse:listOfPhotos];
            [self updateCollectionViewWithNewData:arrayOfNewData];
        }
        
        self.isFetchRequestInProgress = false;
    } failure:^(NSError *error) {
        self.isFetchRequestInProgress = false;
    }];
}

- (void)updateCollectionViewWithNewData:(NSArray *)arrayOfNewData{
    
    NSInteger lastItemOfCollectionView = self.arrayOfFlickerDataModel.count - 1;
    NSMutableArray <NSIndexPath *>* indexPathToBeInserted =  [NSMutableArray new];
    
    for(NSInteger itr = 1 ; itr <= arrayOfNewData.count ; itr++){
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:(lastItemOfCollectionView + itr) inSection:0];
        [indexPathToBeInserted addObject:indexpath];
    }
    
    [self.arrayOfFlickerDataModel addObjectsFromArray:arrayOfNewData];
    [self.collectionView insertItemsAtIndexPaths:indexPathToBeInserted];
    
    
}

- (NSString *)getSearchPath{
    
    self.searchedText = [self.searchedText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *searchPath = [NSString stringWithFormat:@"%@&api_key=%@&text=%@&per_page=%@&page=%ld&format=json&nojsoncallback=1",kBaseSearchRoute,kFlikerKey,self.searchedText,kPerPageCount,(long)self.pageNumber+1];
    return searchPath;
}

- (NSMutableArray<FlickerDataModel *>*)getFlickerDataModelFromServrResponse:(NSArray *)serverResponse {
    
    NSMutableArray<FlickerDataModel *>* localDataArray = [NSMutableArray new];
    
    [serverResponse enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FlickerDataModel *dataModel = [FlickerDataModel modelWithServerData:obj];
        [localDataArray addObject:dataModel];
    }];
    
    return localDataArray;
}

- (void)updateGridWithColumn:(NSInteger)column {
    self.columnPerRow = column;
    NSArray<NSIndexPath *> *indexPathsForVisibleItems = [self.collectionView indexPathsForVisibleItems];
    [self.collectionView reloadItemsAtIndexPaths:indexPathsForVisibleItems];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }else  if( self.isFetchRequestInProgress){
        return CGSizeMake(self.collectionView.bounds.size.width, 100);
    }
    else{
        return CGSizeZero;
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath {
    
    FooterReuseableView *theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myfooter" forIndexPath:theIndexPath];
    
    [theView.loader startAnimating];
    return theView;
}

@end
