//
//  RWTSearchResultsViewModel.h
//  RWTFlickrSearch
//
//  Created by WongEric on 16/2/6.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"
#import "RWTFlickrSearchResults.h"

@interface RWTSearchResultsViewModel : NSObject

- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *searchResults;

@end
