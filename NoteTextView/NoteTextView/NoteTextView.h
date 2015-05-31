//
//  NoteTextView.h
//  NoteTextView
//
//  Created by Jakey on 15/5/31.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTextView : UITextView
@property (nonatomic) CGFloat lineOffset;
@property (strong, nonatomic) UIColor *rowColor;
@property (strong, nonatomic) UIColor *paperColor;
@end
