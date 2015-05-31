//
//  RootViewController.m
//  NotebookView
//
//  Created by Jakey on 15/5/31.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.noteTextView.rowColor = [UIColor redColor];
    self.noteTextView.paperColor = [UIColor whiteColor];
    self.noteTextView.font = [UIFont systemFontOfSize:30.0];
//    self.noteTextView.lineOffset = 16;
}



- (IBAction)randFontTouched:(id)sender{
    NSMutableArray *fontNames = [NSMutableArray array];
    for(NSString *familyName in [UIFont familyNames]){
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]){
            [fontNames addObject:fontName];
        }
    }
    self.fontName = fontNames[arc4random_uniform((u_int32_t)[fontNames count])];
    self.noteTextView.font = [UIFont fontWithName:self.fontName size:round([self.fontSlider value])];
    NSLog(@"%@", self.fontName);
     NSLog(@"pointSize:%f, lineHeight:%f,descender: %f, ascender:%f, xHeight:%f", self.noteTextView.font.pointSize, self.noteTextView.font.lineHeight, self.noteTextView.font.descender, self.noteTextView.font.ascender, self.noteTextView.font.xHeight);
}

- (IBAction)fontSliderAction:(UISlider*)sender{
    self.noteTextView.font = [UIFont fontWithName:self.fontName size:round([sender value])];
}


-(void)textViewDidChange:(UITextView *)textView{

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.noteTextView resignFirstResponder];
}

@end
