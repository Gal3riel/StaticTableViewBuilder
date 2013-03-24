//
//  SReorderableViewController.h
//  StaticTableView
//
//  Created by Suen Gabriel on 3/24/13.
//  Copyright (c) 2013 Gabriel. All rights reserved.
//

#import "STableViewController.h"

@interface SReorderableViewController : STableViewController

- (id)initWithArraysOfKeys:(NSArray *)arraysOfKeys andCompletionHandler:(void (^)(NSArray *arraysOfKeys))block;

@property (nonatomic, strong) NSArray *sectionTitles;

@end
