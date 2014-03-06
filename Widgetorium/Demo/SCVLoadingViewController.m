//
//  SCVLoadingViewController.m
//  Widgetorium
//
//  Created by Seba on 3/6/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "SCVLoadingViewController.h"
#import "SCVLoadingScreen.h"

@interface SCVLoadingViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SCVLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideLoadingIndicator {
    [[SCVLoadingScreen sharedInstance] hide];
}

- (IBAction)showLoadingIndicator:(id)sender {
    
    [[SCVLoadingScreen sharedInstance] show];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideLoadingIndicator) userInfo:nil repeats:NO];
    
}

@end
