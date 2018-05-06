//
//  FlickerDataModel.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickerDataModel : NSObject

+ (FlickerDataModel *)modelWithServerData:(NSDictionary *)serverDict;

@property (nonatomic,strong) NSString *photoId;
@property (nonatomic,strong) NSString *secret;
@property (nonatomic,strong) NSString *server;
@property (nonatomic,strong) NSString *farm;

- (NSString *)getThubnailPath;
@end
