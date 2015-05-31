//
//  AppDelegate.h
//  NotebookView
//
//  Created by Jakey on 15/5/31.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rooViewController;
+(AppDelegate*)APP;
@end
