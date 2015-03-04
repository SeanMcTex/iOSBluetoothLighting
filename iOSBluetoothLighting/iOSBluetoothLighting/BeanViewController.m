//
//  BeanViewController.m
//  iOSBluetoothLighting
//
//  Created by Sean McMains on 2/24/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "BeanViewController.h"

@interface BeanViewController () <PTDBeanDelegate>

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIView *colorSwatchView;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@end

@implementation BeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *activityString = [NSString stringWithFormat:@"Connected to: %@", self.bean.name];
    self.activityLabel.text = activityString;
    
    self.bean.delegate = self;
    [self.bean readScratchBank:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Controls

- (IBAction)didTapSwitch:(UISwitch*)sender {
    [self sendUpdateToBean];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    [self updateColorToSliderValues];
}

- (IBAction)sliderDragCompleted:(UISlider *)sender {
    [self sendUpdateToBean];
}

- (void)updateColorToSliderValues {
    CGFloat red = self.redSlider.value;
    CGFloat green = self.greenSlider.value;
    CGFloat blue = self.blueSlider.value;
    
    self.colorSwatchView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark - Communication

- (void)sendUpdateToBean {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self.colorSwatchView.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    Byte redByte = floor( red * 255 );
    Byte greenByte = floor( green * 255 );
    Byte blueByte = floor( blue * 255 );
    
    Byte dataArray[4];
    dataArray[0] = self.onOffSwitch.on;
    dataArray[1] = redByte;
    dataArray[2] = greenByte;
    dataArray[3] = blueByte;
    
    NSData *payload = [NSData dataWithBytes:dataArray length:sizeof(dataArray)];
    [self.bean setScratchBank:1 data:payload];
}

- (void)bean:(PTDBean *)bean didUpdateScratchBank:(NSInteger)bank data:(NSData *)data {
    Byte dataArray[4];
    [data getBytes:&dataArray length:4];
    
    BOOL isOn = dataArray[0];
    Byte redByte = dataArray[1];
    Byte greenByte = dataArray[2];
    Byte blueByte = dataArray[3];
    
    CGFloat red = redByte / 255.0;
    CGFloat green = greenByte / 255.0;
    CGFloat blue = blueByte / 255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    self.onOffSwitch.on = isOn;

    self.colorSwatchView.backgroundColor = color;

    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
}


@end
