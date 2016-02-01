//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by WongEric on 16/2/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import <objectiveflickr/ObjectiveFlickr.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>

@interface RWTFlickrSearchImpl () <OFFlickrAPIRequestDelegate>

@property (nonatomic, strong) NSMutableSet *requests;
@property (nonatomic, strong) OFFlickrAPIContext *flickrContext;

@end

@implementation RWTFlickrSearchImpl

- (instancetype)init {
    if (self = [super init]) {
        NSString *OFSampleAppAPIKey = @"API_KEY";
        NSString *OFSampleAppAPISharedSecret = @"SECRET";
        
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey sharedSecret:OFSampleAppAPISharedSecret];
        
        _requests = [NSMutableSet new];
    }
    return self;
}

- (RACSignal *)flickrSearchSignal:(NSString *)searchString {
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}

- (RACSignal *)signalFromAPIMethod:(NSString *)method arguments:(NSDictionary *)args transform:(id (^)(NSDictionary *response))block {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        OFFlickrAPIRequest *flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        flickrRequest.delegate = self;
        [self.requests addObject:flickrRequest];
        
        RACSignal *successSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        
        [[[successSignal map:^id(RACTuple *tuple) {
            return tuple.second;
        }]
          map:block]
         subscribeNext:^(id x) {
             [subscriber sendNext:x];
             [subscriber sendCompleted];
         }];
        
        [flickrRequest callAPIMethodWithGET:method arguments:args];
        
        return [RACDisposable disposableWithBlock:^{
            [self.requests removeObject:flickrRequest];
        }];
        
    }];
}

@end
