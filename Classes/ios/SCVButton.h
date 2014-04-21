//
//  SCVButton.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 21/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCVButtonStyle) {
    /// Normal button: Image on left, Text on right
    SCVButtonStyleLeftImage = 0,
    /// Image on top, Text on bottom
    SCVButtonStyleTopImage  = 1
};

@interface SCVButton : UIButton

@property (nonatomic, assign) SCVButtonStyle buttonStyle;

@end
