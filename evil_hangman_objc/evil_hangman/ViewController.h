//
//  ViewController.h
//  evil_hangman
//
//  Created by John  Ito lee on 10/27/18.
//  Copyright © 2018 Johnito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(strong, nonatomic) UILabel *word;
@property(strong, nonatomic) UITextField *userInput;
@property(strong, nonatomic) UIButton *button;

-(void)submit;

@end

