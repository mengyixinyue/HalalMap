//
//  NSDataAdditions.m
//  TestFont
//
//  Created by 李军 on 13-4-10.
//  Copyright (c) 2013年 李军. All rights reserved.
//

#import "NSDataAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Extends)

- (NSString*)md5Hash
{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], [self length], result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}
- (NSString *)bsUtf8String
{
    //处理NSData中非法utf-8字节
    NSData *data = self;
    char aa[] = {'A','A','A','A','A','A'};
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length]){
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        //printf("%d", buffer&0x80);
        if((buffer & 0x80) == 0){
            loc++;
            continue;
        }else if((buffer & 0xE0) == 0xC0){
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80){
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这1个字符替换为AA
            [md replaceBytesInRange:NSMakeRange(loc  , 1) withBytes:aa length:1];
            loc++;
            continue;

        }else if((buffer & 0xF0) == 0xE0){
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80){
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80){
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符替换为A
            [md replaceBytesInRange:NSMakeRange(loc , 1) withBytes:aa length:1];
            loc++;
            continue;

        }else{
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    //NSLog(@" new data =>%@", md);
    return [[[NSString alloc] initWithData:md encoding:NSUTF8StringEncoding] autorelease];
}

@end
