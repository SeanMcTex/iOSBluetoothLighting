//
//  BeanBrowserController.m
//  iOSBluetoothLighting
//
//  Created by Sean McMains on 2/23/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "BeanBrowserController.h"
#import "BeanViewController.h"
#import <PTDBeanManager.h>

@interface BeanBrowserController () <PTDBeanManagerDelegate>

@property (nonatomic, strong) PTDBeanManager *beanManager;
@property (strong) PTDBean *currentBean;

@property (strong) NSMutableArray *beanArray;

@end

@implementation BeanBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    // call will fail if we don't give Bluetooth a bit of time to spin up
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSError *error;
        if ( self.currentBean != nil ) {
            [self.beanManager disconnectBean:self.currentBean error:nil];
            self.currentBean = nil;
        }
        self.beanArray = [NSMutableArray array];
        [self.tableView reloadData];

        [self.beanManager startScanningForBeans_error:&error];
        NSLog(@"Error: %@", error );
        
    });
}

#pragma mark - Bean Manager Delegate Methods

-(void)beanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)bean error:(NSError *)error {
    [self.beanArray addObject:bean];
    [self.tableView reloadData];
}

-(void)beanManager:(PTDBeanManager *)beanManager didConnectBean:(PTDBean *)bean error:(NSError *)error {
    [self performSegueWithIdentifier:@"showBeanSegue" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.beanArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beanCell" forIndexPath:indexPath];

    PTDBean *bean = [self.beanArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:bean.name];

    return cell;
}


#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PTDBean *bean = [self.beanArray objectAtIndex:indexPath.row];
    [self.beanManager connectToBean:bean error:nil];
    NSLog(@"Connecting to bean: %@", bean.name);
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    PTDBean *bean = [self.beanArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    BeanViewController *beanViewController = [segue destinationViewController];
    beanViewController.bean = bean;
}


@end
