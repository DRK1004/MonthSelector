//
//  ViewController.h
//  MonthSelectorDemo
//
//  Created by Ravikant Dubey on 3/12/14.
//  Copyright (c) 2014 RKD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthSelector.h"


@interface ViewController : UIViewController<MonthSelectorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
- (IBAction)ChangeTheme:(id)sender;

@end
