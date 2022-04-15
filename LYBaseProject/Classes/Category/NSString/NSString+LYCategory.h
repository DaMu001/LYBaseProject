//
//  NSString+LYCategory.h
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LYCategory)
// 😀😉😌😰😂 Emoji start
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
/** 去掉 表情符号 可能漏了一些 */
- (NSString *)disableEmoji;
// 😀😉😌😰😂 Emoji end

/** 去空格 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; */
@property (nonatomic, copy, readonly) NSString *delBlank;

/** 去空格 stringByReplacingOccurrencesOfString:@" " withString:@"" */
@property (nonatomic, copy, readonly) NSString *delSpace;

/**  长时间戳对应的NSDate */
@property (nonatomic, strong, readonly) NSDate *date;

/** YYYY-MM-dd 对应的NSDate */
@property (nonatomic, strong, readonly) NSDate *date__YMd;

/** YYYY.MM.dd 对应的NSDate */
@property (nonatomic, strong, readonly) NSDate *date__YMd_Dot;

/** YYYY-MM-dd HH:mm:ss对应的NSDate */
@property (nonatomic, strong, readonly) NSDate *date__YMdHMS;

/** 转为 Data */
@property (nonatomic, copy, readonly) NSData *data;

/** 转为 base64string后的Data */
@property (nonatomic, copy, readonly) NSData *base64Data;

/** 转为 base64String */
@property (nonatomic, copy, readonly) NSString *base64Str;

/** 解 base64str 为 Str 解不了就返回原始的数值 */
@property (nonatomic, copy, readonly) NSString *decodeBase64;

/** 解 为字典 if 有 */
@property (nonatomic, strong, readonly) NSDictionary *jsonDic;

/** 解 为数组 if 有 */
@property (nonatomic, strong, readonly) NSArray *jsonArr;

/** 按字符串的，逗号分割为数组 */
@property (nonatomic, strong, readonly) NSArray *combinArr;

/** 32位MD5加密 */
@property (nonatomic, copy, readonly) NSString *MD5;
/** SHA1加密 */
@property (nonatomic, copy, readonly) NSString *SHA1;

/** URLencode */
@property (nonatomic, copy, readonly) NSString *encodeString;
/** URLdecode */
@property (nonatomic, copy, readonly) NSString *decodeString;

#pragma mark - function😂
/** 银行卡字符插入空格 */
- (NSString *)bankStrInsertSpace;
/** 适合的高度 默认 font 宽  */
- (CGFloat)heightWithFont:(NSInteger)font w:(CGFloat)w;

/** 适合的宽度 默认 font 高  */
- (CGFloat)widthWithFont:(NSInteger)font h:(CGFloat)h;

/** 根据字体大小与最大宽度 返回对应的size*/
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
/** 计算富(有间距)文本的NSString高度 */
- (CGFloat)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW lineSpacing:(NSInteger)lineSpacing;
/** 根据字体大小 返回对应的size*/
- (CGSize)sizeWithFont:(UIFont *)font;

/** 是否包含对应字符 */
- (BOOL)containStr:(NSString *)subString;

/** 拼上字符串 */
- (NSString *)addStr:(NSString *)string;

/** 拼上int字符串 */
- (NSString *)addInt:(int)string;

/** 二维码图片 可以 再用resize>>放大一下 */
- (UIImage *)qrCode;

/** 是否中文 */
- (BOOL)isChinese;

/** 计算字符串长度 1个中文算2 个字符 */
- (int)textLength;

/** 限制的最大显示长度字符 */
- (NSString *)limitMaxTextShow:(NSInteger)limit;

/** 验证邮箱是否合法 */
- (BOOL)validateEmail;

/** 验证QQ是否合法 */
- (BOOL)validateQQ;

/** 验证微信是否合法 */
- (BOOL)validateWechat;

/** 验证手机号是否合法 */
- (BOOL)checkPhoneNumInput;

/** 是否ASCII码 */
- (BOOL)isASCII;

/** 是含本方法定义的 “特殊字符” */
- (BOOL)isSpecialCharacter;

/** 验证是否是数字 */
- (BOOL)isNumber;

/** 是否是纯浮点数  这里也可以拆分成纯数字判断*/
- (BOOL)isFloat;

/** 验证字符串里面是否都是数字*/
- (BOOL)isPureNumber;
/** 获取UUID */
+ (NSString *)UUID;
/// 截取 后 N 位字符
- (NSString *)subToIndex:(NSInteger)index;

+ (NSString *)createTimeWithNSTimeInterval:(double)interval withFormatterStr:(NSString *)formatterStr;

- (NSString *)md5To16;

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL)isValidRegex:(NSString*)regex;
// 取出整数中的 个位数
+ (NSInteger)getUnits:(NSInteger)targetInt;
// 取出整数中的 十位数
+ (NSInteger)getTens:(NSInteger)targetInt;
/// 将 整数中的个位数. 十位数 替换为0
+ (NSInteger)replaceNumberZero:(NSInteger)targetInt;
/// 将 整数中的个位数. 十位数 百位数 替换为0
+ (NSInteger)replaceNumberThreeZero:(NSInteger)targetInt;
/// 取出整数中的前两位 999 -> 0.99
+ (NSString *)replaceNumberBothTwo:(NSInteger)targetInt;
/// 获取url中的baseURl
+ (NSString *)getUrlWithBaseUrl:(NSString *)apiUrl;
/// 取出 url 中 name 对应的 value
+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url;
//链接转字典  （参数）
- (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;
//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSInteger)totalTime isHour:(BOOL)hour;
//传入 秒  得到  xx时xx分钟xx秒
+ (NSString *)getHHMMSSFromSS:(NSInteger)totalTime;

@end

@interface NSDictionary (LYCategory)
/** 字典 转为 jsonStr */
@property (nonatomic, copy, readonly) NSString *jsonStr;

@end

@interface NSObject (LYCategory)
/// 返回 CELL的重用名.用的类名 StringName
- (NSString *)cellIdentifier;

@end


