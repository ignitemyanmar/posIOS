//
//  SaleVC.m
//  POS
//
//  Created by Zune Moe on 3/17/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "SaleVC.h"
#import "Item.h"
#import "ItemCell.h"
#import "ZMFMDBSQLiteHelper.h"
#import "PKCustomKeyboard.h"
#import "ItemCollectionViewCell.h"
#import "SaleTransaction.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "SaleVoucherVC.h"
#import "SaleVoucherCell.h"
#import "ZMKeypad.h"

@interface SaleVC () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate>
{
//    UIPopoverController* myPopoverController;
}
@property (nonatomic, strong) UIPopoverController *myPopoverController;
@property (strong, nonatomic) NSArray* shoeCategory;
@property (assign, nonatomic) BOOL isCategorySelected;
@property (strong, nonatomic) NSArray* shoeItems;
@property (strong, nonatomic) Customer* currentCustomer;
@property (assign, nonatomic) int voucherCount;
@property (assign, nonatomic) BOOL noNeedToChangeTotal;

@property (strong, nonatomic) ExistingCustomerListVC *classpop;

@property (strong, nonatomic) NSArray* discountLbls;
@property (strong, nonatomic) NSArray* discountAmt;
@property (assign, nonatomic) int currentDiscountRate;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@property (assign, nonatomic) BOOL isSubCatSelected;
@property (strong, nonatomic) NSArray* subcategoryArr;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *barcodeValueTextField;
@property (weak, nonatomic) IBOutlet UILabel *itemTotalPrice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *itemCollView;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeMode;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIView *viewCheckout;
@property (strong, nonatomic) IBOutlet UILabel *lblBeforeLeft;

@property (strong, nonatomic) IBOutlet UITextField *txtPayment;
@property (strong, nonatomic) IBOutlet UIButton *btnCustomerList;
@property (strong, nonatomic) IBOutlet UILabel *lblVNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckout;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UIView *upperBkgView;

@property (strong, nonatomic) IBOutlet UILabel *lblslipVNo;
@property (strong, nonatomic) IBOutlet UILabel *lblslipDate;
@property (strong, nonatomic) IBOutlet UITableView *tvSlipVoucher;
@property (strong, nonatomic) IBOutlet UILabel *lblSlipTotal;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tvSlipVoucherHeightConstrait;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstrait;
@property (strong, nonatomic) IBOutlet UIScrollView *upperScrollview;
@property (strong, nonatomic) IBOutlet UIView *slipContentBkgView;

@property (strong, nonatomic) NSArray* buyinglist;

@property (strong, nonatomic) IBOutlet UIButton *btnDoneUp;

@property (strong, nonatomic) IBOutlet UIButton *btnPrintUp;

@property (strong, nonatomic) NSString *documentDirectoryFilename;


- (IBAction)upperSlipViewDismiss:(id)sender;
- (IBAction)upperSlipViewPrint:(id)sender;

- (IBAction)changeMode:(id)sender;
- (IBAction)showCategory:(id)sender;
- (IBAction)deleteItems:(id)sender;
- (IBAction)btnCheckoutOnClicked:(id)sender;
- (IBAction)plusDiscount:(id)sender;
- (IBAction)minusDiscount:(id)sender;

@property (strong, nonatomic) NSArray *itemsArray;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;

@end

@implementation SaleVC

{
    double itemsTotalPrice;
}

