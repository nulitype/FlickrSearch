//
//  RWTViewModelServices.h
//  RWTFlickrSearch
//
//  Created by WongEric on 16/2/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearch.h"

@protocol RWTViewModelServices <NSObject>

- (id<RWTFlickrSearch>)getFlickrSearchService;

@end
