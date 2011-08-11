//
//  FeedTableCell.m
//  NewsBlur
//
//  Created by Samuel Clay on 7/18/11.
//  Copyright 2011 NewsBlur. All rights reserved.
//

#import "FeedTableCell.h"
#import "ABTableViewCell.h"
#import "UIView+TKCategory.h"

#define UIColorFromRGB(rgbValue) [UIColor \
        colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static UIFont *textFont = nil;
static UIFont *indicatorFont = nil;
static UIColor *indicatorWhiteColor = nil;
static UIColor *indicatorBlackColor = nil;
static UIColor *positiveBackgroundColor = nil;
static UIColor *neutralBackgroundColor = nil;
static UIColor *negativeBackgroundColor = nil;
static CGFloat *psColors = nil;
@implementation FeedTableCell

@synthesize feedTitle;
@synthesize feedFavicon;
@synthesize positiveCount = _positiveCount;
@synthesize neutralCount = _neutralCount;
@synthesize negativeCount = _negativeCount;
@synthesize positiveCountStr;
@synthesize neutralCountStr;
@synthesize negativeCountStr;

+ (void) initialize{
	if(self == [FeedTableCell class])
	{
		textFont = [[UIFont boldSystemFontOfSize:18] retain];
		indicatorFont = [[UIFont boldSystemFontOfSize:12] retain];
		indicatorWhiteColor = [[UIColor whiteColor] retain];
		indicatorBlackColor = [[UIColor blackColor] retain];
        
        UIColor *ps = UIColorFromRGB(0x3B7613);
        UIColor *nt = UIColorFromRGB(0xF9C72A);
        UIColor *ng = UIColorFromRGB(0xCC2A2E);
		positiveBackgroundColor = [ps retain];
		neutralBackgroundColor = [nt retain];
		negativeBackgroundColor = [ng retain];
        UIColor *psGrad = UIColorFromRGB(0x559F4D);
//        UIColor *ntGrad = UIColorFromRGB(0xE4AB00);
//        UIColor *ngGrad = UIColorFromRGB(0x9B181B);
        const CGFloat* psTop = CGColorGetComponents(ps.CGColor);
        const CGFloat* psBot = CGColorGetComponents(psGrad.CGColor);
        CGFloat psGradient[] = {
            psTop[0], psTop[1], psTop[2], psTop[3],
            psBot[0], psBot[1], psBot[2], psBot[3]
        };
        psColors = psGradient;
        
	}
}

- (void)dealloc {
    [feedTitle release];
    [feedFavicon release];
    [super dealloc];
}

- (void) setPositiveCount:(int)ps {    
	if (ps == _positiveCount) return;
    
	if (ps > 99 && _positiveCount < 100) {
		[indicatorFont release];
		indicatorFont = [[UIFont boldSystemFontOfSize:10.0] retain];
	} else if (ps < 100 && _positiveCount > 99) {
		[indicatorFont release];
		indicatorFont = [[UIFont boldSystemFontOfSize:12.0] retain];
	}
	_positiveCount = ps;
	_positiveCountStr = [[NSString stringWithFormat:@"%d", ps] retain];
	[self setNeedsDisplay];
}

- (void) setNeutralCount:(int)nt {    
	if (nt == _neutralCount) return;
    
	if (nt > 99 && _neutralCount < 100) {
		[indicatorFont release];
		indicatorFont = [[UIFont boldSystemFontOfSize:10.0] retain];
	} else if (nt < 100 && _neutralCount > 99) {
		[indicatorFont release];
		indicatorFont = [[UIFont boldSystemFontOfSize:12.0] retain];
	}
	_neutralCount = nt;
	_neutralCountStr = [[NSString stringWithFormat:@"%d", nt] retain];
	[self setNeedsDisplay];
}

- (void) setNegativeCount:(int)ng {    
	if (ng == _negativeCount) return;
    
	if (ng > 99 && _negativeCount < 100) {
		[indicatorFont release];
		indicatorFont = [[UIFont boldSystemFontOfSize:10.0] retain];
	} else if (ng < 100 && _negativeCount > 99) {
		[indicatorFont release];
		indicatorFont = [[UIFont boldSystemFontOfSize:12.0] retain];
	}
	_negativeCount = ng;
	_negativeCountStr = [[NSString stringWithFormat:@"%d", ng] retain];
	[self setNeedsDisplay];
}


