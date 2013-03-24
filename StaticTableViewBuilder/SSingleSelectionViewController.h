//
//  SSingleSelectionViewController.h
//  StaticTableView
//
//  Created by Suen Gabriel on 3/24/13.
//  Copyright (c) 2013 Gabriel. All rights reserved.
//

#import "STableViewController.h"

@interface SSingleSelectionViewController : STableViewController

- (id)initWithKeys:(NSArray *)keys selectedKey:(NSString *)selectedKey andCompletionHandler:(void (^)(NSString *key))block;

@end
