//
//  MonthSelector.m
//  MonthSelectorDemo
//
//  Created by Ravikant Dubey on 3/12/14.
//  Copyright (c) 2014 RKD. All rights reserved.
//

#import "MonthSelector.h"

#define BorderPadding 1
#define ShadowPadding 2

#define MonthFontSize_MAX  24
#define MonthFontSize_MIN  8
#define YearFontSize_MAX 32
#define YearFontSize_MIN 10

#define HighlightMonthFontSize_IPad 18
#define HighlightMonthFontSize_IPhone 10
	
#define HighlightYearFontSize_IPad 14
#define HighlightYearFontSize_IPhone 9

#define ViewHeight_Ipad 80
#define ViewHeight_Iphone 45

@interface MonthSelector()
{
    int currentMonth;
    int currentYear;
}
@property (assign) CGFloat verticalPos;
@property (assign) CGRect selfFrame;
@property (assign) CGRect previousYearRect;
@property (assign) CGRect nextYearRect;
@property (assign) CGRect currentYearRect;
@property (assign) CGRect highlightMonthRect;
@property (strong, nonatomic) NSMutableArray *monthRectArr;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

- (void)setYear:(int)year;
- (void)setMonth:(int)month;
@end

@implementation MonthSelector


#pragma mark - Initializations

-(id)init
{
    _selfFrame = CGRectMake(0, _verticalPos, [[UIScreen mainScreen] bounds].size.width,ViewHeight_Ipad );
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _selfFrame.size.height = ViewHeight_Iphone;
    }
    
    return  [self initWithFrame:_selfFrame];;
}
- (id)initWithFrame:(CGRect)frame
{
    _selfFrame = CGRectMake(0, frame.origin.y, [[UIScreen mainScreen] bounds].size.width,frame.size.height );
    
    if (_selfFrame.size.height < ViewHeight_Iphone) {
        _selfFrame.size.height = ViewHeight_Iphone;
    }
    self = [super initWithFrame:_selfFrame];
    if (self) {
        // Initialization code
        [self setOpaque:NO];
        
        [self setDefaultValue];
        [self addLayers];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [self registerForNotifications];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    _verticalPos = 0;
    return [self init];
}

-(id) initWithVerticalPosition:(CGFloat)verticalPosition
{
    //    _selfFrame = CGRectMake(0, verticalPosition, [[UIScreen mainScreen] bounds].size.width,ViewHeight_Ipad );
    _verticalPos = verticalPosition;
    return [self init];
}

// Setting default values
-(void)setDefaultValue
{
    // default font sizes
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _monthFontsize = [NSNumber numberWithInt: 14];
        _yearFontsize = [NSNumber numberWithInt: 18];
    }else{
        _monthFontsize = [NSNumber numberWithInt: 10];
        _yearFontsize = [NSNumber numberWithInt: 12];
    }
    
    //default theme color
    _themeColor = [UIColor lightGrayColor];
    _highlightFontColor = [UIColor blueColor];
    _monthFontColor = [UIColor blackColor];
    _yearFontColor  = [UIColor blackColor];
    
    // default month/year is set to current month/year
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy"];
    [self setYear:[[formatter stringFromDate:date] intValue]];
    
    [formatter setDateFormat:@"MM"];
    [self setMonth:[[formatter stringFromDate:date] intValue]];
}

-(void)addLayers
{
    //add gradient layer
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.opacity = 1.0;
    [self.layer addSublayer:_gradientLayer];
    
    //add year textlayer for highlighting year
    CATextLayer *yearLayer = [[CATextLayer alloc] init];
    [yearLayer setFont:@"Helvetica-Bold"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        yearLayer.fontSize = HighlightYearFontSize_IPhone;
    }else{
        yearLayer.fontSize = HighlightYearFontSize_IPad;
    }
    [yearLayer setAlignmentMode:kCAAlignmentCenter];
    yearLayer.contentsScale = [[UIScreen mainScreen]scale];
    
    [_gradientLayer addSublayer:yearLayer];
    
    //add month textlayer for highlighting month
    CATextLayer *monthLayer = [[CATextLayer alloc] init];
    [monthLayer setFont:@"Helvetica-Bold"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        monthLayer.fontSize = HighlightMonthFontSize_IPhone;
    }else{
        monthLayer.fontSize = HighlightMonthFontSize_IPad;
    }
    [monthLayer setAlignmentMode:kCAAlignmentCenter];
    monthLayer.contentsScale = [[UIScreen mainScreen]scale];
    
    [_gradientLayer  insertSublayer:monthLayer atIndex:1];
}

