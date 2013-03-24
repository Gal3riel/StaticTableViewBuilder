//
//  SettingsViewController.m
//  StaticTableView
//
//  Created by Suen Gabriel on 3/20/13.
//  Copyright (c) 2013 Gabriel. All rights reserved.
//

#import "SettingsViewController.h"
#import "SSingleSelectionViewController.h"
#import "SReorderableViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Settings";
    
    __weak typeof(self) myself = self;
    
    [self addSection:^(SSection *section) {
        [section setHeaderView:[UILabel headerLabelWithText:@"Basic"]];
        [section addRow:^(SRow *row) {
            [row setConfigurationBlock:^(UITableViewCell *cell) {
                cell.textLabel.text = @"Key";
                cell.detailTextLabel.text = @"Value";
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }];
        }];
     }];
    [self addSection:^(SSection *section) {
        [section setHeaderView:[UILabel headerLabelWithText:@"Controls"]];
        [section addRow:^(SRow *row) {
            [row setConfigurationBlock:^(UITableViewCell *cell) {
                cell.textLabel.text = @"Slider";
                UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 80, 0)];
                slider.minimumValue = 0; slider.maximumValue = 12;
                [slider addEventHandler:^(id sender, UIEvent *event) {
                    UISlider *s = sender;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)s.value];
                } forControlEvent:UIControlEventValueChanged];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
                cell.accessoryView = slider;
            }];
        }];
        [section addRow:^(SRow *row) {
            [row setConfigurationBlock:^(UITableViewCell *cell) {
                cell.textLabel.text = @"Switch";
                UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 0)];
                [switcher addEventHandler:^(id sender, UIEvent *event) {
                    UISwitch *s = sender;
                    cell.detailTextLabel.text = s.on? @"On" : @"Off";
                } forControlEvent:UIControlEventValueChanged];
                cell.detailTextLabel.text = switcher.on? @"On" : @"Off";
                cell.accessoryView = switcher;
            }];
        }];
        [section addRow:^(SRow *row) {
            [row setConfigurationBlock:^(UITableViewCell *cell) {
                cell.textLabel.text = @"TextField";
                UITextField *textField = [UITextField textFieldForCell];
                textField.placeholder = @"Placeholder";
                [cell.contentView addSubview:textField];                
            }];
        }];
        [section setFooterView:[UILabel footerLabelWithText:@"Support variety kinds of controls "]];
    }];
    
    [self addSection:^(SSection *section) {
        [section setHeaderView:[UILabel headerLabelWithText:@"Convenience Controllers"]];
        [section addRow:^(SRow *row) {
            [row setConfigurationBlock:^(UITableViewCell *cell) {
                cell.textLabel.text = @"Single Selection";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }];
            [row setSelectionHandlerBlock:^(UITableViewCell *cell) {
                [myself.navigationController pushViewController:[[SSingleSelectionViewController alloc] initWithKeys:@[@"Alpha", @"Beta", @"Gamma"] selectedKey:@"Alpha" andCompletionHandler:nil] animated:YES];
            }];
        }];
        [section addRow:^(SRow *row) {
            [row setConfigurationBlock:^(UITableViewCell *cell) {
                cell.textLabel.text = @"Reorderable";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }];
            [row setSelectionHandlerBlock:^(UITableViewCell *cell) {
                SReorderableViewController *controller = [[SReorderableViewController alloc] initWithArraysOfKeys:@[@[@"Alpha", @"Beta"], @[@"Gamma"], @[@"Theta"]] andCompletionHandler:nil];
                controller.sectionTitles = @[@"Area 50", @"Area 51", @"Area 52"];
                [myself.navigationController pushViewController:controller animated:YES];
            }];
        }];
        [section setFooterView:[UILabel footerLabelWithText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla convallis, purus id iaculis consequat."]];        
    }];

    [self setAppearenceConfigurationBlock:^(UITableViewCell *cell) {
        cell.textLabel.textColor = [UIColor colorWithWhite:0.05 alpha:1.0];
        cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }];

}

@end
