//
//  CollectionViewDataSourceAndDelegate.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FlickerViewController;
@interface CollectionViewDataSourceAndDelegate : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>

- (id)initWithCollectionView:(UICollectionView *)collectionView andController:(FlickerViewController *)viewController ;
- (void)updateWithSearchedText:(NSString *)searchedText;
- (void)updateGridWithColumn:(NSInteger)column;

@end
