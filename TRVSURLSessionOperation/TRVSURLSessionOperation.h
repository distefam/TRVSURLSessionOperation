//
//  TRVSQueuedURLSesssion.h
//  TRVSURLSessionOperation
//
//  Created by Travis Jeffery on 4/17/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TRVSURLSessionOperationCompletion)(NSData *data, NSURLResponse *response, NSError *error);

@interface TRVSURLSessionOperation : NSOperation

+ (instancetype)operationWithSession:(NSURLSession *)session request:(NSURLRequest *)request completion:(TRVSURLSessionOperationCompletion)completion;

- (instancetype)initWithSession:(NSURLSession *)session URL:(NSURL *)url completionHandler:(TRVSURLSessionOperationCompletion)completionHandler;
- (instancetype)initWithSession:(NSURLSession *)session request:(NSURLRequest *)request completionHandler:(TRVSURLSessionOperationCompletion)completionHandler;

@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;

@end
