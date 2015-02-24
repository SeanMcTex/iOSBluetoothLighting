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

@end

@implementation BeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *activityString = [NSString stringWithFormat:@"Connected to: %@", self.bean.name];
    self.activityLabel.text = activityString;
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSwitch:(UISwitch*)sender {
    BOOL switchValue = sender.on;
    NSData *payload = [NSData dataWithBytes:&switchValue length:sizeof(BOOL)];
    [self.bean setScratchBank:1 data:payload];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
