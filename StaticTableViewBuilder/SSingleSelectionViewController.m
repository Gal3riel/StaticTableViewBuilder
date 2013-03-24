//
//  SSingleSelectionViewController.m
//  StaticTableView
//
//  Created by Suen Gabriel on 3/24/13.
//  Copyright (c) 2013 Gabriel. All rights reserved.
//

#import "SSingleSelectionViewController.h"


@interface SSingleSelectionViewController ()

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, copy) NSString *selectedKey;
@property (nonatomic, copy) void (^completionHandler)(NSString *);

@property (nonatomic, weak) UITableViewCell *selectedCell;

@end

@implementation SSingleSelectionViewController

- (id)initWithKeys:(NSArray *)keys selectedKey:(NSString *)selectedKey andCompletionHandler:(void (^)(NSString *key))block
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _keys = keys;
        _selectedKey = selectedKey;
        _completionHandler = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) myself = self;
    [self addSection:^(SSection *section) {
        [myself.keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            [section addRow:^(SRow *row) {
                [row setConfigurationBlock:^(UITableViewCell *cell) {
                    cell.textLabel.text = key;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    if ([myself.selectedKey isEqualToString:key]) {
                        myself.selectedCell = cell;
                        [myself selectCell:cell];
                    }
                }];
                [row setSelectionHandlerBlock:^(UITableViewCell *cell) {
                    [myself deselectCell:myself.selectedCell];
                    myself.selectedCell = cell;
                    myself.selectedKey = cell.textLabel.text;
                    [myself selectCell:cell];                    
                }];
            }];
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.completionHandler) {
        self.completionHandler(self.selectedKey);
    }
    [super viewWillDisappear:animated];
}

- (void)selectCell:(UITableViewCell *)cell
{
    cell.textLabel.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)deselectCell:(UITableViewCell *)cell
{
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
