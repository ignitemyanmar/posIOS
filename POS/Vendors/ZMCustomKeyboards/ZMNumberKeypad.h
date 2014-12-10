//
//  ZMNumberKeypad.h
//  POS
//
//  Created by Zune Moe on 3/24/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMNumberKeypadDelegate
- (void)numberkeyWasPressed;
@end

@interface ZMNumberKeypad : UIView

@property (strong) id<UITextInput> textView;
@property (weak, nonatomic) id<ZMNumberKeypadDelegate> delegate;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberKeys;
- (IBAction)numberPressed:(id)sender;
- (IBAction)returnPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;

@end
