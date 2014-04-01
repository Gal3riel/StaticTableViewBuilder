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


License
-------
```
Copyright (c) 2014, Gabriel
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.
```
