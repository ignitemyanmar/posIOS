//
//  ItemCell.m
//  POS
//
//  Created by Zune Moe on 3/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "ItemCell.h"
#import "PKCustomKeyboard.h"
#import "ZMNumberKeypad.h"

@implementation ItemCell
{
    NSIndexPath *_indexPath;
    
    BOOL isFirstTime;
    NSString *strIndexPath;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _itemQty.delegate = self;
}


- (void)configureCell:(Item *)item quantity:(int)quantity indexPath:(NSIndexPath *)indexPath
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    strIndexPath = [NSString stringWithFormat:@"%d",indexPath.row];
    
    _indexPath = indexPath;
    
//    PKCustomKeyboard *customKeyboard = [[PKCustomKeyboard alloc] init];
//    [customKeyboard setTextView:self.itemQty];
    
    ZMNumberKeypad *keypad = [[ZMNumberKeypad alloc] init];
    [keypad setTextView:self.itemQty];
    self.itemQty.delegate = self;
    
    self.itemName.text = item.itemName;
    self.itemQty.text = [NSString stringWithFormat:@"%d", quantity];
    self.itemUnitPrice.text = [NSString stringWithFormat:@"%.2f", item.itemPrice];
    self.itemTotalPrice.text = [NSString stringWithFormat:@"%.2f", item.itemPrice * quantity];
}

//- (void)textFieldDidChange:(NSNotification *)notification
//{
////    NSString* strindex = (NSString*)notification.object;
//    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    [self.itemQty resignFirstResponder];
    NSLog(@"quantity: %@", self.itemQty.text);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ItemQuantityUpated" object:@{@"indexPath": _indexPath, @"quantity": self.itemQty.text}];

}

@end
