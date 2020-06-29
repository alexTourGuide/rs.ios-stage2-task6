//
//  UIColor+RequiredColors.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/19/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "UIColor+RequiredColors.h"

@implementation UIColor (RequiredColors)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)requiredBlackColor {
    return [UIColor colorWithHexString:@"#101010"];
}

+ (UIColor *)requiredWhiteColor {
    return [UIColor colorWithHexString:@"#FFFFFF"];
}

+ (UIColor *)requiredRedColor {
    return [UIColor colorWithHexString:@"#EE686A"];
}

+ (UIColor *)requiredBlueColor {
    return [UIColor colorWithHexString:@"#29C2D1"];
}

+ (UIColor *)requiredGreenColor {
    return [UIColor colorWithHexString:@"#34C1A1"];
}

+ (UIColor *)requiredYellowColor {
    return [UIColor colorWithHexString:@"#F9CC78"];
}

+ (UIColor *)requiredGrayColor{
    return [UIColor colorWithHexString:@"#707070"];
}

+ (UIColor *)requiredYellowHighlightedColor{
    return [UIColor colorWithHexString:@"#FDF4E3"];
}

@end
