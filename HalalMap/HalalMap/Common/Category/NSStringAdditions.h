//
//  NSStringAdditions.h
//  TestFont
//
//  Created by 李军 on 13-4-10.
//  Copyright (c) 2013年 李军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDataAdditions.h"


/**
 * Doxygen does not handle categories very well, so please refer to the .m file in general
 * for the documentation that is reflected on api.three20.info.
 */
@interface NSString (Extends)

+ (NSString *)generateGuid;
/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)isEmptyOrWhitespace;

/**
 * Parses a URL query string into a dictionary.
 */
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 * Compares two strings expressing software versions.
 *
 * The comparison is (except for the development version provisions noted below) lexicographic
 * string comparison. So as long as the strings being compared use consistent version formats,
 * a variety of schemes are supported. For example "3.02" < "3.03" and "3.0.2" < "3.0.3". If you
 * mix such schemes, like trying to compare "3.02" and "3.0.3", the result may not be what you
 * expect.
 *
 * Development versions are also supported by adding an "a" character and more version info after
 * it. For example "3.0a1" or "3.01a4". The way these are handled is as follows: if the parts
 * before the "a" are different, the parts after the "a" are ignored. If the parts before the "a"
 * are identical, the result of the comparison is the result of NUMERICALLY comparing the parts
 * after the "a". If the part after the "a" is empty, it is treated as if it were "0". If one
 * string has an "a" and the other does not (e.g. "3.0" and "3.0a1") the one without the "a"
 * is newer.
 *
 * Examples (?? means undefined):
 *   "3.0" = "3.0"
 *   "3.0a2" = "3.0a2"
 *   "3.0" > "2.5"
 *   "3.1" > "3.0"
 *   "3.0a1" < "3.0"
 *   "3.0a1" < "3.0a4"
 *   "3.0a2" < "3.0a19"  <-- numeric, not lexicographic
 *   "3.0a" < "3.0a1"
 *   "3.02" < "3.03"
 *   "3.0.2" < "3.0.3"
 *   "3.00" ?? "3.0"
 *   "3.02" ?? "3.0.3"
 *   "3.02" ?? "3.0.2"
 */
- (NSComparisonResult)versionStringCompare:(NSString *)other;

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;



@end


@interface NSString (URLEncode)

- (NSString *)URLEncodedString;

@end

@interface NSString(shike)

+ (NSString *)stringFromUpdateTimeString:(NSString *)timeString;
+ (NSString *)stringFromUpdateTime:(double)time;

@end


// 正则表达式
#define REGEX_decmal		@"^([+-]?)\\d*\\.\\d+$"	//浮点数
#define REGEX_decmal1		@"^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*$"	//正浮点数
#define REGEX_decmal2		@"^-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*)$"	//负浮点数
#define REGEX_decmal3		@"^-?([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0)$"	//浮点数
#define REGEX_decmal4		@"^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0$"	//非负浮点数（正浮点数 + 0）
#define REGEX_decmal5		@"^(-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*))|0?.0+|0$"	//非正浮点数（负浮点数 + 0）
#define REGEX_intege		@"^-?[1-9]\\d*$"	//整数
#define REGEX_intege1		@"^[1-9]\\d*$"	//正整数
#define REGEX_intege2		@"^-[1-9]\\d*$"	//负整数
#define REGEX_num			@"^([+-]?)\\d*\\.?\\d+$"	//数字
#define REGEX_num1			@"^[1-9]\\d*|0$"	//正数（正整数 + 0）
#define REGEX_num2			@"^-[1-9]\\d*|0$"	//负数（负整数 + 0）
#define REGEX_ascii			@"^[\\x00-\\xFF]+$"	//仅ACSII字符
#define REGEX_chinese		@"^[\\u4e00-\\u9fa5]+$"	//仅中文
#define REGEX_color			@"^[a-fA-F0-9]{6}$"	//颜色
#define REGEX_date			@"^\\d{4}(\\-|\\/|\.)\\d{1,2}\\1\\d{1,2}$"	//日期
#define REGEX_email			@"^([a-z0-9\+_\-]+)(\.[a-z0-9\+_\-]+)*@([a-z0-9\-]+\.)+[a-z]{2,6}$"	//邮件
#define REGEX_idcard		@"^[1-9]([0-9]{14}|[0-9]{17})$"	//身份证
#define REGEX_ip4			@"^(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)$"	//ip地址
#define REGEX_letter		@"^[A-Za-z]+$"	//字母
#define REGEX_letter_l		@"^[a-z]+$"	//小写字母
#define REGEX_letter_u		@"^[A-Z]+$"	//大写字母
#define REGEX_mobile		@"^[0](13|15)[0-9]{9}$"	//手机
#define REGEX_mobile1		@"^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9])[0-9]{8}"	//手机

