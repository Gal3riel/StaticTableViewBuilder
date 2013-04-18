Static Table View Builder
=========================

Introduction
------------
A cozy way to build static table view like settings.app

Usage
-----
* add the StaticTableViewBuilder folder to your project
* create a view controller which is a subclass of the `STableViewController`
* in `viewDidLoad` method, write your static table view like this



		- (void)viewDidLoad
		{
		    [super viewDidLoad];
		
		    self.title = @"Settings";
		    		    
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
		}
		
* You can also use convenience controllers that provide functions like single selection and reorder.

