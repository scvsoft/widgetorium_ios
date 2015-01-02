//
//  UIImageView+ImageLoader.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 03/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageLoader)

- (void)loadImageWithURL:(NSURL *)url
  activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle
            defaultImage:(UIImage*)defaultImage;

@end
