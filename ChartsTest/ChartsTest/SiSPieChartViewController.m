//
//  ViewController.m
//  ChartsTest
//
//  Created by Stanly Shiyanovskiy on 05.04.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSPieChartViewController.h"
#import "Charts-Swift.h"

@interface SiSPieChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet PieChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@property (strong, nonatomic) NSArray* parties;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet NSArray *options;
@property (nonatomic, strong) IBOutlet NSArray *values;

@property (nonatomic, assign) BOOL shouldHideData;

@end

@implementation SiSPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Pie Bar Chart";
    
    self.parties = @[
                @"Путин В.В.", @"Жириновский В.В.", @"Медведев Д.А.", @"Зюганов Г.А."];
    
    self.values = @[[NSNumber numberWithDouble:25],
                    [NSNumber numberWithDouble:15],
                    [NSNumber numberWithDouble:30],
                    [NSNumber numberWithDouble:30]];
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Y-Values"},
                     @{@"key": @"toggleXValues", @"label": @"Toggle X-Values"},
                     @{@"key": @"togglePercent", @"label": @"Toggle Percent"},
                     @{@"key": @"toggleHole", @"label": @"Toggle Hole"},
                     @{@"key": @"toggleIcons", @"label": @"Toggle Icons"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"spin", @"label": @"Spin"},
                     @{@"key": @"drawCenter", @"label": @"Draw CenterText"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
                     ];
    
    [self setupPieChartView:self.chartView];
    
    self.chartView.delegate = self;
    
    ChartLegend *l = self.chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 5.0;
    l.yOffset = 10.0;
    
    // entry label styling
    self.chartView.entryLabelColor = UIColor.whiteColor;
    self.chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    _sliderX.value = 4.0;
    _sliderY.value = 100.0;
    [self slidersValueChanged:nil];
    
    [self.chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setupPieChartView:(PieChartView *)chartView {
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.chartDescription.enabled = NO;
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Charts\nby GBInternship"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
                                NSForegroundColorAttributeName: UIColor.grayColor
                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(centerText.length - 15, 15)];
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
    ChartLegend *l = chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;

}

- (void)updateChartData {
    if (self.shouldHideData) {
        self.chartView.data = nil;
        return;
    }
    
    [self setDataCount:_sliderX.value range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:[self.values[i] doubleValue] label:self.parties[i % self.parties.count] icon: [UIImage imageNamed:@"icon"]]];
        NSLog(@"%@", values[i]);
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"www.somewhere1.com"];
    
    dataSet.drawIconsEnabled = NO;
    
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    self.chartView.data = data;
    [self.chartView highlightValues:nil];
}

- (IBAction)slidersValueChanged:(id)sender {
    _sliderTextX.text = [@((int)_sliderX.value) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}





@end
