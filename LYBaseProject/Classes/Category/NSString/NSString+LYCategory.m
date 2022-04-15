//
//  NSString+LYCategory.m
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import "NSString+LYCategory.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "LYStringMacrocDefine.h"

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (LYCategory)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/** 银行卡字符插入空格 */
- (NSString *)bankStrInsertSpace {
    NSString *finalStr = @"";
    for (int i = 0; i < self.length; i++) {
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        finalStr = [finalStr addStr:[NSString stringWithFormat:@"%@%@", s,i % 4 == 3 ? @" ": @""]];
    }
    return finalStr;
}

// 😀😉😌😰😂 Emoji start
+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar) intCode];
    }
    return string;
}

- (NSString *)emoji {
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode {
    char *charCode = (char *) stringCode.UTF8String;
    int intCode = (int) strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}

// 判断是否是 emoji表情
- (BOOL)isEmoji {
    BOOL returnValue = NO;

    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }

    return returnValue;
}
// 😀😉😌😰😂 Emoji end

/**
 *  得到文字和字体就能计算文字尺寸
 *
 *  @param font    文字的字体
 *  @param maxW     最大的宽度
 *
 *  @return 新字符串
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);

//    NSLog(@"IOS7以上的系统");
    return [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/** 计算富(有间距)文本的NSString高度 */
- (CGFloat)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW lineSpacing:(NSInteger)lineSpacing{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   font,NSFontAttributeName,
                                   paragraphStyle,NSParagraphStyleAttributeName,nil];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT)//限制最大的宽度和高度
                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                  attributes:attributeDict//传入的字体字典
                                     context:nil];
    
    return rect.size.height;
}


- (CGSize)sizeWithFont:(UIFont *)font {
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

//适合的高度 默认 systemFontOfSize:font
- (CGFloat)heightWithFont:(NSInteger)font w:(CGFloat)w {
    return [self boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:font] } context:nil].size.height;
}

//适合的宽度 默认 systemFontOfSize:font
- (CGFloat)widthWithFont:(NSInteger)font h:(CGFloat)h {
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:font] } context:nil].size.width;
}

//去空格
- (NSString *)delSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}
//去空格
- (NSString *)delBlank {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//时间戳对应的NSDate
- (NSDate *)date {
    return [NSDate dateWithTimeIntervalSince1970:self.floatValue];
}

static NSDateFormatter *YYYYMMddHHmmss;
//YYYY-MM-dd HH:mm:ss对应的NSDate
- (NSDate *)date__YMdHMS {
    if (!YYYYMMddHHmmss) {
        YYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [YYYYMMddHHmmss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [YYYYMMddHHmmss dateFromString:self];
}

static NSDateFormatter *YYYYMMdd;
//YYYY-MM-dd 对应的NSDate
- (NSDate *)date__YMd {
    if (!YYYYMMdd) {
        YYYYMMdd = [[NSDateFormatter alloc] init];
        [YYYYMMdd setDateFormat:@"yyyy-MM-dd"];
    }
    return [YYYYMMdd dateFromString:self];
}
static NSDateFormatter *YYYYMMddDot;
- (NSDate *)date__YMd_Dot {
    if (!YYYYMMddDot) {
        YYYYMMddDot = [[NSDateFormatter alloc] init];
        [YYYYMMddDot setDateFormat:@"YYYY.MM.dd"];
    }
    return [YYYYMMddDot dateFromString:self];
}

//转为 Data
- (NSData *)data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
//转为 base64string后的Data
- (NSData *)base64Data {
    return [[NSData alloc] initWithBase64EncodedString:self options:0];
}
// 转为 base64String
- (NSString *)base64Str {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
//解 base64为Str 解不了就返回原始的数值
- (NSString *)decodeBase64 {
    NSString *WillDecode = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:self options:0] encoding:NSUTF8StringEncoding];
    return (WillDecode.length != 0) ? WillDecode : self;
}
// 解 为字典 if 有
- (NSDictionary *)jsonDic {
    return [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
}
// 解 为数组 if 有
- (NSArray *)jsonArr {
    return [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
}
//按字符串的，逗号分割为数组
- (NSArray *)combinArr {
    if ([self hasSuffix:@","]) {
        return [[self substringToIndex:self.length - 1] componentsSeparatedByString:@","];
    }
    return [self componentsSeparatedByString:@","];
}

#pragma mark -

//是否包含对应字符
- (BOOL)containStr:(NSString *)subString {
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self CONTAINS %@", subString];
    return [fltr evaluateWithObject:self];
}
//拼上字符串
- (NSString *)addStr:(NSString *)string {
    if (!string || string.length == 0) {
        return self;
    }
    return [self stringByAppendingString:string];
}
- (NSString *)addInt:(int)string {
    return [self stringByAppendingString:@(string).stringValue];
}
//32位MD5加密
- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result copy];
}
//SHA1加密
- (NSString *)SHA1 {
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG) data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result copy];
}

