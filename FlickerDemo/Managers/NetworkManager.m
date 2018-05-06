//
//  NetworkManager.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation NetworkManager

+ (AFHTTPSessionManager *)p_requestManagerForGetObject {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.requestSerializer.HTTPShouldHandleCookies = NO;
    return manager;
}

+ (void)getObjectWithURLPath:(NSString *)URLPath params:(NSDictionary *)params success:(SUCCESS_BLOCK)success failure:(FAILURE_BLOCK)failure{

    AFHTTPSessionManager *manager = [self p_requestManagerForGetObject];
    NSString *url = URLPath;
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [manager GET:url parameters:paramDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