//validate the font sizes
-(void) validateProperties
{
    if (_monthFontsize.intValue > MonthFontSize_MAX) {
        _monthFontsize = [NSNumber numberWithInt: MonthFontSize_MAX];
    }else if (_monthFontsize.intValue < MonthFontSize_MIN) {
        _monthFontsize = [NSNumber numberWithInt:MonthFontSize_MIN];
    }
    
    if (_yearFontsize.intValue > YearFontSize_MAX) {
        _yearFontsize = [NSNumber numberWithInt: YearFontSize_MAX];
    }else if (_yearFontsize.intValue < YearFontSize_MIN) {
        _yearFontsize = [NSNumber numberWithInt:YearFontSize_MIN];
    }
    
}

// customise gradient layer as per the theme color
-(void) customiseGradientLayer
{
    UIColor *color = [self darkerColorForColor:_themeColor];
    UIColor *color2 = [UIColor colorWithWhite:0.80 alpha:1.0];
    _gradientLayer.colors = [NSArray arrayWithObjects:(id)color.CGColor, (id)color2.CGColor, (id)color2.CGColor,(id)color.CGColor, nil];
    _gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.45], [NSNumber numberWithFloat:0.55],[NSNumber numberWithFloat:1.0], nil];
}

// set highlight rectangle
-(void)setHighlightRect: (CGRect) rect
{
    _highlightMonthRect = CGRectMake(rect.origin.x , rect.origin.y - 3*BorderPadding, rect.size.width, rect.size.height + 6*BorderPadding );
}


- (void)dealloc {
	[self unregisterFromNotifications];
}
#pragma mark Draw methods

- (void)drawRect:(CGRect)rect
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self setContentMode:UIViewContentModeRedraw];
    [self validateProperties];
    
    //Handle Orientation
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        _selfFrame.size.width = [UIScreen mainScreen].applicationFrame.size.width;
    }else{
        _selfFrame.size.width = [UIScreen mainScreen].bounds.size.height;
        self.frame = _selfFrame;
    }
    
    // Drawing code
    CGRect frameRect = CGRectMake(BorderPadding, 0, _selfFrame.size.width - 2*BorderPadding, _selfFrame.size.height);
    [self drawFrame:frameRect];
    
    [self drawYears:currentYear];
    [self drawMonths];
    [self customiseGradientLayer];
}

-(void) drawFrame:(CGRect) rect
{
    CGContextRef cx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cx);
    
    //draw outer frame
    CGContextSetLineWidth(cx, 2.0f);
    CGContextSetStrokeColorWithColor(cx, [UIColor clearColor].CGColor);
    CGContextAddRect(cx, rect);
    
    //Draw lines
    CGContextStrokePath(cx);
    CGContextRestoreGState(cx);
}

