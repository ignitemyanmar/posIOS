//
//  AddNewBarcodeVC.m
//  POS
//
//  Created by Zune Moe on 3/19/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AddNewBarcodeVC.h"

#import "ZMFMDBSQLiteHelper.h"
#import "ZMKeypad.h"
#import "AllCategoryListVC.h"

@interface AddNewBarcodeVC () <UITextFieldDelegate>

@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;

@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (strong, nonatomic) IBOutlet UITextField *txtBarcode;
@property (strong, nonatomic) IBOutlet UITextField *txtItemName;
@property (strong, nonatomic) IBOutlet UITextField *txtItemPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtItemCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnSubcat;

- (IBAction)saveBarCodeOnClicked:(id)sender;

- (IBAction)Cancel:(id)sender;

@end

@implementation AddNewBarcodeVC

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
    
    ZMKeypad *keypad = [[ZMKeypad alloc] init];
    [keypad setTextView:self.txtItemName];
    self.txtItemName.delegate = self;
    
    ZMKeypad *keypad1 = [[ZMKeypad alloc] init];
    [keypad1 setTextView:self.txtItemPrice];
    self.txtItemPrice.delegate = self;
    
    ZMKeypad *keypad2 = [[ZMKeypad alloc] init];
    [keypad2 setTextView:self.txtItemCategory];
    self.txtItemCategory.delegate = self;
    
    _btnSubcat.layer.borderColor = [[UIColor grayColor] CGColor];
    _btnSubcat.layer.borderWidth = 1.5f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectSubCat:) name:@"didSelectSubCat" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    AllCategoryListVC* catvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
    catvc.isCategoryLoad = NO;
}

- (void)didSelectSubCat:(NSNotification *)noti
{
    NSString* strSubcat = (NSString*)noti.object;
    [_btnSubcat setTitle:strSubcat forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}


- (IBAction)saveBarCodeOnClicked:(id)sender
{
    if (_txtBarcode.text.length > 0 && _txtItemName.text.length > 0 && _txtItemPrice.text.length > 0 && _btnSubcat.titleLabel.text.length > 0)
    {
        NSNumber* itemPrice = @([_txtItemPrice.text doubleValue]);
        
        self.db = [ZMFMDBSQLiteHelper new];
        //6930193401015
        NSDictionary *itemDictionary = @{@"itemId": _txtBarcode.text,
                                         @"itemName": _txtItemName.text,
                                         @"itemPrice": itemPrice,
                                         @"itemCategory": _btnSubcat.titleLabel.text};
        
        Item *item = [[Item alloc] initWithDictionary:itemDictionary error:nil];
       
        [self.db createItemTable];
        [self.db insertItem:item];
        
        _txtBarcode.text = @"";
        _txtItemCategory.text = @"";
        _txtItemName.text = @"";
        _txtItemPrice.text = @"";
        
        [_txtBarcode becomeFirstResponder];
        NSArray* arr = [_db getAllItem];
        NSLog(@"All Item : %@",arr);
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:@"All item information are required to add a new item." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
