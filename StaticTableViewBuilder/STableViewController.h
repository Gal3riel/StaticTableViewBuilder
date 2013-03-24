//
//  STableViewController.h
//  StaticTableView
//
//  Created by Suen Gabriel on 3/20/13.
//  Copyright (c) 2013 Gabriel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRow : NSObject

@property (nonatomic, copy) void (^configurationBlock) (UITableViewCell *cell);
@property (nonatomic, copy) void (^selectionHandlerBlock) (UITableViewCell *cell);

@end

@interface SSection : NSObject

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong, readonly) NSMutableArray *rows;

- (void)addRow:(void (^)(SRow *row))continuation;

@end

@interface STableViewController : UITableViewController

@property (nonatomic, copy) void (^appearenceConfigurationBlock) (UITableViewCell *cell);

@property (nonatomic, strong, readonly) NSMutableArray *sections;

- (void)addSection:(void (^)(SSection *section))continuation;

@end


#pragma mark - Helpers

@interface UIControl (StaticTableViewBuilder)

- (void)addEventHandler:(void (^)(id sender, UIEvent *event))handler
        forControlEvent:(UIControlEvents)controlEvent;

- (void)removeEventHandlerForControlEvent:(UIControlEvents)controlEvent;

@end

@interface UILabel (StaticTableViewBuilder)

+ (UIView *)headerLabelWithText:(NSString *)text;

+ (UIView *)footerLabelWithText:(NSString *)text;

@end

@interface UITextField (StaticTableViewBuilder)

+ (UITextField *)textFieldForCell;

@end

