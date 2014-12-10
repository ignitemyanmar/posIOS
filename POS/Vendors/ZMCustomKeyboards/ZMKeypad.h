//
//  ZMKeypad.h
//  POS
//
//  Created by Zune Moe on 3/25/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMKeypadDelegate
- (void)keyWasPressed;
@end

@interface ZMKeypad : UIView
@property (strong) id<UITextInput> textView;
@property (weak, nonatomic) id<ZMKeypadDelegate> delegate;

- (IBAction)characterPressed:(UIButton *)sender;
- (IBAction)deletePressed:(UIButton *)sender;
- (IBAction)altPressed:(UIButton *)sender;
- (IBAction)shiftPressed:(UIButton *)sender;
- (IBAction)returnPressed:(UIButton *)sender;
- (IBAction)dismissKeyboard:(UIButton *)sender;
@end
