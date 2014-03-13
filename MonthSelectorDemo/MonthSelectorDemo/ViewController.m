//
//  ViewController.m
//  MonthSelectorDemo
//
//  Created by Ravikant Dubey on 3/12/14.
//  Copyright (c) 2014 RKD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    MonthSelector *monthSelector;
    UILabel *label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    monthSelector = [[MonthSelector alloc] initWithVerticalPosition:100];
    
    monthSelector.delegate = self;
    [self.view addSubview:monthSelector];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ChangeTheme:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        monthSelector.monthFontsize =  [NSNumber numberWithInt:14];
        monthSelector.yearFontsize = [NSNumber numberWithInt:20];
    }else{
        monthSelector.monthFontsize =  [NSNumber numberWithInt:12];
        monthSelector.yearFontsize = [NSNumber numberWithInt:14];
    }
    monthSelector.monthFontColor = [UIColor blackColor];
    monthSelector.yearFontColor = [UIColor whiteColor];
    monthSelector.highlightFontColor = [UIColor greenColor];
    monthSelector.themeColor = [UIColor brownColor];
}

// Delegate method for month selector
-(void)didSelectMonth:(NSInteger)month inYear:(NSInteger)year
{
    NSString *monthName = [monthSelector getMonthString:month];
    
    self.lblMessage.text = [NSString stringWithFormat:@"Selected month:%@ year:%d", monthName,year ];
}
@end

