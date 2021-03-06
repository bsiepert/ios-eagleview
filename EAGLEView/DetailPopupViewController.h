//
//  DetailPopupViewController.h
//  EAGLEView
//
//  Created by Jens Willy Johannsen on 25/01/14.
//  Copyright (c) 2014 Greener Pastures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLEInstance.h"
#import "EAGLEElement.h"
#import "EAGLEDrawableModuleInstance.h"

@interface DetailPopupViewController : UIViewController

@property (assign) CGSize size;
@property (strong, nonatomic) EAGLEInstance *instance;	// For schematics
@property (strong, nonatomic) EAGLEElement *element;	// For boards
@property (strong, nonatomic) EAGLEDrawableModuleInstance *moduleInstance;

- (void)showAddedToViewController:(UIViewController*)parentViewController;
- (IBAction)dismiss;

@end