//@synthesize myPopoverController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.db = [ZMFMDBSQLiteHelper new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemQuantityUpdated:) name:@"ItemQuantityUpated" object:nil];
    
    [_btnChangeMode setTitle:@"Change Picker Mode" forState:UIControlStateNormal];
    _itemCollView.hidden = YES;
    _btnCategory.hidden = YES;
    _isCategorySelected = NO;
    _isSubCatSelected = NO;
    
    _viewCheckout.hidden = YES;
    
    _classpop = (ExistingCustomerListVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"popovervc"];
    _classpop.delegate=self;
    
    _itemTotalPrice.text = @"0.00";
    
    [self generateVoucherNumber];
    
    [_btnCustomerList setTitle:@"Select Buyer" forState:UIControlStateNormal];
    
    _myPopoverController = [[UIPopoverController alloc] initWithContentViewController:_classpop];
    _myPopoverController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTap:) name:@"didTap" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSaleperson:) name:@"changeSaleperson" object:nil];
    
    _discountLbls = @[@"Free",@"5%",@"10%",@"20%",@"30%",@"40%"];
    _discountAmt = @[@"0",@"0.05",@"0.1",@"0.2",@"0.3",@"0.4"];
    _currentDiscountRate = 0;
    _lblDiscount.text = _discountLbls[_currentDiscountRate];
    
    
    _upperBkgView.hidden = YES;
    _upperScrollview.backgroundColor = [UIColor colorWithRed:116.0f/255.0f green:206.0f/255.0f blue:183.0f/255.0f alpha:1];
    _slipContentBkgView.layer.cornerRadius = 10;
    _upperScrollview.layer.cornerRadius = 10;
    _btnDoneUp.layer.borderWidth = 2.5;
    _btnDoneUp.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _btnDoneUp.layer.cornerRadius = 10;
    
    _btnPrintUp.layer.borderWidth = 2.5;
    _btnPrintUp.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _btnPrintUp.layer.cornerRadius = 10;
    
    ZMKeypad *keypad = [ZMKeypad new];
    [keypad setTextView:_txtPayment];
    _txtPayment.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.barcodeValueTextField becomeFirstResponder];
    
    [_db createCategoryTable];
//    _shoeCategory = [_db getItemCategories];
    _shoeCategory = [_db getAllCategory];
}

-(void)didTap:(NSNotification *)notification
{
    //Dismiss your popover here;
    if (notification.object) {
        ExistingCustomerListVC* notiObj = (ExistingCustomerListVC*)notification.object;
        _currentCustomer = notiObj.selectedCustomer;
        [_btnCustomerList setTitle:_currentCustomer.cusName forState:UIControlStateNormal];
    }

//    if ([_myPopoverController isPopoverVisible]) {
        [_myPopoverController dismissPopoverAnimated:NO];
//    }
//    [_myPopoverController dismissPopoverAnimated:YES];
    
}

- (void)changeInvoiceTVHeight
{
    int count;
    if (_buyinglist.count == 0) count = 0;
    else count = _buyinglist.count - 1;
    
    _tvSlipVoucherHeightConstrait.constant = 30+(29*count);
    _scrollViewHeightConstrait.constant = 80 + _tvSlipVoucherHeightConstrait.constant;
    if (_scrollViewHeightConstrait.constant > 460) {
        _scrollViewHeightConstrait.constant = 460;
    }
}

- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",self.documentDirectoryFilename);
}

- (UIImage *)captureView:(UIView *)view withRect:(CGRect)cellRect
{
    UIGraphicsBeginImageContextWithOptions(cellRect.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-  (void)createPdf:(UIImage *)img
{
    //a4
    CGRect pdfPageBounds = CGRectMake(0, 0, 595, 700); //
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
        [img drawAtPoint:CGPointMake(5,5)];
    } UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"MySlip.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
}


- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return  YES;
}

- (void)generateVoucherNumber
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString* str = [dateFormat stringFromDate:[NSDate date]];
    _voucherCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"voucherCount"];
    _voucherCount++;
    NSString* vStr = [NSString stringWithFormat:@"%@0%d",str,_voucherCount];
    _lblVNumber.text = vStr;

}

- (void)changeSaleperson:(NSNotification*) notification
{
    NSString* spName = (NSString*)notification.object;
    [_loginButton setTitle:spName forState:UIControlStateNormal];
    
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
//    editPopover.delegate = (id <UIPopoverControllerDelegate>)self;
}