- (NSString *)subToIndex:(NSInteger)index
{
    if (LYStringIsNull(self) || self.length < (index + 1)) {
        return @"";
    }
    return [self substringFromIndex:self.length - index - 1];
}


-(NSString*)encodeString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
-(NSString *)decodeString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)self,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}




- (UIImage *)qrCode {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    //    NSLog(@"filterAttributes:%@", filter.attributes);

    [filter setDefaults];

    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];

    CIImage *outputImage = [filter outputImage];

    CIContext *context1 = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context1 createCGImage:outputImage
                                        fromRect:[outputImage extent]];

    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1
                                   orientation:UIImageOrientationUp];

    //    CGFloat width = image.size.width * resize;
    //    CGFloat height = image.size.height * resize;
    //
    //    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    //    CGContextRef context2 = UIGraphicsGetCurrentContext();
    //    CGContextSetInterpolationQuality(context2, kCGInterpolationNone);
    //    [image drawInRect:CGRectMake(0, 0, width, height)];
    //    image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();

    CGImageRelease(cgImage);
    return image;
}

#pragma mark -

//是否中文
- (BOOL)isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
//计算字符串长度 1中文2字符
- (int)textLength {
    float number = 0.0;
    for (int index = 0; index < [self length]; index++) {
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number = number + 2;
        } else {
            number = number + 1;
        }
    }
    return ceil(number);
}
//限制最大显示长度
- (NSString *)limitMaxTextShow:(NSInteger)limit {
    NSString *Orgin = [self copy];
    for (NSInteger i = Orgin.length; i > 0; i--) {
        NSString *Get = [Orgin substringToIndex:i];
        if (Get.textLength <= limit) {
            return Get;
        }
    }
    return self;
}

//邮箱格式验证
- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:self];
}

//- (BOOL)validateAccount {
//
//}
//
//- (BOOL)validatePassword {
//
//}
//
- (BOOL)validateQQ {
    NSString *qqRegex = @"^[1-9][0-9]{4,11}$";
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qqRegex];
    return [qqTest evaluateWithObject:self];
}

- (BOOL)validateWechat {
    NSString *wxRegex = @"^[a-zA-Z][a-zA-Z0-9_-]{5,19}$";
    NSPredicate *wxTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", wxRegex];
    return [wxTest evaluateWithObject:self];;
}