// Drawing year tabs
-(void)drawYears:(int) year
{
    //    CGRect rect = _selfFrame;
    
    int yearWidth = 0.1 * _selfFrame.size.width;
    
    //setting year rectangles
    _previousYearRect = CGRectMake(_selfFrame.origin.x + BorderPadding, 0, yearWidth, _selfFrame.size.height-ShadowPadding);
    self.nextYearRect = CGRectMake(_selfFrame.size.width - yearWidth - BorderPadding, 0, yearWidth, _selfFrame.size.height -ShadowPadding);
    int width = _nextYearRect.origin.x - _previousYearRect.size.width ;
    int height = 0.7 * _selfFrame.size.height;
    self.currentYearRect = CGRectMake(_previousYearRect.size.width + BorderPadding, (_selfFrame.size.height - height)/2, width, height);
    
    //Draw current year frame
    [self drawRectangle:_currentYearRect withColor:[_themeColor colorWithAlphaComponent:0.6] withCurve:0.0];
    
    //Draw previous year frame
    [self drawRectangle:_previousYearRect withColor:_themeColor withCurve:6.0];
    //draw text
    [self drawString:[NSString stringWithFormat:@"%d", currentYear-1] withFont:[UIFont boldSystemFontOfSize:_yearFontsize.intValue]  Rotation:0 andColor:_yearFontColor inRect:_previousYearRect];
    
    //Draw next year frame
    [self drawRectangle:_nextYearRect withColor:_themeColor withCurve:6.0];
    //draw text
    [self drawString:[NSString stringWithFormat:@"%d", currentYear+1] withFont:[UIFont boldSystemFontOfSize:_yearFontsize.intValue] Rotation:0 andColor:_yearFontColor  inRect:_nextYearRect];
}

//drawing month tabs
-(void)drawMonths
{
    CGRect monthRect;
    monthRect.origin = CGPointMake(_currentYearRect.origin.x , _currentYearRect.origin.y );
    
    int width = _currentYearRect.size.width /12 ;
    int height =_currentYearRect.size.height;
    monthRect.size = CGSizeMake(width, height);
    _monthRectArr = [[NSMutableArray alloc]init];
    UIColor *color = [UIColor clearColor] ;
    
    for (int i = 1; i <= 12; i++) {
        
        [self drawRectangle:monthRect withColor:color withCurve:0.0];
        if (i == currentMonth) {
            [self drawSelectedMonth:monthRect];
        }
        
        [_monthRectArr addObject:[NSValue valueWithCGRect:monthRect]];
        
        //draw string in month rectangle
        [self drawString:[self getMonthString:i] withFont:[UIFont boldSystemFontOfSize:_monthFontsize.intValue ] Rotation:45 andColor:_monthFontColor inRect:monthRect];
        
        //shifting origin of month rectangle for next month
        monthRect.origin = CGPointMake(monthRect.origin.x + width , monthRect.origin.y);
    }
}

// Draw selected month with current year
-(void) drawSelectedMonth: (CGRect) rect
{
    [self setHighlightRect:rect];
    
    if (_gradientLayer.sublayers.count > 0) {
        
        CATextLayer * monthLayer = [_gradientLayer.sublayers objectAtIndex:1];
        CGRect monthRect = CGRectMake(0,_highlightMonthRect.origin.y , rect.size.width, _highlightMonthRect.size.height/2);
        [monthLayer setFrame:monthRect];
        [monthLayer setString:[NSString stringWithFormat:@"%@", [self getMonthString:currentMonth]] ];
        [monthLayer setForegroundColor:_highlightFontColor.CGColor];
        
        CATextLayer * yearLayer = [_gradientLayer.sublayers objectAtIndex:0];
        CGRect yearRect = CGRectMake(0, _highlightMonthRect.size.height/2 + 2*BorderPadding , _highlightMonthRect.size.width, _highlightMonthRect.size.height/2);
        [yearLayer setFrame:yearRect];
        [yearLayer setString:[NSString stringWithFormat:@"%d", currentYear] ];
        [yearLayer setForegroundColor:_highlightFontColor.CGColor];
    }
    _gradientLayer.frame = _highlightMonthRect;
}

