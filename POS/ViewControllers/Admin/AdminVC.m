//
//  AdminVC.m
//  POS
//
//  Created by Zune Moe on 3/19/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AdminVC.h"
#import "ZMKeypad.h"
#import "ZMNumberKeypad.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Admin.h"
#import "AddNewSubCategoryVC.h"
#import "JDStatusBarNotification.h"
#import "AddNewBarcodeVC.h"

@interface AdminVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *panelContainer;
@property (weak, nonatomic) IBOutlet UITextField *panelUsername;
@property (weak, nonatomic) IBOutlet UITextField *panelPassword;
@property (weak, nonatomic) IBOutlet UIButton *panelLoginButton;

@property (weak, nonatomic) IBOutlet UIView *addNewContainer;

@property (weak, nonatomic) IBOutlet UIView *updateContainer;

@property (weak, nonatomic) IBOutlet UIView *reportContainer;
- (IBAction)onAddNewSubcatClicked:(id)sender;
- (IBAction)onAddNewBarcodeClicked:(id)sender;

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;
@end

@implementation AdminVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewsShadow];
    [self adminPanelAlpha:0.0];
    
    //self.panelUsername.inputView = [[ZMKeypad alloc] initWithFrame:CGRectMake(0, 0, 1024, 300)];
    ZMKeypad *keypad = [[ZMKeypad alloc] init];
    [keypad setTextView:self.panelUsername];
    self.panelUsername.delegate = self;
    
    ZMKeypad *keypad1 = [[ZMKeypad alloc] init];
    [keypad1 setTextView:self.panelPassword];
    self.panelPassword.delegate = self;

    
    _db = [ZMFMDBSQLiteHelper new];
}

- (void)setupViewsShadow
{
    self.panelContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.panelContainer.layer.shadowOpacity = 0.5;
    self.panelContainer.layer.shadowRadius = 3.0;
    self.panelContainer.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    
    self.addNewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addNewContainer.layer.shadowOpacity = 0.5;
    self.addNewContainer.layer.shadowRadius = 3.0;
    self.addNewContainer.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    
    self.updateContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.updateContainer.layer.shadowOpacity = 0.5;
    self.updateContainer.layer.shadowRadius = 3.0;
    self.updateContainer.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    
    self.reportContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.reportContainer.layer.shadowOpacity = 0.5;
    self.reportContainer.layer.shadowRadius = 3.0;
    self.reportContainer.layer.shadowOffset = CGSizeMake(1.0, 2.0);
}

- (void)adminPanelAlpha:(CGFloat)alpha
{
    self.addNewContainer.alpha = alpha;
    self.updateContainer.alpha = alpha;
    self.reportContainer.alpha = alpha;
}

- (IBAction)login:(id)sender {
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"Admin"];
    if (dict) {
        Admin* admin = [[Admin alloc] initWithDictionary:dict error:nil];
        if (_panelUsername.text.length > 0 && _panelPassword.text.length > 0) {
            
//            [_db createAdminTable];
//            Admin* admin = [_db getAdminInfo];
            if ([admin.username isEqualToString:_panelUsername.text] && [admin.password isEqualToString:_panelPassword.text])
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.panelContainer.alpha = 0.0;
                    [self adminPanelAlpha:1.0];
                }];
                
            }
            
        }

    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            self.panelContainer.alpha = 0.0;
            [self adminPanelAlpha:1.0];
        }];
    }
    
}

- (IBAction)onAddNewSubcatClicked:(id)sender {
    [_db createCategoryTable];
    NSArray* catArr = [_db getAllCategory];
    if (catArr.count > 0) {
        AddNewSubCategoryVC* catVC = (AddNewSubCategoryVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewSubCategoryVC"];
        [self presentViewController:catVC animated:YES completion:nil];
    }
    else [self JDStatusBarHidden:NO status:@"No category in database!" duration:3.0f];
}

- (IBAction)onAddNewBarcodeClicked:(id)sender {
    AddNewBarcodeVC* destvc = (AddNewBarcodeVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewBarcodeVC"];
    [self presentViewController:destvc animated:YES completion:nil];
}

- (void) JDStatusBarHidden:(BOOL)hidden status:(NSString *)status duration:(NSTimeInterval)interval
{
    if(hidden) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        if(interval != 0) {
            [JDStatusBarNotification showWithStatus:status dismissAfter:interval styleName:@"StatusBarStyle"];
        } else {
            [JDStatusBarNotification showWithStatus:status styleName:@"StatusBarStyle"];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

@end