//手机号格式验证
- (BOOL)checkPhoneNumInput {
    NSString *Phoneend = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([Phoneend hasPrefix:@"1"] && Phoneend.textLength == 11) {
        return YES;
    }
    return NO;
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //
    //    NSString *phoneRegex = @"^((13[0-9])|(15[0-9])|(18[0,0-9]))\\d{8}$";
    //    NSString *Phoneend = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    NSPredicate *regextestphoneRegex  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //    BOOL res1 = [regextestmobile evaluateWithObject:Phoneend];
    //    BOOL res2 = [regextestcm evaluateWithObject:Phoneend];
    //    BOOL res3 = [regextestcu evaluateWithObject:Phoneend];
    //    BOOL res4 = [regextestct evaluateWithObject:Phoneend];
    //
    //    BOOL res5 = [regextestphoneRegex evaluateWithObject:Phoneend];
    //
    //    if (res1 || res2 || res3 || res4 || res5 )
    //    {
    //        return YES;
    //    }
    //    else
    //    {
    //        return NO;
    //    }
}

//验证是否ASCII码
- (BOOL)isASCII {
    NSCharacterSet *cs;
    cs = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"
                                                             ""];
    NSRange specialrang = [self rangeOfCharacterFromSet:cs];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

//验证是含本方法定义的 “特殊字符”
- (BOOL)isSpecialCharacter {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"
                                                                              ""];
    NSRange specialrang = [self rangeOfCharacterFromSet:set];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

// 验证是否是数字
- (BOOL)isNumber {
    NSCharacterSet *cs;
    cs = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange specialrang = [self rangeOfCharacterFromSet:cs];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

// 验证字符串里面是否都是数字
- (BOOL)isPureNumber {
    NSUInteger length = [self length];
    for (float i = 0; i < length; i++) {
        // NSString * c=[mytimestr characterAtIndex:i];
        NSString *STR = [self substringWithRange:NSMakeRange(i, 1)];
        NSLog(@"%@", STR);
        if ([STR isNumber]) {
            continue;
        } else {
            return NO;
        }
    }
    return YES;
}

//是否是纯数字 这里可以有小数点
- (BOOL)isFloat {
    NSUInteger length = [self length];
    for (float i = 0; i < length; i++) {
        // NSString * c=[mytimestr characterAtIndex:i];
        NSString *STR = [self substringWithRange:NSMakeRange(i, 1)];
        NSLog(@"%@", STR);
        if ([STR isNumber] || [STR isEqualToString:@"."]) {
            continue;
        } else {
            return NO;
        }
    }
    return YES;
}

//去掉 表情符号
- (NSString *)disableEmoji {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

+ (NSString *)UUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);

    CFRelease(uuidRef);

    return (__bridge_transfer NSString *) uuid;
}

- (NSString *)replace:(NSString *)character with:(NSString *)replace {
    return [self stringByReplacingOccurrencesOfString:character withString:replace];
}

- (NSString *)replaceRegexp:(NSString *)regexp with:(NSString *)replace {
    return [self stringByReplacingOccurrencesOfString:self withString:replace options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

+ (NSString *)createTimeWithNSTimeInterval:(double)interval withFormatterStr:(NSString *)formatterStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区
    [dateFormatter setDateFormat:formatterStr];
    NSTimeInterval time = interval / 1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    return [dateFormatter stringFromDate:detaildate];
}

- (NSString *)md5To16
{
    return [self md5EncryptStr:self bateNum:16 isLowercaseStr:YES];
}

- (NSString *)md5EncryptStr:(NSString *)str bateNum:(NSInteger)bateNum isLowercaseStr:(BOOL)isLowercaseStr {
    NSString *md5Str = nil;
    const char *input = [str UTF8String];//UTF8转码
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digestStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];//直接先获取32位md5字符串,16位是通过它演化而来
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digestStr appendFormat:isLowercaseStr ? @"%02x" : @"%02X", result[i]];//%02x即小写,%02X即大写
    }
    if (bateNum == 32) {
        md5Str = digestStr;
    } else {
        md5Str = [digestStr substringWithRange:NSMakeRange(8, 16)];
    }
    return md5Str;
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL)isValidRegex:(NSString*)regex{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:self];
}


+ (NSInteger)getUnits:(NSInteger)targetInt {
    if (targetInt < 10 && targetInt > -10) {
        return 0;
    }
    NSString *strNum = [NSString stringWithFormat:@"%d", targetInt];
    NSString *resultStr = [strNum substringWithRange:NSMakeRange(strNum.length - 1, 1)];
    return [resultStr integerValue];
}
 
