//
//  ZMKeypad.m
//  POS
//
//  Created by Zune Moe on 3/25/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "ZMKeypad.h"

#define kCharLabel @"ABC"
#define kAltLabel @".?123"
#define kChar @[ @"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"Z", @"X", @"C", @"V", @"B", @"N", @"M", @",", @".", @" " ]

#define kChar_alt @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"", @"", @".", @",", @"?", @"!", @"\'", @"\"", @"", @" " ]

@interface ZMKeypad ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundLayout;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keys;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *altButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shiftButtons;

@property (assign, nonatomic, getter = isShifted) BOOL shifted;
@property (assign, nonatomic, getter = isAltered) BOOL altered;
@end

@implementation ZMKeypad
@synthesize textView = _textView;

- (id)init {
	CGRect frame;
    frame = CGRectMake(0, 0, 1024, 352);
	self = [super initWithFrame:frame];	
	if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZMKeypad" owner:self options:nil];
		[[nib objectAtIndex:0] setFrame:frame];
        self = [nib objectAtIndex:0];
    }
    self.shifted = NO;
    self.altered = NO;
    
    [self loadCharactersWithArray:kChar];
    
	return self;
}

-(void)setTextView:(id<UITextInput>)textView {
	
	if ([textView isKindOfClass:[UITextView class]])
        [(UITextView *)textView setInputView:self];
    else if ([textView isKindOfClass:[UITextField class]])
        [(UITextField *)textView setInputView:self];
    
    _textView = textView;
}

-(id<UITextInput>)textView {
	return _textView;
}

-(void)loadCharactersWithArray:(NSArray *)a {
	int i = 0;
	for (UIButton *b in self.keys) {
		[b setTitle:[a objectAtIndex:i] forState:UIControlStateNormal];
		i++;
	}
}

- (IBAction)deletePressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
	[self.textView deleteBackward];
	[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification
														object:self.textView];
	if ([self.textView isKindOfClass:[UITextView class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
	else if ([self.textView isKindOfClass:[UITextField class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (IBAction)characterPressed:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
	NSString *character = [NSString stringWithString:button.titleLabel.text].lowercaseString;
	if (self.isShifted) {
        character = [NSString stringWithString:button.titleLabel.text];
    }
	[self.textView insertText:character];
	
	if ([self.textView isKindOfClass:[UITextView class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
	else if ([self.textView isKindOfClass:[UITextField class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (IBAction)altPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
	
    self.altered = !self.altered;
    self.shifted = NO;
    
	UIButton *button = (UIButton *)sender;
	
	if ([button.titleLabel.text isEqualToString:kAltLabel]) {
        [self.backgroundLayout setImage:[UIImage imageNamed:@"keypad_numbers"]];
		[self loadCharactersWithArray:kChar_alt];
		for (UIButton *b in self.altButtons) {
            [b setTitle:kCharLabel forState:UIControlStateNormal];
        }
	}
	else {
        [self.backgroundLayout setImage:[UIImage imageNamed:@"keypad_letters"]];
		[self loadCharactersWithArray:kChar];
		for (UIButton *b in self.altButtons) {
            [b setTitle:kAltLabel forState:UIControlStateNormal];
        }
	}
}

- (IBAction)shiftPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    
    if (!self.isAltered) {
        self.shifted = !self.shifted;
        if (self.isShifted) {
            [self.backgroundLayout setImage:[UIImage imageNamed:@"keypad_letters_shifted"]];
        } else {
            [self.backgroundLayout setImage:[UIImage imageNamed:@"keypad_letters"]];
        }
    }
}

- (IBAction)dismissKeyboard:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
	
	if ([self.textView isKindOfClass:[UITextView class]])
        [(UITextView *)self.textView resignFirstResponder];
	
    else if ([self.textView isKindOfClass:[UITextField class]])
        [(UITextField *)self.textView resignFirstResponder];
}

- (IBAction)returnPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
	if ([self.textView isKindOfClass:[UITextView class]]) {
        [self.textView insertText:@"\n"];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    }
	else if ([self.textView isKindOfClass:[UITextField class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
    }
}

@end