- (void) drawContentView:(CGRect)r highlighted:(BOOL)highlighted {
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = self.selected || self.highlighted ? [UIColor clearColor] : [UIColor whiteColor];
	UIColor *textColor = self.selected || self.highlighted ? [UIColor whiteColor] : [UIColor blackColor];
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	
	CGRect rect = CGRectInset(r, 12, 12);
	rect.size.width -= 25;
	
    int psWidth = _positiveCount == 0 ? 0 : _positiveCount < 10 ? 
                    14 : _positiveCount < 100 ? 20 : 26;
    int ntWidth = _neutralCount  == 0 ? 0 : _neutralCount < 10 ? 
                    14 : _neutralCount  < 100 ? 20 : 26;
    int ngWidth = _negativeCount == 0 ? 0 : _negativeCount < 10 ? 
                    14 : _negativeCount < 100 ? 20 : 26;
    
    int psOffset = _positiveCount == 0 ? 0 : _positiveCount < 10 ? 
                    -6 : _positiveCount < 100 ? 0 : 6;
    int ntOffset = _neutralCount  == 0 ? 0 : _neutralCount < 10 ? 
                    -6 : _neutralCount  < 100 ? 0 : 6;
    int ngOffset = _negativeCount == 0 ? 0 : _negativeCount < 10 ? 
                    -6 : _negativeCount < 100 ? 0 : 6;
    
    int psPadding = _positiveCount == 0 ? 0 : 2;
    int ntPadding = _neutralCount  == 0 ? 0 : 2;
    
	if(_positiveCount > 0){		
		[positiveBackgroundColor set];
		CGRect rr = CGRectMake(rect.size.width + rect.origin.x - psOffset, 8, psWidth, 18);
        [UIView drawLinearGradientInRect:rr colors:psColors];
		[UIView drawRoundRectangleInRect:rr withRadius:5];
		
		[indicatorWhiteColor set];
        
        CGSize size = [_positiveCountStr sizeWithFont:indicatorFont];   
        float x_pos = (rr.size.width - size.width) / 2; 
        float y_pos = (rr.size.height - size.height) /2; 
        [_positiveCountStr drawAtPoint:CGPointMake(rr.origin.x + x_pos, rr.origin.y + y_pos) withFont:indicatorFont];
    }
	if(_neutralCount > 0){		
		[neutralBackgroundColor set];
		CGRect rr = CGRectMake(rect.size.width + rect.origin.x - psWidth - psPadding - ntOffset, 8, ntWidth, 18);
		[UIView drawRoundRectangleInRect:rr withRadius:5];
//        [UIView drawLinearGradientInRect:rr colors:ntColors];
		
		[indicatorBlackColor set];
        CGSize size = [_neutralCountStr sizeWithFont:indicatorFont];   
        float x_pos = (rr.size.width - size.width) / 2; 
        float y_pos = (rr.size.height - size.height) /2; 
        [_neutralCountStr drawAtPoint:CGPointMake(rr.origin.x + x_pos, rr.origin.y + y_pos) withFont:indicatorFont];     
	}
	if(_negativeCount > 0){		
		[negativeBackgroundColor set];
		CGRect rr = CGRectMake(rect.size.width + rect.origin.x - psWidth - psPadding - ntWidth - ntPadding - ngOffset, 8, ngWidth, 18);
		[UIView drawRoundRectangleInRect:rr withRadius:5];
//        [UIView drawLinearGradientInRect:rr colors:ngColors];
		
		[indicatorWhiteColor set];
        CGSize size = [_negativeCountStr sizeWithFont:indicatorFont];   
        float x_pos = (rr.size.width - size.width) / 2; 
        float y_pos = (rr.size.height - size.height) /2; 
        [_negativeCountStr drawAtPoint:CGPointMake(rr.origin.x + x_pos, rr.origin.y + y_pos) withFont:indicatorFont];    
	}
	
	
}


@end