+ (NSInteger)getTens:(NSInteger)targetInt {
    if (targetInt < 10 && targetInt > -10) {
        return 0;
    }
    NSString *strNum = [NSString stringWithFormat:@"%d", targetInt];
    NSString *resultStr = [strNum substringWithRange:NSMakeRange(strNum.length - 2, 1)];
    return [resultStr integerValue];
}

+ (NSInteger)replaceNumberZero:(NSInteger)targetInt
{
    // 取出个位数
    if (targetInt <= 0) {
        return 0;
    }
    NSString *strNum = [NSString stringWithFormat:@"%ld", targetInt];
    strNum = [strNum stringByReplacingCharactersInRange:NSMakeRange(strNum.length - 1, 1) withString:@"0"];
    strNum = [strNum stringByReplacingCharactersInRange:NSMakeRange(strNum.length - 2, 1) withString:@"0"];
    
    return [strNum integerValue];

}

+ (NSInteger)replaceNumberThreeZero:(NSInteger)targetInt
{
    // 取出个位数
    if (targetInt <= 0) {
        return 0;
    }
    NSString *strNum = [NSString stringWithFormat:@"%ld", targetInt];
    strNum = [strNum stringByReplacingCharactersInRange:NSMakeRange(strNum.length - 1, 1) withString:@"0"];
    strNum = [strNum stringByReplacingCharactersInRange:NSMakeRange(strNum.length - 2, 1) withString:@"0"];
    strNum = [strNum stringByReplacingCharactersInRange:NSMakeRange(strNum.length - 3, 1) withString:@"0"];
    
    return [strNum integerValue];

}

+ (NSString *)replaceNumberBothTwo:(NSInteger)targetInt
{
    if (targetInt < 100) {
        return @".00";
    }
    
    NSString * a = [NSString stringWithFormat:@"%ld",targetInt];
    if (a.length > 2) {
        a = [a substringToIndex:2];
    }
    return [NSString stringWithFormat:@".%@",a];
}

+ (NSString *)getUrlWithBaseUrl:(NSString *)apiUrl
{
    NSURL *realUrl = [NSURL URLWithString:apiUrl];
    
    NSString *scheme = LYStringIsDefault(realUrl.scheme);
    if (scheme.length > 0) {
        scheme = [NSString stringWithFormat:@"%@://",scheme];
    }
    
    NSString *port = LYStringIsDefault([realUrl.port stringValue]);
    if (port.length > 0) {
        port = [NSString stringWithFormat:@":%@",port];
    }
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@%@%@",scheme,LYStringIsDefault(realUrl.host),port,LYStringIsDefault(realUrl.path)];
    
    return baseURL;
}

//name: url中的参数名称
+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url {

    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
     
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
}

//链接转字典  （参数）
-(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSInteger)totalTime isHour:(BOOL)hour
{
    NSInteger seconds = totalTime;
    if (seconds <= 0) {
        return @"00:00";
    }

    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = @"";
    if (![str_hour isEqualToString:@"00"]) {
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }else {
        format_time =  [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }
    return format_time;
}

//传入 秒  得到  xx时xx分钟xx秒
+ (NSString *)getHHMMSSFromSS:(NSInteger)totalTime
{
    NSInteger seconds = totalTime;
    if (seconds <= 0) {
        return @"00:00:00";
    }

    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
//    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];

    return format_time;
}

#pragma clang diagnostic pop
@end

@implementation NSDictionary (LYCategory)

//字典 转为 JsonStr
- (NSString *)jsonStr {
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:NULL] encoding:NSUTF8StringEncoding];
}

@end

@implementation NSObject (LYCategory)

- (NSString *)cellIdentifier
{
    return NSStringFromClass(self.class);
}

@end
