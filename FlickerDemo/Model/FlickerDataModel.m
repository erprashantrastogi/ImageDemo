//
//  FlickerDataModel.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "FlickerDataModel.h"

@implementation FlickerDataModel

+ (FlickerDataModel *)modelWithServerData:(NSDictionary *)serverDict {
    
    FlickerDataModel *dataModel = [FlickerDataModel new];
    
    dataModel.photoId = [serverDict objectForKey:@"id"];
    dataModel.secret = [serverDict objectForKey:@"secret"];
    dataModel.server = [serverDict objectForKey:@"server"];
    dataModel.farm = [serverDict objectForKey:@"farm"];
    
    return dataModel;
}

- (NSString *)getThubnailPath{
    
    NSString *thubnailPath = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_t.jpg",self.farm,self.server,self.photoId,self.secret];
    return thubnailPath;
}

- (NSString *)getLargeImagePath{
    
    NSString *thubnailPath = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_h.jpg",self.farm,self.server,self.photoId,self.secret];
    return thubnailPath;
}
@end
