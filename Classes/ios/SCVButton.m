//
//  SCVButton.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 21/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "SCVButton.h"

@implementation SCVButton

- (CGSize)intrinsicContentSize
{
    switch (self.buttonStyle) {
        case SCVButtonStyleLeftImage:
            return [super intrinsicContentSize];
        case SCVButtonStyleTopImage: {
            CGSize imageSize = [self.imageView intrinsicContentSize];
            CGSize labelSize = [self.titleLabel intrinsicContentSize];
            return CGSizeMake(
                              self.contentEdgeInsets.left + MAX(self.imageEdgeInsets.left + imageSize.width + self.imageEdgeInsets.right, self.titleEdgeInsets.left + labelSize.width + self.titleEdgeInsets.right) + self.contentEdgeInsets.right,
                              self.contentEdgeInsets.top + self.imageEdgeInsets.top + imageSize.height + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top + labelSize.height + self.titleEdgeInsets.bottom + self.contentEdgeInsets.bottom);
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.buttonStyle) {
        case SCVButtonStyleTopImage: {
            UIEdgeInsets contentInsets = self.contentEdgeInsets;
            contentInsets.bottom += self.titleEdgeInsets.top + [self.titleLabel intrinsicContentSize].height + self.titleEdgeInsets.bottom;
            [self layoutView:self.imageView insets:self.imageEdgeInsets mainInsets:contentInsets];
            contentInsets = self.contentEdgeInsets;
            contentInsets.top += self.imageEdgeInsets.top + self.imageView.frame.size.height + self.imageEdgeInsets.bottom;
            [self layoutView:self.titleLabel insets:self.titleEdgeInsets mainInsets:contentInsets];
            break;
        }
        case SCVButtonStyleLeftImage:
            break;
    }
}

- (void)layoutView:(UIView *)view insets:(UIEdgeInsets)insets mainInsets:(UIEdgeInsets)mainInsets
{
    CGSize availableSize = self.bounds.size;
    availableSize.width -= mainInsets.left + insets.left + insets.right + mainInsets.right;
    availableSize.height -= mainInsets.top + insets.top + insets.bottom + mainInsets.bottom;
    CGRect frame;
    frame.size = [view sizeThatFits:availableSize];
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:
            frame.origin.x = 0;
            break;
        case UIControlContentHorizontalAlignmentCenter:
            frame.origin.x = (availableSize.width - frame.size.width) / 2.;
            break;
        case UIControlContentHorizontalAlignmentRight:
            frame.origin.x = availableSize.width - frame.size.width;
            break;
        case UIControlContentHorizontalAlignmentFill:
            frame.origin.x = 0;
            frame.size.width = availableSize.width;
            break;
    }
    switch (self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentTop:
            frame.origin.y = 0;
            break;
        case UIControlContentVerticalAlignmentCenter:
            frame.origin.y = (availableSize.height - frame.size.height) / 2.;
            break;
        case UIControlContentVerticalAlignmentBottom:
            frame.origin.y = availableSize.height - frame.size.height;
            break;
        case UIControlContentVerticalAlignmentFill:
            frame.origin.y = 0;
            frame.size.height = availableSize.height;
            break;
    }
    frame.origin.x += mainInsets.left + insets.left;
    frame.origin.y += mainInsets.top + insets.top;
    view.frame = frame;
}

@end
