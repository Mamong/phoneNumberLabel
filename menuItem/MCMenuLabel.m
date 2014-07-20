//
//  MCMenuLabel.m
//  menuItem
//
//  Created by Marco on 14-7-18.
//  Copyright (c) 2014年 easytone. All rights reserved.
//

#import "MCMenuLabel.h"
#define VALID_NUMBER_CHARS @"0123456789*+#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

@implementation MCMenuLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


// default is NO
- (BOOL)canBecomeFirstResponder{
    return YES;
}


//implement for copy behaviour
-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

//implement for paste behaviour
- (void)paste:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSString *resultString = [self smartTranslation:pboard.string];
    self.text = resultString;
#ifdef MCDEBUG
    NSLog(@"before:%@,after:%@",@"0123456789*+#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$%^&()_-=[]{}|\\;:'\",.<>/?",[self smartTranslation:@"0123456789*+#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$%^&()_-=[]{}|\\;:'\",.<>/?"]);
#endif
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (([self.text length]>0&&action == @selector(copy:))||action == @selector(paste:)) {
        return YES;
    }
    return NO;
}


#pragma mark - utils function
- (NSString *)smartTranslation:(NSString *)string
{
    NSString *filter =  [[string componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:VALID_NUMBER_CHARS] invertedSet]] componentsJoinedByString:@""];
    NSMutableString *mapper = [NSMutableString string];
    for (int i = 0; i < [filter length]; i++) {
        unichar curChar = [filter characterAtIndex:i];
        if ( curChar >= '0' && curChar <= '9') {
            [mapper appendString:[NSString stringWithFormat:@"%C",curChar]];
        }else if (curChar == '*' || curChar == '+'|| curChar == '#'){
            [mapper appendString:[NSString stringWithFormat:@"%C",curChar]];
        }else{
            int distance = 0;
            if (curChar >= 'A' && curChar <= 'Z'){
                distance = curChar - 'A';
                
            }else if (curChar >= 'a' && curChar <= 'z'){
                distance = curChar - 'a';
            }else
                continue;//protect
            int map = distance / 3;
            if (distance == 18 || distance == 21) {
                map += 1;
            }else{
                map += 2;
            }
            if (map > 9) {
                map = 9;
            }
            [mapper appendString:[NSString stringWithFormat:@"%d",map]];
        }
    }
    return mapper;
}


@end
