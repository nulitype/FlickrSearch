//
//  RWTFlickrSearchResults.h
//  RWTFlickrSearch
//
//  Created by WongEric on 16/2/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrSearchResults : NSObject

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSUInteger totalResults;

@end
