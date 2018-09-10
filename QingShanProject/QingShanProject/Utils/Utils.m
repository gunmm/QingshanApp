//
//  Utils.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "Location.h"


@implementation Utils

+ (NSString *)getServer
{
    NSString *server = [[Config shareConfig] getServer];
    
    if (0 == server.length)
    {
        server = @"192.168.1.111:8080";
    }
    
    if (![server containsString:@":"])
    {
        server = [NSString stringWithFormat:@"%@:8080", server];
    }
    
    return [NSString stringWithFormat:@"http://%@/", server];
    

   
}


+ (void)setImageWithImageView:(UIImageView *)imageView withUrl:(NSString *)imageUrl {
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Utils getServer],imageUrl]] placeholderImage:[UIImage imageNamed:@"slidmain_user_head.png"] options:SDWebImageAllowInvalidSSLCertificates];
}

/**
 *  MD5加密
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (BOOL)isEmpty:(NSString *)string
{
    return !string.length;
}


+ (UIColor *)getColorByRGB:(NSString *)RGB
{
    
    if (RGB.length != 7)
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    if (![RGB hasPrefix:@"#"])
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    NSString *colorString = [RGB substringFromIndex:1];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *red = [colorString substringWithRange:range];
    
    range.location = 2;
    NSString *green = [colorString substringWithRange:range];
    
    range.location = 4;
    NSString *blue = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}


+ (NSString *)format:(NSString *)content with:(NSString *)seperator
{
    return [content stringByReplacingOccurrencesOfString:seperator withString:@"\n"];
}

+ (NSString *)formatDate:(NSDate *)date format:(NSString *)formatStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    NSString *dateStr = [format stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)formatDate:(NSDate *)date
{
    return [self formatDate:date format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)getCurrentTime
{
    NSDate *date = [[NSDate alloc] init];
    return [self formatDate:date];
}

/**
 *  手机号码是否合法
 
 */
+ (BOOL)correctTel:(NSString *)phoneNumber
{
    
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

+ (NSString*)text:(NSString *)text seperator:(NSString *)seperator index:(NSInteger)index
{
    NSArray *array = [text componentsSeparatedByString:seperator];
    if (array.count - 1 < index)
    {
        return nil;
    }
    return array[index];
}

/**
 *  字符串是否包含子字符串
 *
 *  @param text      text
 *  @param subString substring
 *
 *  @return result
 */
+ (BOOL)text:(NSString *)text contains:(NSString *)subString
{
    if (0 == subString.length)
    {
        return YES;
    }
    return [text containsString:subString];
}
 

+ (CGSize)getAttributeSizeWithText:(NSString *)text fontSize:(NSInteger)fontSize
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    return size;
}

/** 图片转换为base64码 **/
+ (NSString *)image2Base64:(UIImage *)image
{
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1);
    NSString *base64Code = [data base64EncodedStringWithOptions:0];

    return base64Code;
}


+ (void)backToLogin
{
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
    }];
    
    [[Config shareConfig] cleanUserInfo];
    [[Location sharedLocation] stopLocationService];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [delegate.window setRootViewController:controller];
    
}

@end
