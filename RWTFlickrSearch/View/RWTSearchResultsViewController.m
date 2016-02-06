//
//  Created by Colin Eberhardt on 23/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RWTSearchResultsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (nonatomic, strong) RWTSearchResultsViewController *viewModel;

@end

@implementation RWTSearchResultsViewController

- (instancetype)initWithViewModel:(RWTSearchResultsViewController *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

@end
