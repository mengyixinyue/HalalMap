//
//  NSStringAdditions.m
//  TestFont
//
//  Created by 李军 on 13-4-10.
//  Copyright (c) 2013年 李军. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (Extends)

+ (NSString *)generateGuid
{
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString	*uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines
{
	NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	for (NSInteger i = 0; i < self.length; ++i)
    {
		unichar c = [self characterAtIndex:i];
		if (![whitespace characterIsMember:c])
        {
			return NO;
		}
	}
	return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmptyOrWhitespace
{
	return !self.length ||
	![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding
{
	NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	while (![scanner isAtEnd])
    {
		NSString* pairString = nil;
		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
		NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
		if (kvPair.count == 2)
        {
			NSString* key = [[kvPair objectAtIndex:0]
							 stringByReplacingPercentEscapesUsingEncoding:encoding];
			NSString* value = [[kvPair objectAtIndex:1]
							   stringByReplacingPercentEscapesUsingEncoding:encoding];
			[pairs setObject:value forKey:key];
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:pairs];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query
{
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [query keyEnumerator])
    {
		NSString* value = [query objectForKey:key];
		value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
		value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
		NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
		[pairs addObject:pair];
	}
	
	NSString* params = [pairs componentsJoinedByString:@"&"];
	if ([self rangeOfString:@"?"].location == NSNotFound)
    {
		return [self stringByAppendingFormat:@"?%@", params];
	}
    else
    {
		return [self stringByAppendingFormat:@"&%@", params];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)versionStringCompare:(NSString *)other
{
	NSArray *oneComponents = [self componentsSeparatedByString:@"a"];
	NSArray *twoComponents = [other componentsSeparatedByString:@"a"];
	
	// The parts before the "a"
	NSString *oneMain = [oneComponents objectAtIndex:0];
	NSString *twoMain = [twoComponents objectAtIndex:0];
	
	// If main parts are different, return that result, regardless of alpha part
	NSComparisonResult mainDiff;
	if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame)
    {
		return mainDiff;
	}
	
	// At this point the main parts are the same; just deal with alpha stuff
	// If one has an alpha part and the other doesn't, the one without is newer
	if ([oneComponents count] < [twoComponents count])
    {
		return NSOrderedDescending;
	}
    else if ([oneComponents count] > [twoComponents count])
    {
		return NSOrderedAscending;
	}
    else if ([oneComponents count] == 1)
    {
		// Neither has an alpha part, and we know the main parts are the same
		return NSOrderedSame;
	}
	
	// At this point the main parts are the same and both have alpha parts. Compare the alpha parts
	// numerically. If it's not a valid number (including empty string) it's treated as zero.
	NSNumber *oneAlpha = [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
	NSNumber *twoAlpha = [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
	return [oneAlpha compare:twoAlpha];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}



@end



@implementation NSString (URLEncode)

// Use Core Foundation method to URL-encode strings, since -stringByAddingPercentEscapesUsingEncoding:
// doesn't do a complete job. For details, see:
//   http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/
//   http://stackoverflow.com/questions/730101/how-do-i-encode-in-a-url-in-an-html-attribute-value/730427#730427
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                  (CFStringRef)self,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                  kCFStringEncodingUTF8));
    return encodedString;
}

@end

@implementation NSString(shike)

+ (NSString *)stringFromUpdateTimeString:(NSString *)timeString
{
    return [self stringFromUpdateTime:[timeString doubleValue]];
}
+ (NSString *)stringFromUpdateTime:(double)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [NSString stringWithFormat:@"%d:%02d",[date getHour],[date getMinute]];
}

@end

@implementation NSString(regex)


- (BOOL)isMatchedByRegex:(NSString *)regex
{
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [regextestcm evaluateWithObject:self];
}

@end
@implementation NSString (space)

- (NSString *)removeSpace
{
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

@end

@implementation NSString(sizeWithFont)
- (CGSize)sizeAutoFitIOS7WithFont:(UIFont *)font
{
    if (isIOS7) {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize size = [self sizeWithAttributes:tdic];
        size.width = ceilf(size.width);
        size.height = ceilf(size.height);
        return size;
    }
    return [self sizeWithFont:font];
}
- (CGSize)sizeAutoFitIOS7WithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (isIOS7) {
        return [self sizeForIOS7WithFont:font constrainedToSize:size];
    }
    return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
}

- (CGSize)sizeForIOS7WithFont:(UIFont *)tfont constrainedToSize:(CGSize)size
{
    if (!tfont) {
        return CGSizeZero;
    }
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    actualsize.width = ceilf(actualsize.width);
    actualsize.height = ceil(actualsize.height);
    return actualsize;
}
- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont constrainedToSize:(CGSize)size;
{
    if (!isIOS7) {
        return [self sizeWithFont:tfont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    if (!tfont) {
        return CGSizeZero;
    }
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[self defaultAttributesForFont:tfont] context:nil].size;
    actualsize.width = ceilf(actualsize.width);
    actualsize.height = ceil(actualsize.height);
    return actualsize;
}

- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont constrainedToSize:(CGSize)size strokeWidth:(CGFloat)strokeWidth
{
    if (!isIOS7) {
        return [self sizeWithFont:tfont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    if (!tfont) {
        return CGSizeZero;
    }
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[self defaultAttributesForFont:tfont strokeWidth:strokeWidth] context:nil].size;
    actualsize.width = ceilf(actualsize.width);
    actualsize.height = ceil(actualsize.height);
    return actualsize;
}

- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing constrainedToSize:(CGSize)size
{
    if (!isIOS7) {
        return [self sizeWithFont:tfont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    if (!tfont) {
        return CGSizeZero;
    }
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[self defaultAttributesForFont:tfont lineSpacing:lineSpacing] context:nil].size;
    actualsize.width = ceilf(actualsize.width);
    actualsize.height = ceil(actualsize.height);
    return actualsize;
}

- (CGSize)sizeForAttributedLabelWithFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode  strokeWidth:(CGFloat)strokeWidth constrainedToSize:(CGSize)size
{
    if (!isIOS7) {
        return [self sizeWithFont:tfont constrainedToSize:size lineBreakMode:lineBreakMode];
    }
    if (!tfont) {
        return CGSizeZero;
    }
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[self attributesForFont:tfont lineSpacing:lineSpacing lineBreakMode:lineBreakMode strokeWidth:strokeWidth] context:nil].size;
    actualsize.width = ceilf(actualsize.width);
    actualsize.height = ceil(actualsize.height);
    return actualsize;
}

- (NSDictionary *)defaultAttributesForFont:(UIFont *)tfont
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3;

    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,style,NSParagraphStyleAttributeName,nil];
    return tdic;
}

- (NSDictionary *)defaultAttributesForFont:(UIFont *)tfont strokeWidth:(CGFloat)strokeWidth
{
    if (isIOS5) {
        return nil;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3;
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,[NSNumber numberWithFloat:strokeWidth],NSStrokeWidthAttributeName,style,NSParagraphStyleAttributeName,nil];
    return tdic;
}

- (NSDictionary *)defaultAttributesForFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,style,NSParagraphStyleAttributeName,nil];
    return tdic;
}

- (NSDictionary *)attributesForFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode  strokeWidth:(CGFloat)strokeWidth
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    style.lineBreakMode = lineBreakMode;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,style,NSParagraphStyleAttributeName,[NSNumber numberWithFloat:strokeWidth],NSStrokeWidthAttributeName,nil];
    return tdic;
}