// Draw rectangles for years and months
-(void)drawRectangle:(CGRect) rect withColor:(UIColor*) color withCurve:(CGFloat) radius
{
    CGContextRef cx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cx);
    
    CGMutablePathRef rectPath = [self createRoundedRectForRect:rect withRadius:radius];
    
    CGContextSetStrokeColorWithColor(cx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(cx, color.CGColor);
    
    UIColor *shadowColor = [UIColor blackColor];
    UIColor *topColor = [color  colorWithAlphaComponent:0.1];
    UIColor *bottomColor = [color colorWithAlphaComponent:1.0];
    
    if (radius > 0) {
        // add shadow to year tabs only
        CGContextSetShadowWithColor(cx, CGSizeMake(0, 2), BorderPadding, shadowColor.CGColor);
    }
    CGContextAddPath(cx, rectPath);
    CGContextFillPath(cx);
    CGContextRestoreGState(cx);
    
    if (radius > 0) {
        //add gloss effect to year tabs
        CGContextSaveGState(cx);
        CGContextAddPath(cx, rectPath);
        CGContextClip(cx);
        [self drawGlossEffectWithContext:cx Rect:rect StartColor:topColor.CGColor EndColor:bottomColor.CGColor];
        CGContextRestoreGState(cx);
    }
    if (radius == 0) {
        // add gradient to month tabs
        CGContextSaveGState(cx);
        
        UIColor * color1 = [_themeColor colorWithAlphaComponent:0.9];
        UIColor * color2 = [UIColor colorWithWhite:0.90 alpha:1.0];
        CGRect tempRect = rect;
        tempRect.size.height = rect.size.height/2;
        
        [self drawLinearGradientWithContext:cx Rect:tempRect StartColor:color1.CGColor EndColor:color2.CGColor];
        
        tempRect.origin.y   = CGRectGetMidY(rect);
        [self drawLinearGradientWithContext:cx Rect:tempRect StartColor:color2.CGColor EndColor:color1.CGColor];
        
        CGContextRestoreGState(cx);
    }
    
    CFRelease(rectPath);
}

// Drawing linear gradients in rectangles
-(void) drawLinearGradientWithContext:(CGContextRef) context Rect:( CGRect) rect StartColor:(CGColorRef) startColor EndColor:(CGColorRef) endColor
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

// Draw shining/gloss effect to rectangles
-(void) drawGlossEffectWithContext:(CGContextRef) cx Rect:( CGRect) rect StartColor:( CGColorRef) startColor EndColor:(CGColorRef) endColor
{
    [self drawLinearGradientWithContext:cx Rect:rect StartColor:startColor EndColor:endColor];
    
    UIColor * color1 = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    UIColor * color2 = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    
    [self drawLinearGradientWithContext:cx Rect:topHalf StartColor:color1.CGColor EndColor:color2.CGColor];
}

// Draw texts in center of rectangles
-(void)drawString:(NSString*) str withFont:(UIFont*)font Rotation:(NSInteger)rotation andColor:(UIColor*)color inRect:(CGRect)rect
{
    CGContextRef cx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cx);
    
    CGContextSetStrokeColorWithColor(cx, color.CGColor);
    CGContextSetFillColorWithColor(cx, color.CGColor);
    
    CGFloat fontHeight = font.pointSize;
    CGFloat yOffset = (rect.size.height - fontHeight)/2.0;
    CGRect textRect = CGRectMake(rect.origin.x, rect.origin.y + yOffset, rect.size.width, fontHeight);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone & rotation>0) {
        CGContextTranslateCTM(cx, CGRectGetMidX(textRect),CGRectGetMidY(textRect));
        CGAffineTransform transform = CGAffineTransformMakeRotation(-rotation*M_PI/180);
        CGContextConcatCTM(cx, transform);
        
        CGContextTranslateCTM(cx, -CGRectGetMidX(textRect),-CGRectGetMidY(textRect));
    }
    
    [str drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    CGContextStrokePath(cx);
    CGContextRestoreGState(cx);
}

// Drawing rounded rectangles
-(CGMutablePathRef) createRoundedRectForRect:(CGRect) rect withRadius: (CGFloat) radius
{
    CGMutablePathRef path = CGPathCreateMutable()   ;
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    
    CGPathCloseSubpath(path);
    return path;
}

