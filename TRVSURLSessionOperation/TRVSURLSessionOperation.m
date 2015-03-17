//
//  TRVSQueuedURLSesssion.m
//  TRVSURLSessionOperation
//
//  Created by Travis Jeffery on 4/17/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSURLSessionOperation.h"

@interface TRVSURLSessionOperation ()
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL executing;
@end

@implementation TRVSURLSessionOperation

@synthesize finished  = _finished;
@synthesize executing = _executing;

- (instancetype)initWithSession:(NSURLSession *)session URL:(NSURL *)url completionHandler:(TRVSURLSessionOperationCompletion)completionHandler {
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        _task = [session dataTaskWithURL:url
                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [weakSelf completeOperationWithBlock:completionHandler data:data response:response error:error];
        }];
    }
    return self;
}

- (instancetype)initWithSession:(NSURLSession *)session request:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        _task = [session dataTaskWithRequest:request
                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [weakSelf completeOperationWithBlock:completionHandler data:data response:response error:error];
        }];
    }
    return self;
}

#pragma mark - KVO Overrides

- (void)cancel {
    [super cancel];
    [self.task cancel];
}

- (void)start {
    if (self.isCancelled) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
        _finished = YES;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    } else {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
        [self.task resume];
        _executing = YES;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    }
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isAsynchronous {
    return YES;
}

#pragma mark - Helpers

- (void)completeOperationWithBlock:(TRVSURLSessionOperationCompletion)block data:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    if (!self.isCancelled && block)
        block(data, response, error);
    [self completeOperation];
}

- (void)completeOperation {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    
    _executing = NO;
    _finished  = YES;
    
    [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
}

@end

