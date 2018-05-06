//
//  NetworkManager.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SUCCESS_BLOCK) (id responseObject);
typedef void (^FAILURE_BLOCK) (NSError *error);

@interface NetworkManager : NSObject
/**
 *  This method is to send a get request.
 *
 *  @param URLPath The URL Path
 *  @param params  Parameters to be sent.
 *  @param success This block is called on successfull completion of call. NOTE: This will be called on asynchronous thread.
 *  @param failure This block will be called on failure of call. NOTE: This will be called on asynchronous thread.
 */
+ (void)getObjectWithURLPath:(NSString *)URLPath params:(NSDictionary *)params success:(SUCCESS_BLOCK)success failure:(FAILURE_BLOCK)failure;
@end