- (NSMutableAttributedString *)defaultAttributedStringForFont:(UIFont *)tfont
{
    NSDictionary * tdic = [self defaultAttributesForFont:tfont];
    return [[NSMutableAttributedString alloc] initWithString:self attributes:tdic];
}

- (NSMutableAttributedString *)defaultAttributedStringForFont:(UIFont *)tfont strokeWidth:(CGFloat)strokeWidth
{
    NSDictionary * tdic = [self defaultAttributesForFont:tfont strokeWidth:strokeWidth];
    return [[NSMutableAttributedString alloc] initWithString:self attributes:tdic];
}

- (NSMutableAttributedString *)defaultAttributedStringForFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing
{
    NSDictionary *tdic = [self defaultAttributesForFont:tfont lineSpacing:lineSpacing];
    return [[NSMutableAttributedString alloc] initWithString:self attributes:tdic];
}

- (NSMutableAttributedString *)attributedStringForFont:(UIFont *)tfont lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode strokeWidth:(CGFloat)strokeWidth
{
    NSDictionary *tdic = [self attributesForFont:tfont lineSpacing:lineSpacing lineBreakMode:lineBreakMode strokeWidth:strokeWidth];
    return [[NSMutableAttributedString alloc] initWithString:self attributes:tdic];
}

@end

@implementation NSString(toTenThousand)

- (NSString *)toTenThousand
{
    if (![self intValue]) {
        return @"";
    }
    else if (self.length < 5) {
        return self;
    }
    else
    {
        return [NSString stringWithFormat:@"%@.%@万",[self substringWithRange:NSMakeRange(0, 1)],[self substringWithRange:NSMakeRange(1, 2)]];
    }
}

@end

@implementation NSString (videoHtmlString)

- (NSString *)videoHtmlString
{
    //@"http://player.youku.com/embed/XNzk2ODc3MjM2"
    //http://player.youku.com/player.php/sid/XNzQxOTM5MjA0/v.swf
    NSString *temString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"index_iPhone" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    NSString *videoUrl = [[self stringByReplacingOccurrencesOfString:@"player.php/sid" withString:@"embed"] stringByReplacingOccurrencesOfString:@"/v.swf" withString:@""];
    BOOL fromYouku = [self rangeOfString:@"youku"].location != NSNotFound;
    NSString *videoString = [NSString stringWithFormat:@""
           "<p class=\"video\">"
           "<iframe src='%@' frameborder=0></iframe>"
                             "</p>", fromYouku ? videoUrl : self];
    NSString *htmlString = [NSString stringWithFormat:temString,videoString];
    return htmlString;
}

@end

@implementation NSString (thumbnail)

- (NSString *)thumbnail
{
    return [self thumbnailOfWidth:200];
}

- (NSString *)thumbnailOfWidth:(CGFloat)width
{
    if (width == 200 || width == 300 || width == 400) {
        NSInteger index = 0 ;
        for (NSInteger i = self.length - 1; i >= 0; i--) {
            NSString *cha = [self substringWithRange:NSMakeRange(i, 1)];
            if ([cha isEqualToString:@"."]) {
                index = i;
                break;
            }
        }
        NSMutableString *muStr = [NSMutableString stringWithString:self];
        if (index > 0 && index < muStr.length) {
            int wid = (int)width;
            [muStr insertString:[NSString stringWithFormat:@"_%dX%d",wid,wid] atIndex:index];
        }
        return muStr;
    }
    return self;
}
@end

@implementation NSString (fileManager)

- (BOOL)deleteTheFile
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self])
    {
        return [manager removeItemAtPath:self error:Nil];
    }
    return NO;
}

- (BOOL)createDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self])
    {
        return [manager createDirectoryAtPath:self withIntermediateDirectories:YES attributes:Nil error:nil];
    }
    return YES;
}

@end

@implementation NSString (trim)

- (NSString *)trimWhiteSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimWhiteSpaceAndNewLine
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

@end