// Get the darker shade of color for adding corners
- (UIColor*)darkerColorForColor:(UIColor*)color
{
    CGFloat r,g,b,a;
    //    CGColorRef colorRef = [color CGColor];
    int numComponents = CGColorGetNumberOfComponents([color CGColor]);
    const CGFloat* colorComponents = CGColorGetComponents([color CGColor]);
    switch (numComponents) {
        case 2:
            r = colorComponents[0];
            g = colorComponents[0];
            b = colorComponents[0];
            a = colorComponents[1];
            break;
        case 4:
            r = colorComponents[0];
            g = colorComponents[1];
            b = colorComponents[2];
            a = colorComponents[3];
            break;
        default:
            r = 0;
            g = 0;
            b = 0;
            a = 0;
            break;
            
    }
    //    CGColorRelease(colorRef);
    return [UIColor colorWithRed:MAX(r-0.3, 0) green:MAX(g - 0.3, 0) blue:MAX(b - 0.3, 0) alpha:a];
}


#pragma mark- Button click events
// Detect the touch on tabs
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self touchActionFor:event];
}

// Handle the touch on tabs
- (void) touchActionFor:(UIEvent* )event
{
    for (UITouch *touch in event.allTouches) {
        CGPoint location = [touch locationInView:self];
        
        if (CGRectContainsPoint(self.nextYearRect, location)) {
            currentYear++;
        }
        if (CGRectContainsPoint(self.previousYearRect, location)) {
            currentYear--;
        }
        if (CGRectContainsPoint(self.currentYearRect, location)) {
            for (int i = 0; i < _monthRectArr.count; i++) {
                CGRect temp  = [[_monthRectArr objectAtIndex:i] CGRectValue   ];
                if (CGRectContainsPoint(temp, location)) {
                    if (currentMonth != (i+1)) {
                        currentMonth = i+1;
                        [self drawSelectedMonth:temp];
                        [self didSelectMonth:currentMonth inYear:currentYear withRedraw:NO];
                    }
                    break;
                }
            }
        }
        else{
            [self didSelectMonth:currentMonth inYear:currentYear withRedraw:YES];
        }
    }
}


#pragma mark- Date methods
// Set current month
- (void)setMonth:(int)month
{
    currentMonth = month;
}

// Set current Year
- (void)setYear:(int)year
{
    currentYear = year;
}

// Get the month string from month index
-(NSString *) getMonthString:(NSInteger )monthIndex
{
    NSString *monthStr = [NSString stringWithFormat:@"%d", monthIndex];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM"];
    
    NSDate *date = [formatter dateFromString:monthStr];
    
    [formatter setDateFormat:@"MMM"];
    
    NSString *monthName = [formatter stringFromDate:date];
    return monthName;
}

#pragma mark delegate method
// Delegate method
-(void) didSelectMonth:(NSInteger)month inYear:(NSInteger)year withRedraw:(BOOL)redraw
{
    if (redraw) {
        //redraw
        [self setNeedsDisplay];
    }
    
    [self.delegate didSelectMonth:month inYear:year];
}

#pragma mark - Notifications
// Register for device orientation change notification
- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

// Unregister for device orientation change notification
- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Handler device orientation change
-(void) deviceOrientationDidChange:(NSNotification*)note
{
    [self setNeedsDisplay];
}

#pragma mark property changes
-(void) setMonthFontColor:(UIColor *)monthFontColor
{
    _monthFontColor = monthFontColor;
    [self setNeedsDisplay];
}
-(void) setYearFontColor:(UIColor *)yearFontColor
{
    _yearFontColor = yearFontColor;
    [self setNeedsDisplay];;
}
-(void) setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    [self setNeedsDisplay];
}
-(void) setHighlightFontColor:(UIColor *)highlightFontColor
{
    _highlightFontColor = highlightFontColor;
    [self setNeedsDisplay];
}
-(void) setMonthFontsize:(NSNumber *)monthFontsize
{
    _monthFontsize = monthFontsize;
    [self setNeedsDisplay];
}
-(void) setYearFontsize:(NSNumber *)yearFontsize
{
    _yearFontsize = yearFontsize;
    [self setNeedsDisplay];
}


@end

