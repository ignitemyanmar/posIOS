//
//  UpdateItemPriceVC.m
//  POS
//
//  Created by Macbook Pro on 4/23/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "UpdateItemPriceVC.h"

#import "ZMFMDBSQLiteHelper.h"
#import "Item.h"
#import "ZMKeypad.h"

@interface UpdateItemPriceVC () <UITextFieldDelegate>

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;

@property (strong, nonatomic) IBOutlet UITextField *txtItemBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblitemName;
@property (strong, nonatomic) IBOutlet UILabel *lblitemPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtItemNewPrice;
@property (assign, nonatomic) BOOL isItemPresent;

- (IBAction)saveItemNewPriceOnClicked:(id)sender;

@end

@implementation UpdateItemPriceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _isItemPresent = NO;
    [_txtItemBarcode addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    ZMKeypad *keypad = [[ZMKeypad alloc] init];
    [keypad setTextView:self.txtItemNewPrice];
    self.txtItemNewPrice.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveItemNewPriceOnClicked:(id)sender {
    
    if (_txtItemBarcode.text.length > 0 && _txtItemNewPrice.text.length > 0) {
        if (_isItemPresent) {
            [_db createItemTable];
            [_db updateItemPrice:_txtItemNewPrice.text.doubleValue withItemId:_txtItemBarcode.text];
            
            _txtItemBarcode.text = @"";
            _txtItemNewPrice.text =@"";
            _lblitemName.text = @"Item name";
            _lblitemPrice.text = @"Item price";
            
            [_txtItemBarcode becomeFirstResponder];

        }
    }
    else {
        if (_txtItemBarcode.text.length > 0) {
            if (_txtItemNewPrice.text.length == 0) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:@"Enter new price for item to update." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:@"Enter code for item to update." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    _db = [ZMFMDBSQLiteHelper new];
    if ([theTextField.text isEqualToString:@""]) {
        _lblitemName.text = @"Item Name";
        _lblitemPrice.text = @"Item Price";
        _isItemPresent = NO;
    }
    else {
        Item* item = [_db getItem:theTextField.text];
        if (item) {
            _lblitemName.text = item.itemName;
            _lblitemPrice.text = [NSString stringWithFormat:@"%.2f",item.itemPrice];
            _isItemPresent = YES;
        }
        else {
            _lblitemName.text = @"No item for this code";
            _lblitemPrice.text = @"No item for this code";
            _isItemPresent = NO;
        }
    }

}

@end
