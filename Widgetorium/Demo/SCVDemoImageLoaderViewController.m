//
//  SCVDemoImageLoaderViewController.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 03/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "SCVDemoImageLoaderViewController.h"
#import "UIImageView+ImageLoader.h"
#import "SCVURLImageCache.h"

@interface SCVDemoImageLoaderViewController ()

@property (nonatomic, strong) NSArray *urlStrings;

@end

@implementation SCVDemoImageLoaderViewController

- (id)init {
    return [self initWithNibName:@"SCVDemoImageLoaderViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [[SCVURLImageCache sharedInstance] removeCachedImagesOlderThan:[NSDate dateWithTimeIntervalSinceNow:-60.]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demoImages" ofType:@"plist"];
    self.urlStrings = [NSArray arrayWithContentsOfFile:path];
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCVDemoImageLoaderCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imageView = (id)cell.contentView.subviews[0];
    NSString *urlString = self.urlStrings[(int)(drand48() * self.urlStrings.count)];
    NSURL *url = [NSURL URLWithString:urlString];
    [imageView loadImageWithURL:url activityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

@end
