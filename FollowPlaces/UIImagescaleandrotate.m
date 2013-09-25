//
//  UIImagescaleandrotate.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 22/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"
#import "UIImagescaleandrotate.h"

@implementation UIImage (Scaleandrotate)


- (UIImage *)scaleAndRotateImage: (UIImagePickerControllerSourceType) sourceType
{
    
    int width = self.size.width;
    int height = self.size.height;
    CGSize size = CGSizeMake(width, height);
    
    CGRect imageRect;
    
    if(self.imageOrientation==UIImageOrientationUp
       || self.imageOrientation==UIImageOrientationDown)
    {
        imageRect = CGRectMake(0, 0, width, height);
    }
    else
    {
        imageRect = CGRectMake(0, 0, height, width);
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if(self.imageOrientation==UIImageOrientationLeft)
    {
        CGContextRotateCTM(context, M_PI / 2);
        CGContextTranslateCTM(context, 0, -width);
    }
    else if(self.imageOrientation==UIImageOrientationRight)
    {
        CGContextRotateCTM(context, - M_PI / 2);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
        if(self.imageOrientation==UIImageOrientationUp)
    
        //DO NOTHING
        //if(sourceType == UIImagePickerControllerSourceTypeCamera)
        {
//            CGContextRotateCTM(context, - M_PI / 2);
//            CGContextTranslateCTM(context, 0, 0);
//            CGContextTranslateCTM(context, width, height);
//            CGContextRotateCTM(context, M_PI/2);
        }
    else if(self.imageOrientation==UIImageOrientationDown)
    {
        CGContextTranslateCTM(context, width, height);
        CGContextRotateCTM(context, M_PI);
    }
    
    CGContextDrawImage(context, imageRect, self.CGImage);
    CGContextRestoreGState(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (img);
}

@end

