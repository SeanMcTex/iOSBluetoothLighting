//
//  BeanViewController.m
//  iOSBluetoothLighting
//
//  Created by Sean McMains on 2/24/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "BeanViewController.h"

@interface BeanViewController () <PTDBeanDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (strong) UIColor *color;

@end

@implementation BeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *activityString = [NSString stringWithFormat:@"Connected to: %@", self.bean.name];
    self.activityLabel.text = activityString;
    [self.activityIndicator startAnimating];
    
    self.color = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSwitch:(UISwitch*)sender {
    self.isLightOn = sender.on;
    [self sendUpdateToBean];
}

- (IBAction)didChangeColor:(HRColorMapView *)sender {
    self.color = sender.color;
    [self sendUpdateToBean];
}

#pragma mark - Communication

- (void)sendUpdateToBean {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    Byte redByte = floor( red * 255 );
    Byte greenByte = floor( green * 255 );
    Byte blueByte = floor( blue * 255 );
    
    Byte dataArray[4];
    dataArray[0] = switchValue;
    dataArray[1] = redByte;
    dataArray[2] = greenByte;
    dataArray[3] = blueByte;
    
    NSData *payload = [NSData dataWithBytes:dataArray length:sizeof(dataArray)];
    [self.bean setScratchBank:1 data:payload];
}


@end
