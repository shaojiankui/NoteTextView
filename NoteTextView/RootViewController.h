//
//  RootViewController.h
//  NotebookView
//
//  Created by Jakey on 15/5/31.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteTextView.h"
@interface RootViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NoteTextView *noteTextView;


@property (strong, nonatomic) NSString *fontName;
@property (weak, nonatomic) IBOutlet UISlider *fontSlider;
- (IBAction)fontSliderAction:(UISlider*)sender;
- (IBAction)randFontTouched:(id)sender;
@end
