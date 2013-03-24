//
//  SReorderableViewController.m
//  StaticTableView
//
//  Created by Suen Gabriel on 3/24/13.
//  Copyright (c) 2013 Gabriel. All rights reserved.
//

#import "SReorderableViewController.h"

@interface SReorderableViewController ()

@property (nonatomic, strong) NSMutableArray *arraysOfKeys;
@property (nonatomic, copy) void (^completionHandler)(NSArray *);

@end

@implementation SReorderableViewController

- (id)initWithArraysOfKeys:(NSArray *)arraysOfKeys andCompletionHandler:(void (^)(NSArray *arraysOfKeys))block
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _arraysOfKeys = [NSMutableArray arrayWithCapacity:[arraysOfKeys count]];
        [arraysOfKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                [_arraysOfKeys addObject:[NSMutableArray arrayWithArray:(NSArray *)obj]];
            }
        }];
        _completionHandler = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) myself = self;
    [self.arraysOfKeys enumerateObjectsUsingBlock:^(NSArray *keys, NSUInteger idx, BOOL *stop) {
        [self addSection:^(SSection *section) {
            if (myself.sectionTitles && myself.sectionTitles[idx]) {
                [section setHeaderView:[UILabel headerLabelWithText:[myself.sectionTitles[idx] description]]];
            }
            [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [section addRow:^(SRow *row) {
                    [row setConfigurationBlock:^(UITableViewCell *cell) {
                        cell.textLabel.text = [obj description];
                        cell.showsReorderControl = YES;                        
                    }];
                }];
            }];
        }];
    }];
    self.tableView.editing = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.completionHandler) {
        self.completionHandler(self.arraysOfKeys);
    }
    [super viewWillDisappear:animated];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self moveObjectAtIndexPath:sourceIndexPath inArray:[self.sections[sourceIndexPath.section] rows] toIndexPath:destinationIndexPath inArray:[self.sections[destinationIndexPath.section] rows]];
    [self moveObjectAtIndexPath:sourceIndexPath inArray:self.arraysOfKeys[sourceIndexPath.section] toIndexPath:destinationIndexPath inArray:self.arraysOfKeys[destinationIndexPath.section]];
}

- (void)moveObjectAtIndexPath:(NSIndexPath *)sourceIndexPath inArray:(NSMutableArray *)fromArray
                  toIndexPath:(NSIndexPath *)destinationIndexPath inArray:(NSMutableArray *)toArray
{
    id objToMove = fromArray[sourceIndexPath.row];
    [fromArray removeObjectAtIndex:sourceIndexPath.row];
    [toArray insertObject:objToMove atIndex:destinationIndexPath.row];
}



@end
