/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIViewExt.h"


@implementation UIView (ViewGeometry)

- (CGFloat) height
{
	return self.frame.size.height;
}


- (CGFloat) width
{
	return self.frame.size.width;
}

- (CGFloat) top
{
	return self.frame.origin.y;
}


- (CGFloat) left
{
	return self.frame.origin.x;
}

- (CGFloat) bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat) right
{
	return self.frame.origin.x + self.frame.size.width;
}


@end