#define REGEX_notempty		@"^\\S+$"	//非空
#define REGEX_password		@"^[A-Za-z0-9_-]+$"	//密码
#define REGEX_picture		@"(.*)\\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png|raw|tga)$"	//图片
#define REGEX_qq			@"^[1-9]*[1-9][0-9]*$"	//QQ号码
#define REGEX_rar			@"(.*)\\.(rar|zip|7zip|tgz)$"	//压缩文件
#define REGEX_tel			@"^[0-9\-()（）]{7,18}$"	//电话号码的函数(包括验证国内区号,国际区号,分机号)
#define REGEX_url			@"^http[s]?:\\/\\/([\\w-]+\\.)+[\\w-]+([\\w-./?%&=]*)?$"	//url
#define REGEX_username		@"^[A-Za-z0-9_\\-\\u4e00-\\u9fa5]+$"	//用户名
#define REGEX_deptname		@"^[A-Za-z0-9_()（）\\-\\u4e00-\\u9fa5]+$"	//单位名
#define REGEX_zipcode		@"^\\d{6}$"	//邮编
#define REGEX_realname		@"^[A-Za-z0-9\\u4e00-\\u9fa5]+$"  // 真实姓名
#define REGEX_password618		@"^[a-z,A-Z,0-9]{6,18}"  // 6-18密码

#define REGEX_mobilePhone   @"\\b(1)[34578][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b"//手机号码

@interface NSString(regex)

- (BOOL)isMatchedByRegex:(NSString *)regex;

@end

@interface NSString (space)
- (NSString *)removeSpace;
@end

@interface NSString(sizeWithFont)
- (CGSize)sizeAutoFitIOS7WithFont:(UIFont *)font;
- (CGSize)sizeAutoFitIOS7WithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeForIOS7WithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont constrainedToSize:(CGSize)size;
- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont constrainedToSize:(CGSize)size strokeWidth:(CGFloat)strokeWidth;
- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing constrainedToSize:(CGSize)size;
- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode  strokeWidth:(CGFloat)strokeWidth constrainedToSize:(CGSize)size;
- (NSMutableAttributedString *)defaultAttributedStringForFont:(UIFont *)tfont;
- (NSMutableAttributedString *)defaultAttributedStringForFont:(UIFont *)tfont strokeWidth:(CGFloat)strokeWidth;
- (NSMutableAttributedString *)defaultAttributedStringForFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing;
- (NSMutableAttributedString *)attributedStringForFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode strokeWidth:(CGFloat)strokeWidth;

@end

@interface NSString(toTenThousand)

- (NSString *)toTenThousand;

@end

@interface NSString (videoHtmlString)

- (NSString *)videoHtmlString;

@end

@interface NSString (thumbnail)

- (NSString *)thumbnail;
- (NSString *)thumbnailOfWidth:(CGFloat)width;

@end

@interface NSString (fileManager)

- (BOOL)deleteTheFile;
- (BOOL)createDirectory;

@end

@interface NSString (trim)

- (NSString *)trimWhiteSpace;
- (NSString *)trimWhiteSpaceAndNewLine;
- (NSString *)trimNewline;

@end
