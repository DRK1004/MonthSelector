//
//  MonthSelector.h
//  MonthSelectorDemo
//
//  Created by Ravikant Dubey on 3/12/14.
//  Copyright (c) 2014 RKD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Delegate for month Selector
@protocol MonthSelectorDelegate <NSObject>
-(void) didSelectMonth:(NSInteger)month inYear:(NSInteger)year;
@end


@interface MonthSelector : UIView
/**
 * A constructor that initializes the MonthSelector object with the vertical location. Calls the constructor [init] with
 * view.bounds as the parameter. User can also call other constructors like : -init, -initWithFrame, but it should be avoided
 * for better results.
 * The width of component is set to device screen width as default. The height of component is set to 80 for iPad and 50 for
 * iPhone as default.
 *
 * @param verticalPosition The vertical position is the y point from which the object will be drawn on view.
 */
- (id) initWithVerticalPosition: (CGFloat) verticalPosition;
/**
 * The delegate object.
 */
@property (nonatomic, weak) id delegate;

/**
 * Color for the control.
 * The previous and next year tabs will take the exact color with gloss effect.
 * The current year tab will take the theme color with alpha set to 0.6.
 * Defaults to lightGrayColor.
 */
@property (strong, nonatomic) UIColor *themeColor;

/**
 * Color for the highlighted text.
 * Defaults to blueColor.
 */
@property (strong, nonatomic) UIColor *highlightFontColor;

/**
 * Color for month text string.
 * Defaults to black color.
 */
@property (strong, nonatomic) UIColor *monthFontColor;

/**
 * Color for year text string.
 * Defaults to black color.
 */
@property (strong, nonatomic) UIColor *yearFontColor;

/**
 * Fontsize for the month text string.
 * Maximum font size that can be set is 24
 * Minimum font size that can be set is 8
 * Defaults to 14 for iPad and 10 for iPhone.
 */
@property (strong, nonatomic) NSNumber *monthFontsize;

/**
 * Fontsize for the year text string.
 * Fontsize varies between 10 to 32 for best results
 * Maximum font size that can be set is 32
 * Minimum font size that can be set is 10
 * Defaults to 18 for iPad and 12 for iPhone.
 */
@property (strong, nonatomic) NSNumber *yearFontsize;

/**
 * Returns the month Name in MMM format on providing month index
 *
 * @param monthIndex. The monthIndex is the index of month whose string has to be get.
 */
-(NSString *) getMonthString:(NSInteger )monthIndex;


@end


