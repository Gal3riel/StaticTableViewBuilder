//
//  STableViewController.m
//  StaticTableView
//
//  Created by Suen Gabriel on 3/20/13.
//  Copyright (c) 2013 Gabriel. All rights reserved.
//

#import "STableViewController.h"
#import <objc/runtime.h>

@interface STableViewController ()

@end

@implementation STableViewController {
    NSMutableArray *_sections;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _sections = [NSMutableArray array];
    }
    return self;
}

- (void)addSection:(void (^)(SSection *section))continuation
{
    SSection *section = [SSection new];
    [_sections addObject:section];
    if (continuation) continuation(section);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self sections][section] rows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SRow *row = [[self sections][indexPath.section] rows][indexPath.row];
        if (row.configurationBlock) row.configurationBlock(cell);
        if (self.appearenceConfigurationBlock) self.appearenceConfigurationBlock(cell);
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SRow *row = [[self sections][indexPath.section] rows][indexPath.row];
    if (row.selectionHandlerBlock) row.selectionHandlerBlock(cell);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[self sections][section] headerView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[self sections][section] footerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *view = [[self sections][section] headerView];
    if (view) return view.bounds.size.height;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    UIView *view = [[self sections][section] footerView];
    if (view) return view.bounds.size.height;
    return 0;
}

@end

#pragma mark - Back Storage Implementation

@implementation SRow

@end


@implementation SSection {
    NSMutableArray *_rows;
}

- (id)init
{
    self = [super init];
    if (self) {
        _rows = [NSMutableArray array];
    }
    return self;
}

- (void)addRow:(void (^)(SRow *))continuation
{
    SRow *row = [SRow new];
    [_rows addObject:row];
    if (continuation) continuation(row);
}

@end

#pragma mark - Helpers Implementation

@interface UIControlEventWrapper : NSObject

@property (nonatomic, assign) UIControlEvents controlEvent;
@property (nonatomic, copy) void (^eventHandler) (id sender, UIEvent *event);

- (void)sender:(id)sender forEvent:(UIEvent *)event;

@end

@implementation UIControlEventWrapper

- (void)sender:(id)sender forEvent:(UIEvent *)event
{
    if (self.eventHandler) {
        self.eventHandler(sender, event);
    }
}

@end

@implementation UIControl (StaticTableViewBuilder)

static char eventWrapperKey;

- (NSMutableArray *)eventWrappers
{
    NSMutableArray *eventWrappers = objc_getAssociatedObject(self, &eventWrapperKey);
    if (!eventWrappers) {
        eventWrappers = [NSMutableArray array];
        objc_setAssociatedObject(self, &eventWrapperKey, eventWrappers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return eventWrappers;
}

- (void)addEventHandler:(void (^)(id, UIEvent *))handler forControlEvent:(UIControlEvents)controlEvent
{
    UIControlEventWrapper *wrapper = [[UIControlEventWrapper alloc] init];
    wrapper.eventHandler = handler;
    wrapper.controlEvent = controlEvent;
    [self addTarget:wrapper action:@selector(sender:forEvent:) forControlEvents:controlEvent];
    [self.eventWrappers addObject:wrapper];
}

- (void)removeEventHandlerForControlEvent:(UIControlEvents)controlEvent
{
    __block typeof(self) myself = self;
    [self.eventWrappers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((UIControlEventWrapper *)obj).controlEvent == controlEvent) {
            [myself.eventWrappers removeObject:obj];
        }
    }];
}

@end

@implementation UILabel (StaticTableViewBuilder)

+ (UIView *)headerLabelWithText:(NSString *)text
{
    UIView *headerLabelContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 8.0f, 280.0f, 0.0f)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17.0];
    headerLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:77.0f/255.0f blue:99.0f/255.0f alpha:1.0f];
    headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
    headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.numberOfLines = 1;
    headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerLabel.text = text;
    [headerLabel sizeToFit];
    headerLabelContainerView.frame = CGRectInset(headerLabel.frame, -20, -8);
    [headerLabelContainerView addSubview:headerLabel];
    return headerLabelContainerView;
}

+ (UIView *)footerLabelWithText:(NSString *)text
{
    UIView *footerLabelContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 280.0f, 0.0f)];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.font = [UIFont systemFontOfSize:15.0];
    footerLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:77.0f/255.0f blue:99.0f/255.0f alpha:1.0f];
    footerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
    footerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.numberOfLines = 0;
    footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    footerLabel.text = text;
    [footerLabel sizeToFit];
    footerLabelContainerView.frame = CGRectInset(footerLabel.frame, -20, -10);
    [footerLabelContainerView addSubview:footerLabel];
    return footerLabelContainerView;
}
@end

@implementation UITextField (StaticTableViewBuilder)

+ (UITextField *)textFieldForCell
{
    UITextField *textField = [[UITextField alloc] initWithFrame:(CGRect){{120.0f, 11.0f}, {190.0f, 21.0f}}];
    textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    return textField;
}

@end
