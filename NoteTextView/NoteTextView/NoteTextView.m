//
//  NoteTextView.m
//  NoteTextView
//
//  Created by Jakey on 15/5/31.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//

#import "NoteTextView.h"
#import <objc/runtime.h>
@interface NoteTextView()<UIScrollViewDelegate, UITextViewDelegate>
{
    CAShapeLayer *_topLayerOne;
    CAShapeLayer *_topLayerTwo;

}
@property (nonatomic, weak) id<UITextViewDelegate> realDelegate;
@end

@implementation NoteTextView

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self buildView];
    }

}
- (void)buildView
{
    //[self setBackgroundColor:[UIColor whiteColor]];
    self.delegate = self;
    _topLayerOne = [self topLayerWithHeight:12];
    _topLayerTwo =  [self topLayerWithHeight:9];
    [self.layer addSublayer:_topLayerOne];
    [self.layer addSublayer:_topLayerTwo];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}
-(void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    //Get the current drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Set the line color and width
    CGContextSetStrokeColorWithColor(context, (self.rowColor?:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f]).CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    
    //Start a new Path
    CGContextBeginPath(context);
    
    //Set the line offset from the baseline.
    CGFloat baselineOffset = self.lineOffset?:6.0f;
    
    // CGFloat fontHeight = [@"A" sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
    //NSLog(@"fontHeight:%f",fontHeight);
    
//    CGFloat fontHeight = [super caretRectForPosition:[super positionFromPosition:self.beginningOfDocument offset:0]].size.height;
//    NSLog(@"fontHeight:%f",fontHeight);
//
//    NSLog(@"linheight:%f",self.font.lineHeight);
    
    //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
    NSUInteger numberOfLines = (self.contentSize.height+self.bounds.size.height) / (self.font.lineHeight);
    
    

    //iterate over numberOfLines and draw each line
    for (NSUInteger row = 1; row < numberOfLines; row++) {
       
        CGContextMoveToPoint(context, self.bounds.origin.x+10, self.font.lineHeight*row +0.5 + baselineOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width-10, self.font.lineHeight*row +0.5 + baselineOffset);
    }
    
    //Close our Path and Stroke (draw) it
    CGContextClosePath(context);
    CGContextStrokePath(context);


    
}
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    //NSLog(@"originalRect:%f",originalRect.size.height);
    return originalRect;
}

- (CAShapeLayer *)topLayerWithHeight:(CGFloat)height{
    CGFloat width = MAX(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    CGFloat overshoot = 4;
    CGFloat maxY = height-overshoot;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(-overshoot, 0)];
    CGFloat x = -overshoot;
    CGFloat y = arc4random_uniform(maxY);
    [bezierPath addLineToPoint: CGPointMake(-overshoot, y)];
    while(x < width+overshoot){
        y = MAX(maxY-3, arc4random_uniform(maxY));
        x += MAX(4.5, arc4random_uniform(12.5));
        [bezierPath addLineToPoint: CGPointMake(x, y)];
    }
    y = arc4random_uniform(maxY);
    [bezierPath addLineToPoint: CGPointMake(width+overshoot, y)];
    [bezierPath addLineToPoint: CGPointMake(width+overshoot, 0)];
    [bezierPath addLineToPoint: CGPointMake(-overshoot, 0)];
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [(self.paperColor?:[UIColor whiteColor]) CGColor];
    shapeLayer.shadowColor = [[UIColor blackColor] CGColor];
    shapeLayer.shadowOffset = CGSizeMake(0, 0);
    shapeLayer.shadowOpacity = 0.5;
    shapeLayer.shadowRadius = 1.5;
    shapeLayer.shadowPath = [bezierPath CGPath];
    shapeLayer.path = [bezierPath CGPath];
    return shapeLayer;
}
#pragma mark - setter and getter
-(void)setPaperColor:(UIColor *)paperColor{
    _paperColor = paperColor;
    _topLayerOne.fillColor = [(_paperColor?:[UIColor whiteColor]) CGColor];
    _topLayerTwo.fillColor = [(_paperColor?:[UIColor whiteColor]) CGColor];
    self.backgroundColor = _paperColor;
}
-(void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}

#pragma mark - Delegate Forwarder
- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
        // UIScrollView delegate keeps some flags that mark whether the delegate implements some methods (like scrollViewDidScroll:)
        // setting *the same* delegate doesn't recheck the flags, so it's better to simply nil the previous delegate out
        // we have to setup the realDelegate at first, since the flag check happens in setter
        [super setDelegate:nil];
        self.realDelegate = delegate != self ? delegate : nil;
        [super setDelegate:delegate ? self : nil];
    }else {
        [super setDelegate:delegate];
    }
}
- (BOOL)respondsToSelector:(SEL)selector {
    return [super respondsToSelector:selector] || [self.realDelegate respondsToSelector:selector];
}
- (id)forwardingTargetForSelector:(SEL)selector {
    id delegate = self.realDelegate;
    return [delegate respondsToSelector:selector] ? delegate : [super forwardingTargetForSelector:selector];
}
#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        return  [delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate textViewShouldEndEditing:textView];
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate textViewDidEndEditing:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate textViewDidChangeSelection:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate textViewDidChange:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        return [delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewDidScroll:scrollView];
    }
    [self setNeedsDisplay];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        return  [delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    id<UITextViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewDidScrollToTop:scrollView];
    }
}


@end
