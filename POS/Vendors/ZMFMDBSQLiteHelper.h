//
//  ZMFMDBSQLiteHelper.h
//  MMFreelancer
//
//  Created by Zune Moe on 18/9/13.
//  Copyright (c) 2013 Wizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Customer.h"
#import "SaleTransaction.h"
#import "SalePerson.h"
#import "Admin.h"
#import "Credit.h"
#import "ItemCategory.h"
#import "Subcategory.h"

@interface ZMFMDBSQLiteHelper : NSObject
- (BOOL) executeUpdate:(NSString *)query;
- (NSMutableArray *) executeQuery:(NSString *)query;

- (void)createItemTable;
- (void)insertItem:(Item *)item;
- (Item *)getItem:(NSString *)itemId;
- (NSArray*)getItemCategories;
- (NSArray*)getItemByCategory:(NSString*)category;
- (NSArray*)getAllItem;

- (void)createCustomerTable;
- (void)insertCustomer:(Customer *)customer;
- (Customer *)getCustomer:(NSString *)cusName;
- (NSArray *)getAllCustomers;
- (void)updateCustomerCredit:(double)credit withCustomerName:(NSString *)name;
- (void)removeCustormer:(NSString*)name;
- (void)updateCustomerInfo:(Customer*)cusObj withName:(NSString *)name;

- (void)updateItemPrice:(double)price withItemId:(NSString *)itemcode;

- (void)createTransactionTable;
- (void)insertTransaction:(SaleTransaction *)sale;
- (NSArray *)getTransactionMonthly:(NSString *)strMonth;

- (NSArray *)getTransactionDaily:(NSString *)strDay;
- (NSArray *)getTransactionWeekly:(NSString *)strDay;
- (NSArray *)getTransactionWithStartDate:(NSString *)startDate withEndDate:(NSString*)endDate withSalePerson:(NSString*)saleperson;
- (NSArray *)getBuyerTransactionWithStartDate:(NSString *)startDate withEndDate:(NSString*)endDate withBuyer:(NSString*)buyer;
- (NSArray *)getTransactionVoucher:(NSString *)strDay;
- (NSArray *)getTransactionByVoucher:(NSString *)voucherid;

- (void)createSalePersonTable;
- (void)insertSalePerson:(SalePerson *)sp;
- (SalePerson *)getSalePersonWithName:(NSString*)spName withPassword:(NSString*)spPW;
- (SalePerson *)getAllSaleperson:(NSString*)spName;
- (NSArray *)getAllSalepersonNames;

- (void)createAdminTable;
- (void)insertAdmin:(Admin*)admin;
- (Admin *)getAdminInfo;
- (BOOL)getAdminUsername:(NSString*)username;

- (void)createCreditTable;
- (void)insertCredit:(Credit*)credit;
- (NSArray *)getCreditByBuyer:(NSString *)buyer;

- (void)createCategoryTable;
- (void)insertCategory:(ItemCategory*)itemCat;
- (BOOL)getCategory:(NSString*)cat;
- (NSArray*)getAllCategory;

- (void)createSubcategoryTable;
- (void)insertSubcategory:(Subcategory*)subcat;
- (BOOL)getSubcategory:(NSString*)subcatStr;
- (NSArray*)getAllSubcategory;
- (NSArray*)getSubCategoryByCategory:(NSString*)cat;

@end
