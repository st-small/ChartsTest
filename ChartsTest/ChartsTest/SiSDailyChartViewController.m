//
//  SiSDailyChartViewController.m
//  ChartsTest
//
//  Created by Stanly Shiyanovskiy on 11.04.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSDailyChartViewController.h"
#import "Charts-Swift.h"

@interface SiSDailyChartViewController () <ChartViewDelegate, IChartAxisValueFormatter>

@property (strong, nonatomic) IBOutlet BarChartView* chartView;
@property (strong, nonatomic) NSArray* dates;
@property (strong, nonatomic) NSArray* ranks;

@end

@implementation SiSDailyChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Daily Bar Chart";

    self.dates = [self randomDatesArray];
    self.ranks = [self randomRank];
    
    self.chartView.delegate = self;
    self.chartView.chartDescription.enabled = NO;
    
    self.chartView.maxVisibleCount = 60;
    self.chartView.pinchZoomEnabled = YES;
    self.chartView.drawBarShadowEnabled = NO;
    self.chartView.drawGridBackgroundEnabled = NO;
    self.chartView.drawBordersEnabled = YES;
    self.chartView.borderLineWidth = 1.0;
    [self.chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0 easingOption:ChartEasingOptionEaseOutBack];
    
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.granularity = 1.0;
    xAxis.centerAxisLabelsEnabled = NO;
    xAxis.labelRotationAngle = 0;
    xAxis.valueFormatter = self;
    xAxis.drawGridLinesEnabled = NO;
    
    self.chartView.leftAxis.drawGridLinesEnabled = NO;
    self.chartView.rightAxis.drawGridLinesEnabled = NO;
    self.chartView.legend.enabled = NO;
    
    [self setDataCount:(int)(self.dates.count) range:100.0];
    
}

- (void)setDataCount:(int)count range:(double)range {
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        double val = [self.ranks[i] doubleValue];
        NSLog(@"date is: %@", self.dates[i]);
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];
    }
    
    BarChartDataSet *set1 = nil;
    if (self.chartView.data.dataSetCount > 0) {
        set1 = (BarChartDataSet *)self.chartView.data.dataSets[0];
        set1.values = yVals;
        [self.chartView.data notifyDataChanged];
        [self.chartView notifyDataSetChanged];
    } else {
        
        // add a lot of colors
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:[UIColor colorWithRed:76/255.f green:175/255.f blue:80/255.f alpha:1.f]];
        [colors addObject:[UIColor colorWithRed:205/255.f green:220/255.f blue:57/255.f alpha:1.f]];
        [colors addObject:[UIColor colorWithRed:200/255.f green:230/255.f blue:201/255.f alpha:1.f]];
        [colors addObject:[UIColor colorWithRed:189/255.f green:189/255.f blue:189/255.f alpha:1.f]];
        
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"DataSet"];
        set1.colors = colors;
        set1.drawValuesEnabled = YES;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        
        self.chartView.data = data;
        self.chartView.fitBars = YES;
    }
    
    [self.chartView setNeedsDisplay];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase*)chartView
                     entry:(ChartDataEntry*)entry
                 highlight:(ChartHighlight*)highlight {
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase*)chartView {
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - Help methods -

- (NSMutableArray*)randomDatesArray{
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < 10; i++) {
        NSUInteger rand = arc4random_uniform((int)157680000);
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:rand];
        [array addObject:date];
    }
    
    return array;
}

- (NSMutableArray*)randomRank {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < 10; i++) {
        NSUInteger j = arc4random_uniform(500);
        [array addObject:[NSNumber numberWithInteger:j]];
    }
    
    return array;
}

- (NSString*) stringFromDate:(NSDate*) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd\nMMM/''yy"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - IAxisValueFormatter - 

- (NSString*) stringForValue:(double)value axis:(ChartAxisBase *)axis {
    
    NSString* str = [self stringFromDate:self.dates[(int)value]];
    NSLog(@"string is: %@", str);
    
    
    return str;
}

@end
