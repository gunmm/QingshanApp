//
//  Utils.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

@interface Utils : NSObject


+ (void)setImageWithImageView:(UIImageView *)imageView withUrl:(NSString *)imageUrl;


+ (void)backToLogin;

+ (NSString *)getServer;

+ (NSString *)md5:(NSString *)str;

+ (BOOL) isEmpty:(NSString *)string;

+ (UIColor *)getColorByRGB:(NSString *)RGB;

+ (NSString *)getCurrentTime;

/**
 将字符串把给定的分隔符转换为回车换行
 **/
+ (NSString *)format:(NSString *)content with:(NSString *)seperator;

/**
 *  格式化时间
 *
 *  @param date      日期
 *  @param formatStr 格式字符串 
 *
 *  @return 格式化后日期
 */
+ (NSString *)formatDate:(NSDate *)date format:(NSString *)formatStr;
/**
 格式化日期输出"yyyy-MM-dd HH:mm:ss"格式字符串

 @param date 日期
 @return 日期字符串
 */
+ (NSString *)formatDate:(NSDate *)date;

/**
 *  @param phoneNumber phone number
 *
 *  @return whether the number is a tel number
 */
+ (BOOL)correctTel:(NSString *)phoneNumber;

/**
 *  根据分隔符分割字符串，并获取制定位置的结果
 *
 *  @param text      <#text description#>
 *  @param seperator <#seperator description#>
 *  @param index     <#index description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)text:(NSString *)text seperator:(NSString *)seperator index:(NSInteger)index;


/**
 *  字符串是否包含子字符串
 *
 *  @param text      text
 *  @param subString substring
 *
 *  @return result
 */
+ (BOOL)text:(NSString *)text contains:(NSString *)subString;

/**
 *  根据字体计算文本的长度
 *
 *  @param text     <#text description#>
 *  @param fontSize <#fontSize description#>
 *
 *  @return <#return value description#>
 */
+ (CGSize)getAttributeSizeWithText:(NSString *)text fontSize:(NSInteger)fontSize;


/**
 *  图片转换为base64
 *
 *  @param image image
 *
 *  @return base64 code
 */
+ (NSString *)image2Base64:(UIImage *)image;

@end


#endif /* Utils_h */
