//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by WongEric on 16/2/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RWTFlickrSearchViewModel ()

@property (nonatomic, weak) id<RWTViewModelServices> services;

@end

@implementation RWTFlickrSearchViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.searchText = @"search text";
//    self.title = @"Flickr Search";
    
    RACSignal *validSearchSignal = [[RACObserve(self, searchText)
                                     map:^id(NSString *text) {
                                         return @(text.length > 3);
                                     }]
                                    distinctUntilChanged];
    
    [validSearchSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@", x);
    }];
    
    self.executeSearch = [[RACCommand alloc] initWithEnabled:validSearchSignal signalBlock:^RACSignal *(id input) {
        return [self executeSearchSignal];
    }];
}

- (RACSignal *)executeSearchSignal {
    //return [[[[RACSignal empty] logAll] delay:2.0] logAll];
    return [[self.services getFlickrSearchService] flickrSearchSignal:self.searchText];
}

- (instancetype)initWithServices:(id<RWTViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        [self initialize];
    }
    return self;
}

@end
