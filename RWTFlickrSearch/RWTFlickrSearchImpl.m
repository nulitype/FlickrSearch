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
        NSString *OFSampleAppAPIKey = @"51cb57507a1829e3bbe13b8edd4f400b";
        NSString *OFSampleAppAPISharedSecret = @"5ddbcb6feb937458";
        
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey sharedSecret:OFSampleAppAPISharedSecret];
        
        _requests = [NSMutableSet new];
    }
    return self;
}

//- (RACSignal *)flickrSearchSignal:(NSString *)searchString {
//    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
//}

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

- (RACSignal *)flickrSearchSignal:(NSString *)searchString {
    return [self signalFromAPIMethod:@"flickr.photo.search"
                           arguments:@{@"text": searchString,
                                       @"sort": @"interestingness-desc"
                                       } transform:^id(NSDictionary *response) {
                                           RWTFlickrSearchResults *result = [RWTFlickrSearchResults new];
                                           result.searchString = searchString;
                                           result.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
                                           
                                           NSArray *photos = [response valueForKeyPath:@"photos.photo"];
                                           result.photos = [photos linq_select:^id(NSDictionary *jsonPhoto) {
                                               RWTFlickrPhoto *photo = [RWTFlickrPhoto new];
                                               photo.title = [jsonPhoto valueForKeyPath:@"title"];
                                               photo.identifier = [jsonPhoto valueForKeyPath:@"id"];
                                               photo.url = [self.flickrContext photoSourceURLFromDictionary:jsonPhoto size:OFFlickrSmallSize];
                                               
                                               return photo;
                                           }];
                                           return photos;
                                       }];
}

@end