- (void)itemQuantityUpdated:(NSNotification *)notification
{
    NSDictionary *object = notification.object;
    NSLog(@"obj: %@", object);
    NSIndexPath *indexPath = object[@"indexPath"];
    int quantity = [object[@"quantity"] intValue];
    
    NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
    NSMutableDictionary *itemDictionary = [tempItems[indexPath.row] mutableCopy];
    itemDictionary[@"quantity"] = @(quantity);
    [tempItems replaceObjectAtIndex:indexPath.row withObject:itemDictionary];
    self.itemsArray = tempItems;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    double tempTotal = 0.0;
    for (NSDictionary* dict in _itemsArray) {
        Item* itemObj = dict[@"item"];
        int itemqty = [dict[@"quantity"] intValue];
        tempTotal += itemObj.itemPrice * itemqty;
    }
    itemsTotalPrice = tempTotal;
    self.itemTotalPrice.text = [NSString stringWithFormat:@"%.2f", itemsTotalPrice];
}

#pragma mark - IBActions

- (IBAction)scanBarcode:(id)sender {
    // do the search of barcode number in itemsArray first if found increase count, if not found search in database and add to array
    // if data was found add to tableView and clear textfield and focus again for next scan
    // if data wasn't found clear textfield and focus again for next sacan, show proper error message
    BOOL newData = YES;
    if (![self.barcodeValueTextField.text isEqualToString:@""]) {
        NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
        
        for (int i = 0; i < tempItems.count; i++) {
            NSMutableDictionary *itemDictionary = [tempItems[i] mutableCopy];
            Item *item = itemDictionary[@"item"];
            if ([item.itemId rangeOfString:self.barcodeValueTextField.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
                // found item in current array
                itemsTotalPrice += item.itemPrice;
                newData = NO;
                int quantity = [itemDictionary[@"quantity"] intValue];
                quantity ++;
                itemDictionary[@"quantity"] = @(quantity);
                [tempItems replaceObjectAtIndex:i withObject:itemDictionary];
            }
        }
        if (newData) {
            // item not found, add new item to array
            Item *item = [self.db getItem:self.barcodeValueTextField.text];
            if (item) {
                itemsTotalPrice += item.itemPrice;
                NSDictionary *itemWithQuantity = @{@"item": item,
                                                   @"quantity": @1,
                                                   @"discount": @0};
                [tempItems addObject:itemWithQuantity];
            }
        }
        _noNeedToChangeTotal = YES;
        self.itemTotalPrice.text = [NSString stringWithFormat:@"%.2f", itemsTotalPrice];
        self.itemsArray = tempItems;
        [self.tableView reloadData];
        
        self.barcodeValueTextField.text = @"";
    }
}

- (IBAction)loginOut:(id)sender {
    
    if (![_loginButton.titleLabel.text isEqualToString:@"Log in"]) {
        [_loginButton setTitle:@"Log in" forState:UIControlStateNormal];
    }
}

- (IBAction)btnCheckoutOnClicked:(id)sender
{
    if ([_loginButton.titleLabel.text isEqualToString:@"Log in"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You have to log in first." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([_btnCustomerList.titleLabel.text isEqualToString:@"Select Buyer"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Please, select Buyer." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    if (_itemsArray.count > 0) {
        if (_viewCheckout.hidden == YES) {
            _viewCheckout.hidden = NO;
            
            [UIView transitionWithView:_viewCheckout
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished)
             {
             }];
            
            [_btnDelete setTitle:@"Back" forState:UIControlStateNormal];
            [_btnCheckout setTitle:@"Done" forState:UIControlStateNormal];
            
            Customer* cus = [_db getCustomer:_currentCustomer.cusName];
            
            double tempTotal = itemsTotalPrice + cus.cusCredit;
            _lblBeforeLeft.text = [NSString stringWithFormat:@"%f",tempTotal];
            
            _txtPayment.text = @"";
        }
        else {
            
            _upperBkgView.hidden = NO;
            
            _slipContentBkgView.hidden = YES;
            
            _upperBkgView.frame =  CGRectMake(self.view.frame.size.width-70, self.view.frame.size.height-70, 0, 0);
            [UIView animateWithDuration:0.25f animations:^{
                _upperBkgView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//                _upperBkgView.alpha = 1.0f;
                _slipContentBkgView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
                //Code is here
            double tempTotal = 0.0;
            for (NSDictionary* dict in _itemsArray) {
                Item* itemObj = dict[@"item"];
                int itemqty = [dict[@"quantity"] intValue];
                tempTotal += itemObj.itemPrice * itemqty;
            }
            
            _lblSlipTotal.text = [NSString stringWithFormat:@"%.2f", tempTotal];
            _lblslipVNo.text = [NSString stringWithFormat:@"# %@",_lblVNumber.text];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"dd-MM-yyyy"];
            _lblslipDate.text = [dateFormat stringFromDate:[NSDate date]];
            
            _buyinglist = [_itemsArray copy];
            
            [_tvSlipVoucher reloadData];
            
    //            _scrollView.backgroundColor = [UIColor redColor];
//            _bkgView.backgroundColor = [UIColor blueColor];

            
            _viewCheckout.hidden = YES;
            [_btnDelete setTitle:@"Delete Items" forState:UIControlStateNormal];
            [_btnCheckout setTitle:@"Check Out" forState:UIControlStateNormal];
            
            double totalLeft = [_lblBeforeLeft.text doubleValue];
            double payment = [_txtPayment.text doubleValue];
            double totalLeftAfter = totalLeft - payment;
            NSString *strLeftAfter;
            if (totalLeftAfter > 0) {
                strLeftAfter = [NSString stringWithFormat:@"%2.f",totalLeftAfter];
            }
            else {
                totalLeftAfter = 0;
                strLeftAfter = @"0.00";
            }
            //else Show Change : ....
            
            [_db updateCustomerCredit:totalLeftAfter withCustomerName:_btnCustomerList.titleLabel.text];
            

            //CREDIT INSERT
            if (_txtPayment.text.length == 0) {
                _txtPayment.text = @"0.00";
            }
            [_db createCreditTable];
            NSDictionary *dict = @{@"creditCusName": _btnCustomerList.titleLabel.text,
                                   @"creditDate": _lblslipDate.text,
                                   @"creditTotal": _lblBeforeLeft.text,
                                   @"creditPayAmt": _txtPayment.text,
                                   @"creditLeftToPayAmt": strLeftAfter};
            Credit *creditObj = [[Credit alloc] initWithDictionary:dict error:nil];
            [_db insertCredit:creditObj];
            
            for (int i = 0; i < self.itemsArray.count; i++)
            {
                //*** CHANGE VALUE OF vid
                //*** CHANGE VALUE OF cusname
                NSDictionary *tempDict = self.itemsArray[i];
                Item *item = tempDict[@"item"];
                NSString* strQty = [tempDict[@"quantity"] stringValue];
                
                double itemTotal = item.itemPrice*[tempDict[@"quantity"] intValue];
                NSString *strTotal = [NSString stringWithFormat:@"%.2f",itemTotal];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *currentdate = [dateFormat stringFromDate:[NSDate date]];
                
                NSString* allTotal = _itemTotalPrice.text;
                
                NSDictionary *saleDictionary = @{@"vid": _lblVNumber.text,
                                                 @"cusname": _btnCustomerList.titleLabel.text,
                                                 @"itemid": item.itemId,
                                                 @"qty": strQty,
                                                 @"itemtotal": strTotal,
                                                 @"vdate": currentdate,
                                                 @"total": allTotal,
                                                 @"salePerson": _loginButton.titleLabel.text
                                                 };
                SaleTransaction *sale = [[SaleTransaction alloc] initWithDictionary:saleDictionary error:nil];
                
                
                [self.db createTransactionTable];
                [self.db insertTransaction:sale];
            }
            
            [[NSUserDefaults standardUserDefaults] setInteger:_voucherCount forKey:@"voucherCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //GENERATE NEW VOUCHER NO.
            [self generateVoucherNumber];
            
            //CLEAR BUYING ITEMS & TABLE
            NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
            [tempItems removeAllObjects];
            self.itemsArray = tempItems;
            [_tableView reloadData];
            self.itemTotalPrice.text = @"0.00";
            itemsTotalPrice = 0;
        
            //    NSArray *transactionResults = [self.db getTransaction];
            
        }

    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No item to check out." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

    //            UIStoryboard *storyboard = [UIStoryboard getSaleStoryboard];
    //            SaleVoucherVC *vc = (SaleVoucherVC *)[storyboard instantiateViewControllerWithIdentifier:@"SaleVoucherVC"];
    
    //            vc.buyingList = [self.itemsArray copy];
    //            vc.voucherNo = _lblVNumber.text;
    //
    //            self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //
    //            [self presentViewController:vc animated:YES completion:nil];

    
   
}


- (IBAction)plusDiscount:(id)sender {
    
        if (_selectedIndexPath) {
            NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
            NSMutableDictionary *itemDictionary = [tempItems[_selectedIndexPath.row] mutableCopy];
            
            int indx = [itemDictionary[@"discount"] intValue];
            indx++;
            if (indx < _discountLbls.count) {
                _lblDiscount.text =  _discountLbls[indx];
                
                Item* itemObj = itemDictionary[@"item"];
                
                [_db createItemTable];
                Item* originalItem = [_db getItem:itemObj.itemId];
                
                double discountAmt = [_discountAmt[indx] doubleValue];
                double tempDouble = itemObj.itemPrice * discountAmt;
                double itemObjPrice = originalItem.itemPrice - tempDouble;
                
                NSDictionary *itemDict = @{@"itemId": itemObj.itemId,
                                           @"itemName": itemObj.itemName,
                                           @"itemPrice": @(itemObjPrice),
                                           @"itemCategory": itemObj.itemCategory
                                           };
                
                Item *item = [[Item alloc] initWithDictionary:itemDict error:nil];
                
                itemDictionary[@"item"] = item;
                itemDictionary[@"discount"] = @(indx);
                
                [tempItems replaceObjectAtIndex:_selectedIndexPath.row withObject:itemDictionary];
                self.itemsArray = tempItems;
                
                
                NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
                [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                double tempTotal = 0.0;
                for (NSDictionary* dict in _itemsArray) {
                    Item* itemObj = dict[@"item"];
                    int itemqty = [dict[@"quantity"] intValue];
                    tempTotal += itemObj.itemPrice * itemqty;
                }
                itemsTotalPrice = tempTotal;
                self.itemTotalPrice.text = [NSString stringWithFormat:@"%.2f", itemsTotalPrice];

            }
            

    }
}


- (IBAction)minusDiscount:(id)sender {
    
//    _currentDiscountRate--;
//    if (_currentDiscountRate >= 0) {
    
        
        if (_selectedIndexPath) {
            
            NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
            NSMutableDictionary *itemDictionary = [tempItems[_selectedIndexPath.row] mutableCopy];
            
            int indx = [itemDictionary[@"discount"] intValue];
            indx--;
            if (indx >= 0) {
                _lblDiscount.text =  _discountLbls[indx];
                
                Item* itemObj = itemDictionary[@"item"];
                
                [_db createItemTable];
                Item* originalItem = [_db getItem:itemObj.itemId];
                
                double discountAmt = [_discountAmt[indx] doubleValue];
                double tempDouble = itemObj.itemPrice * discountAmt;
                double itemObjPrice = originalItem.itemPrice - tempDouble;
                
                NSDictionary *itemDict = @{@"itemId": itemObj.itemId,
                                           @"itemName": itemObj.itemName,
                                           @"itemPrice": @(itemObjPrice),
                                           @"itemCategory": itemObj.itemCategory
                                           };
                
                Item *item = [[Item alloc] initWithDictionary:itemDict error:nil];
                
                itemDictionary[@"item"] = item;
                itemDictionary[@"discount"] = @(indx);
                
                [tempItems replaceObjectAtIndex:_selectedIndexPath.row withObject:itemDictionary];
                self.itemsArray = tempItems;
                
                NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
                [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                double tempTotal = 0.0;
                for (NSDictionary* dict in _itemsArray) {
                    Item* itemObj = dict[@"item"];
                    int itemqty = [dict[@"quantity"] intValue];
                    tempTotal += itemObj.itemPrice * itemqty;
                }
                itemsTotalPrice = tempTotal;
                self.itemTotalPrice.text = [NSString stringWithFormat:@"%.2f", itemsTotalPrice];
            }
           
            
            
        }

}


- (IBAction)upperSlipViewDismiss:(id)sender {
    
    
    [UIView animateWithDuration:0.25f animations:^{
        _upperBkgView.frame =  CGRectMake(self.view.frame.size.width-70, self.view.frame.size.height-70, 0, 0);
//        [sliderView setAlpha:0.0f];
        _slipContentBkgView.hidden = YES;
    } completion:^(BOOL finished) {
        _upperBkgView.hidden = YES;
    }];
}

- (IBAction)upperSlipViewPrint:(id)sender {
//    [self createPDFfromUIView:_tvSlipVoucher saveToDocumentsWithFileName:@"MyDocfromTV.pdf"];
    
//    UIImage* resultImg = [self captureView:_tvSlipVoucher withRect:CGRectMake(0, 0, _tvSlipVoucher.frame.size.width, _tvSlipVoucher.frame.size.height)]; //
//    resultImg = [self imageWithImage:resultImg scaledToSize:CGSizeMake(200, resultImg.size.height)];
//
    
    UIImage* resultImg = [self renderScrollViewToImage];
    
    //Resize while keeping aspect ration of Original Img :) :D
    UIImage *resizedImg = [UIImage imageWithCGImage:[resultImg CGImage] scale:(resultImg.scale * 2.0) orientation:(resultImg.imageOrientation)];
    
    [self createPdf:resizedImg];
    
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];

}

- (IBAction)changeMode:(id)sender
{
    _isCategorySelected = NO;
    _isSubCatSelected = NO;
    if (_itemCollView.hidden == YES) {
        _itemCollView.hidden = NO;
        [UIView transitionWithView:_itemCollView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:nil
                        completion:^(BOOL finished)
         {
         }];
        [_btnChangeMode setTitle:@"Change Scanner Mode" forState:UIControlStateNormal];
        _btnCategory.hidden = NO;
        [_itemCollView reloadData];
    }
    else {
        
        
        [UIView transitionWithView:_itemCollView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _itemCollView.hidden = YES;
                        }
                        completion:^(BOOL finished)
         {
         }];

        [_btnChangeMode setTitle:@"Change Picker Mode" forState:UIControlStateNormal];
        _btnCategory.hidden = YES;
        
    }
}

- (IBAction)showCategory:(id)sender
{
    if (_isSubCatSelected) {
        _isSubCatSelected = NO;
        _isCategorySelected = YES;
        [_btnCategory setTitle:@"All Subcategories" forState:UIControlStateNormal];
    }
    else  {
        _isCategorySelected = NO;
        
        [_btnCategory setTitle:@"All Categories" forState:UIControlStateNormal];
    }
    [_itemCollView reloadData];
}

- (IBAction)deleteItems:(id)sender
{
    if (_viewCheckout.hidden == NO) {
        
        [UIView transitionWithView:_viewCheckout
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                           _viewCheckout.hidden = YES;
                        }
                        completion:^(BOOL finished)
         {
             
         }];

        
        
        [_btnDelete setTitle:@"Delete Items" forState:UIControlStateNormal];
        [_btnCheckout setTitle:@"Check Out" forState:UIControlStateNormal];
    }
    else {
        if ([_tableView isEditing]) {
            // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
            [_tableView setEditing:NO animated:YES];
            
        }
        else {
            //Turn edit mode on
            [_tableView setEditing:YES animated:YES];
        }
    }
}

# pragma mark - Printing Helper Methods

- (UIImage *)renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_upperScrollview.contentSize);
    {
        CGPoint savedContentOffset = _upperScrollview.contentOffset;
        CGRect savedFrame = _upperScrollview.frame;
        
        _upperScrollview.contentOffset = CGPointZero;
        _upperScrollview.frame = CGRectMake(0, 0, _upperScrollview.contentSize.width, _upperScrollview.contentSize.height);
        
        [_upperScrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _upperScrollview.contentOffset = savedContentOffset;
        _upperScrollview.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
//    if (image != nil) {
//        [UIImagePNGRepresentation(image) writeToFile: @"/tmp/test.png" atomically: YES];
//        system("open /tmp/test.png");
//    }
    
    return image;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)resizeImageProportionallyIntoNewSize:(CGSize)newSize withImage:(UIImage*)img
{
    CGFloat scaleWidth = 1.0f;
    CGFloat scaleHeight = 1.0f;
    
    if (CGSizeEqualToSize(img.size, newSize) == NO) {
        
        //calculate "the longer side"
        if(img.size.width > img.size.height) {
            scaleWidth = img.size.width / img.size.height;
        } else {
            scaleHeight = img.size.height / img.size.width;
        }
    }
    
    //prepare source and target image
    UIImage *sourceImage = img;
    UIImage *newImage = nil;
    
    // Now we create a context in newSize and draw the image out of the bounds of the context to get
    // A proportionally scaled image by cutting of the image overlay
    UIGraphicsBeginImageContext(newSize);
    
    //Center image point so that on each egde is a little cutoff
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = newSize.width * scaleWidth;
    thumbnailRect.size.height = newSize.height * scaleHeight;
    thumbnailRect.origin.x = (int) (newSize.width - thumbnailRect.size.width) * 0.5;
    thumbnailRect.origin.y = (int) (newSize.height - thumbnailRect.size.height) * 0.5;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRow;
    if (tableView == _tvSlipVoucher) {
        numOfRow = _buyinglist.count;
    }
    else {
        numOfRow = _itemsArray.count;
    }
    return numOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tvSlipVoucher) {
        NSString* cellid = @"voucherCell";
        SaleVoucherCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        Item* itemObj = _buyinglist[indexPath.row][@"item"];
        int qty = [_buyinglist[indexPath.row][@"quantity"] intValue];
        double totalcost = itemObj.itemPrice * qty;
        
        cell.cellItemName.text = itemObj.itemName;
        cell.cellItemQty.text = [NSString stringWithFormat:@"%d",qty];
        cell.cellItemTotal.text = [NSString stringWithFormat:@"%.2f",totalcost];
        [self changeInvoiceTVHeight];
        return cell;

    }
    else {
        static NSString *CellIdentifier = @"Item Cell";
        ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell configureCell:self.itemsArray[indexPath.row][@"item"] quantity:[self.itemsArray[indexPath.row][@"quantity"] intValue] indexPath:indexPath];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
    
    //CHANGE TOTAL PRICE
    if (tempItems.count > 0) {
        NSMutableDictionary *itemDictionary = [tempItems[indexPath.row] mutableCopy];
        Item *item = itemDictionary[@"item"];
        int quantity = [itemDictionary[@"quantity"] intValue];
        double tempTotal = item.itemPrice * quantity;
        itemsTotalPrice -= tempTotal;
        self.itemTotalPrice.text = [NSString stringWithFormat:@"%.2f", itemsTotalPrice];
    }
    
   
    [tempItems removeObjectAtIndex:indexPath.row];
    self.itemsArray = tempItems;
    [_tableView reloadData];
    
    
    if (self.itemsArray.count == 0) {
        self.itemTotalPrice.text = @"0.00";
        itemsTotalPrice = 0;
        [_tableView setEditing:NO animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    
    NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
    NSMutableDictionary *itemDictionary = [tempItems[_selectedIndexPath.row] mutableCopy];
    
    int selectedindex = [itemDictionary[@"discount"] intValue];
    
    _lblDiscount.text = _discountLbls[selectedindex];
}

#pragma mark UICollectionViewDelegateMethods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!_isSubCatSelected) {
        return _shoeCategory.count;
    }
    if (_isCategorySelected && !_isSubCatSelected) {

        return _subcategoryArr.count;
    }
    else {
        return _shoeItems.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"collCellWithLbl";
    ItemCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (_isCategorySelected && !_isSubCatSelected) {
//        cell.cellImgView.hidden = NO;
//        cell.cellImgView.image = [UIImage imageNamed:_shoeItems[indexPath.row]];
        
//        Item* item = _shoeItems[indexPath.row];
//        cell.cellLabel.text = item.itemName;
        
        cell.cellLabel.text = _subcategoryArr[indexPath.row];
    }
    else if (!_isSubCatSelected) {
        cell.cellLabel.hidden = NO;
        ItemCategory* catobj = _shoeCategory[indexPath.row];
        cell.cellLabel.text = catobj.category;
        cell.cellImgView.hidden = YES;
    }
    else {
        Item* item = _shoeItems[indexPath.row];
        cell.cellLabel.text = item.itemName;
    }

    cell.layer.cornerRadius = 5;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isCategorySelected && !_isSubCatSelected) {
        _isCategorySelected = YES;
        _isSubCatSelected = NO;
        ItemCategory* catobj = _shoeCategory[indexPath.row];
        [_btnCategory setTitle:catobj.category forState:UIControlStateNormal];
        [_db createSubcategoryTable];
        _subcategoryArr = [_db getSubCategoryByCategory:catobj.category];
        [_itemCollView reloadData];
    }
    else if (!_isSubCatSelected) {
        _isCategorySelected = YES;
        _isSubCatSelected = YES;
        [_btnCategory setTitle:_subcategoryArr[indexPath.row] forState:UIControlStateNormal];
        [_db createItemTable];
        _shoeItems = [_db getItemByCategory:_subcategoryArr[indexPath.row]];
        [_itemCollView reloadData];
    }
    else {
        BOOL newData = YES;
        NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
        
        Item* itemObj = _shoeItems[indexPath.row];
        
        for (int i = 0; i < tempItems.count; i++) {
            NSMutableDictionary *itemDictionary = [tempItems[i] mutableCopy];
            Item *item = itemDictionary[@"item"];
            if ([item.itemId rangeOfString:itemObj.itemId options:NSCaseInsensitiveSearch].location != NSNotFound) {
                // found item in current array
                itemsTotalPrice += item.itemPrice;
                newData = NO;
                int quantity = [itemDictionary[@"quantity"] intValue];
                quantity ++;
                itemDictionary[@"quantity"] = @(quantity);
                [tempItems replaceObjectAtIndex:i withObject:itemDictionary];
            }
        }
        if (newData) {
            // item not found, add new item to array
//            Item *item = [self.db getItem:self.barcodeValueTextField.text];
            if (itemObj) {
                itemsTotalPrice += itemObj.itemPrice;
                NSDictionary *itemWithQuantity = @{@"item": itemObj,
                                                   @"quantity": @1};
                [tempItems addObject:itemWithQuantity];
            }
        }
        _noNeedToChangeTotal = YES;
        self.itemTotalPrice.text = [NSString stringWithFormat:@"%.2f", itemsTotalPrice];
        self.itemsArray = tempItems;
        [self.tableView reloadData];

    }
}




@end
