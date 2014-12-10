 //
//  ZMFMDBSQLiteHelper.m
//  MMFreelancer
//
//  Created by Zune Moe on 18/9/13.
//  Copyright (c) 2013 Wizard. All rights reserved.
//

#import "ZMFMDBSQLiteHelper.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
#import <sqlite3.h>

#define isResultLogged YES
@implementation ZMFMDBSQLiteHelper

- (NSString *) getDatabasePath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentDir stringByAppendingPathComponent:@"database.db"];
    
    return databasePath;
}

- (BOOL) executeUpdate:(NSString *)query
{    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    db.logsErrors = YES;
    [db open];
    BOOL success = [db executeUpdate:query];
    [db close];
    return success;
}

- (NSMutableArray *) executeQuery:(NSString *)query
{
    NSMutableArray *resultOfQuery = [[NSMutableArray alloc] init];    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) [resultOfQuery addObject:[results resultDictionary]];
    [db close];
	return resultOfQuery;
}
#pragma mark - ItemTable
- (void)createItemTable
{
    [self executeUpdate:@"create table if not exists ItemList (itemId primary key, itemName, itemPrice, itemCategory)"];
}

- (void)insertItem:(Item *)item
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into ItemList (itemId, itemName, itemPrice, itemCategory) values "];
    [insert_query appendFormat:@"('%@', '%@', '%f', '%@')", item.itemId, item.itemName, item.itemPrice, item.itemCategory];
    [self executeUpdate:insert_query];
}

- (Item *)getItem:(NSString *)itemId
{
    NSArray *items = [self executeQuery:[NSString stringWithFormat:@"select * from ItemList where itemId = '%@'", itemId]];
    if (items.count > 0) {
        NSError *error = nil;
//        NSDictionary* dict = items.firstObject;
        Item *item = [[Item alloc] initWithDictionary:items.firstObject error:&error];
        return item;
    }
    return nil;
}

- (NSArray*)getItemCategories
{

    NSArray* categories = [self executeQuery:@"select itemCategory from ItemList group by itemCategory"];
    NSMutableArray* catMuArr = [[NSMutableArray alloc] initWithCapacity:categories.count];
    for (NSDictionary* dict in categories) {
        NSString* str = dict[@"itemCategory"];
        [catMuArr addObject:str];
    }
    return catMuArr;
}

- (NSArray*)getItemByCategory:(NSString*)category
{
    NSArray* items = [self executeQuery:[NSString stringWithFormat:@"select * from ItemList where itemCategory = '%@'",category]];
    NSMutableArray* resultItems = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (NSDictionary* dict in items) {
        Item* item = [[Item alloc] initWithDictionary:dict error:nil];
        [resultItems addObject:item];
    }
    return resultItems;
}

- (void)updateItemPrice:(double)price withItemId:(NSString *)itemcode
{
    NSString* update_query = [NSString stringWithFormat:@"update ItemList set itemPrice = '%f' where itemId = '%@'", price, itemcode];
    [self executeUpdate:update_query];
}

- (NSArray*)getAllItem
{
    NSArray* items = [self executeQuery:[NSString stringWithFormat:@"select * from ItemList"]];
    NSMutableArray* resultItems = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (NSDictionary* dict in items) {
        Item* item = [[Item alloc] initWithDictionary:dict error:nil];
        [resultItems addObject:item];
    }
    return resultItems;
}


#pragma mark - CustomerTable
- (void)createCustomerTable
{
    [self executeUpdate:@"create table if not exists Buyer (cusName primary key, cusCity, cusPh, cusAddress, cusCredit)"];
}

- (void)insertCustomer:(Customer *)customer
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into Buyer (cusName, cusCity, cusPh, cusAddress, cusCredit) values "];
    [insert_query appendFormat:@"('%@', '%@', '%@', '%@', '%f')", customer.cusName, customer.cusCity, customer.cusPh, customer.cusAddress, customer.cusCredit];
    [self executeUpdate:insert_query];

}

- (void)updateCustomerCredit:(double)credit withCustomerName:(NSString *)name
{
    NSString* update_query = [NSString stringWithFormat:@"update Buyer set cusCredit = '%f' where cusName = '%@'", credit, name];
    [self executeUpdate:update_query];
}


- (Customer *)getCustomer:(NSString *)cusName
{
    NSArray *customers = [self executeQuery:[NSString stringWithFormat:@"select * from Buyer where cusName = '%@'", cusName]];
    if (customers.count > 0) {
        NSError *error = nil;
//        NSDictionary* dict = customers.firstObject;
        Customer *customer = [[Customer alloc] initWithDictionary:customers.firstObject error:&error];
        return customer;
    }
    return nil;
}

- (NSArray *)getAllCustomers
{

    NSArray *customers = [self executeQuery:@"select * from Buyer"];
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:customers.count];
    for (NSDictionary* dict in customers) {
        Customer *customer = [[Customer alloc] initWithDictionary:dict error:nil];
        [resultArr addObject:customer];
    }
    return resultArr;
}

- (void)removeCustormer:(NSString*)name
{
    NSString *delete_query = [NSString stringWithFormat:@"delete from Buyer where cusName = '%@'", name];
    [self executeUpdate:delete_query];
}

- (void)updateCustomerInfo:(Customer*)cusObj withName:(NSString *)name
{
    NSString* update_query = [NSString stringWithFormat:@"update Buyer set cusCity = '%@', cusPh = '%@', cusAddress = '%@' where cusName = '%@'", cusObj.cusCity,cusObj.cusPh,cusObj.cusAddress, name];
    [self executeUpdate:update_query];
}


#pragma mark - TransactionTable

- (void)createTransactionTable
{
    [self executeUpdate:@"create table if not exists saleVoucher (vid, cusname, itemid, qty, itemtotal, vdate, total, salePerson)"];
}

- (void)insertTransaction:(SaleTransaction *)sale
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into saleVoucher (vid, cusname, itemid, qty, itemtotal, vdate, total, salePerson) values "];
    [insert_query appendFormat:@"('%@', '%@', '%@', '%@','%@', '%@', '%@', '%@')", sale.vid, sale.cusname, sale.itemid, sale.qty, sale.itemtotal,sale.vdate, sale.total, sale.salePerson];
    [self executeUpdate:insert_query];
}

- (NSArray *)getTransactionMonthly:(NSString *)strMonth
{
    //MONTH FORMAT FOR SQLITE '01'...
    //    WHERE strftime('%m',[saleVoucher].[vdate]) = '08'
    NSString *str = [NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, vdate, total, salePerson from saleVoucher where strftime('%%m',[saleVoucher].[vdate]) = '%@' group by itemid",strMonth];//  ---   -----
    NSArray *transactions = [self executeQuery:str]; //select * from saleVoucher where vdate  between '2014-01-11 06:40:21' and  '2014-01-13 06:40:21'
    NSMutableArray *transactionResult = [NSMutableArray arrayWithCapacity:transactions.count];
    for(NSDictionary *dict in transactions)
    {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SaleTransaction *saleTransaction = [[SaleTransaction alloc] initWithDictionary:dict error:&error];
        [transactionResult addObject:saleTransaction];
    }
    return transactionResult;
}

- (NSArray *)getTransactionDaily:(NSString *)strDay
{
    NSArray *transactions = [self executeQuery:[NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, vdate, total, salePerson from saleVoucher where vdate between '%@ 00:00:00' and  '%@ 24:00:00' group by itemid",strDay,strDay]]; //select * from saleVoucher where vdate  between '2014-01-11 06:40:21' and  '2014-01-13 06:40:21'
    NSMutableArray *transactionResult = [NSMutableArray arrayWithCapacity:transactions.count];
    for(NSDictionary *dict in transactions)
    {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SaleTransaction *saleTransaction = [[SaleTransaction alloc] initWithDictionary:dict error:&error];
        [transactionResult addObject:saleTransaction];
    }
    return transactionResult;
}

- (NSArray *)getTransactionWeekly:(NSString *)strDay
{
    NSArray *transactions = [self executeQuery:[NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, vdate, total, salePerson from saleVoucher where strftime('%%W', saleVoucher.vdate) = strftime('%%W', 'now') group by itemid"]]; //select * from saleVoucher where vdate  between '2014-01-11 06:40:21' and  '2014-01-13 06:40:21'
    NSMutableArray *transactionResult = [NSMutableArray arrayWithCapacity:transactions.count];
    for(NSDictionary *dict in transactions)
    {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SaleTransaction *saleTransaction = [[SaleTransaction alloc] initWithDictionary:dict error:&error];
        [transactionResult addObject:saleTransaction];
    }
    return transactionResult;
}


- (NSArray *)getTransactionWithStartDate:(NSString *)startDate withEndDate:(NSString*)endDate withSalePerson:(NSString*)saleperson
{
    NSString* queryStr;
    
    if ([saleperson isEqualToString:@"All"]) {
        queryStr = [NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, strftime('%%Y-%%m-%%d', vdate) as vdate, total, salePerson from saleVoucher where vdate between '%@ 00:00:00' and  '%@ 24:00:00' group by strftime('%%Y%%m%%d', vdate),itemid",startDate,endDate];
        
    }
    else {
        queryStr = [NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, strftime('%%Y-%%m-%%d', vdate) as vdate, total, salePerson from saleVoucher where salePerson = '%@' and vdate between '%@ 00:00:00' and  '%@ 24:00:00' group by strftime('%%Y%%m%%d', vdate),itemid",saleperson,startDate,endDate];
    }
    
    NSArray *transactions = [self executeQuery:queryStr];
    //select * from saleVoucher where vdate  between '2014-01-11 06:40:21' and  '2014-01-13 06:40:21'
    NSMutableArray *transactionResult = [NSMutableArray arrayWithCapacity:transactions.count];
    for(NSDictionary *dict in transactions)
    {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SaleTransaction *saleTransaction = [[SaleTransaction alloc] initWithDictionary:dict error:&error];
        [transactionResult addObject:saleTransaction];
    }
    return transactionResult;
}

- (NSArray *)getBuyerTransactionWithStartDate:(NSString *)startDate withEndDate:(NSString*)endDate withBuyer:(NSString*)buyer
{
    NSString* queryStr;
    
    if ([buyer isEqualToString:@"All"]) {
        queryStr = [NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, strftime('%%Y-%%m-%%d', vdate) as vdate, total, salePerson from saleVoucher where vdate between '%@ 00:00:00' and  '%@ 24:00:00' group by strftime('%%Y%%m%%d', vdate),itemid",startDate,endDate];
        
    }
    else {
        queryStr = [NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, strftime('%%Y-%%m-%%d', vdate) as vdate, total, salePerson from saleVoucher where cusname = '%@' and vdate between '%@ 00:00:00' and  '%@ 24:00:00' group by strftime('%%Y%%m%%d', vdate),itemid",buyer,startDate,endDate];
    }
    
    NSArray *transactions = [self executeQuery:queryStr];
    //select * from saleVoucher where vdate  between '2014-01-11 06:40:21' and  '2014-01-13 06:40:21'
    NSMutableArray *transactionResult = [NSMutableArray arrayWithCapacity:transactions.count];
    for(NSDictionary *dict in transactions)
    {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SaleTransaction *saleTransaction = [[SaleTransaction alloc] initWithDictionary:dict error:&error];
        [transactionResult addObject:saleTransaction];
    }
    return transactionResult;
}

- (NSArray *)getTransactionVoucher:(NSString *)strDay
{
    NSArray *transactions = [self executeQuery:[NSString stringWithFormat:@"select vid, cusname, itemid, SUM(qty) as qty, SUM(itemtotal) as itemtotal, vdate, total, salePerson from saleVoucher where vdate between '%@ 00:00:00' and  '%@ 24:00:00' group by vid",strDay,strDay]]; //select * from saleVoucher where vdate  between '2014-01-11 06:40:21' and  '2014-01-13 06:40:21'
    NSMutableArray *transactionResult = [NSMutableArray arrayWithCapacity:transactions.count];
    for(NSDictionary *dict in transactions)
    {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SaleTransaction *saleTransaction = [[SaleTransaction alloc] initWithDictionary:dict error:&error];
        [transactionResult addObject:saleTransaction];
    }
    return transactionResult;
}

- (NSArray *)getTransactionByVoucher:(NSString *)voucherid
{
     NSArray *transactions = [self executeQuery:[NSString stringWithFormat:@"select vid, cusname, itemid, qty, itemtotal, vdate, total, salePerson from saleVoucher where vid = '%@'",voucherid]];
    
    NSMutableArray *transactionResult = [NSMutableArray arrayWithCapacity:transactions.count];
    for(NSDictionary *dict in transactions)
    {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SaleTransaction *saleTransaction = [[SaleTransaction alloc] initWithDictionary:dict error:&error];
        [transactionResult addObject:saleTransaction];
    }
    return transactionResult;

}

#pragma mark - SalePersonTable

- (void)createSalePersonTable
{
    [self executeUpdate:@"create table if not exists spSalePerson (spusername, sppassword)"];
}

- (void)insertSalePerson:(SalePerson *)sp
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into spSalePerson (spusername, sppassword) values "];
    [insert_query appendFormat:@"('%@', '%@')", sp.spusername, sp.sppassword];
    [self executeUpdate:insert_query];
}

- (SalePerson *)getSalePersonWithName:(NSString*)spName withPassword:(NSString*)spPW
{
    NSArray *sps = [self executeQuery:[NSString stringWithFormat:@"select * from spSalePerson where spusername = '%@' and sppassword = '%@'", spName, spPW]];
    if (sps.count > 0) {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SalePerson *salep = [[SalePerson alloc] initWithDictionary:sps.firstObject error:&error];
        return salep;
    }
    return nil;
   
}

- (SalePerson *)getAllSaleperson:(NSString*)spName
{
    NSArray *salepersons = [self executeQuery:[NSString stringWithFormat:@"select * from spSalePerson where spusername = '%@'",spName]];
    if (salepersons.count > 0) {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        SalePerson *salep = [[SalePerson alloc] initWithDictionary:salepersons.firstObject error:&error];
        return salep;
    }
    return nil;

}

- (NSArray *)getAllSalepersonNames
{
    NSArray* arr = [self executeQuery:@"select spusername from spSalePerson"];
    NSMutableArray* muArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSDictionary* dict in arr) {
        NSString* str = dict[@"spusername"];
        [muArr addObject:str];
    }
    return muArr;
}

#pragma mark - AdminTable

- (void)createAdminTable
{
    [self executeUpdate:@"create table if not exists Admin (username, password)"];
}

- (void)insertAdmin:(Admin*)admin
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into Admin (username, password) values "];
    [insert_query appendFormat:@"('%@', '%@')", admin.username, admin.password];
    [self executeUpdate:insert_query];
}

- (Admin *)getAdminInfo
{
    NSArray *salepersons = [self executeQuery:@"select * from Admin"];
    if (salepersons.count > 0) {
        NSError *error = nil;
        //        NSDictionary* dict = customers.firstObject;
        Admin *salep = [[Admin alloc] initWithDictionary:salepersons.firstObject error:&error];
        return salep;
    }
    return nil;
}
- (BOOL)getAdminUsername:(NSString*)username
{
    NSArray* temparr = [self executeQuery:[NSString stringWithFormat:@"select * from Admin where username=%@",username]];
    if (temparr.count > 0) {
        return true;
    }
    return false;
}

#pragma mark - CreditTable

- (void)createCreditTable
{
    [self executeUpdate:@"create table if not exists Credit (creditCusName, creditDate, creditTotal, creditPayAmt, creditLeftToPayAmt)"];
}

- (void)insertCredit:(Credit*)credit
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into Credit (creditCusName, creditDate, creditTotal, creditPayAmt, creditLeftToPayAmt) values "];
    [insert_query appendFormat:@"('%@', '%@','%@', '%@','%@')", credit.creditCusName, credit.creditDate, credit.creditTotal, credit.creditPayAmt, credit.creditLeftToPayAmt];
    [self executeUpdate:insert_query];
}

- (NSArray *)getCreditByBuyer:(NSString *)buyer
{
    NSArray *creditList = [self executeQuery:[NSString stringWithFormat:@"select * from Credit where creditCusName = '%@'",buyer]];
    NSMutableArray *creditListResult = [NSMutableArray arrayWithCapacity:creditList.count];
    
    for (NSDictionary *dict in creditList) {
        Credit *credit = [[Credit alloc] initWithDictionary:dict error:nil];
        [creditListResult addObject:credit];
    }
    
    return creditListResult;
}

#pragma mark - Category Table

- (void)createCategoryTable
{
    [self executeUpdate:@"create table if not exists Category (catID primary key, category)"];
}

- (void)insertCategory:(ItemCategory*)itemCat
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into Category (category) values "];
    [insert_query appendFormat:@"('%@')", itemCat.category];
    [self executeUpdate:insert_query];

}

- (BOOL)getCategory:(NSString*)cat
{
    NSArray* temparr = [self executeQuery:[NSString stringWithFormat:@"select * from Category where category=%@",cat]];
    if (temparr.count > 0) {
        return true;
    }
    return false;
}

- (NSArray*)getAllCategory
{
    NSArray* temparr = [self executeQuery:[NSString stringWithFormat:@"select category from Category"]];
    NSMutableArray* muarr = [[NSMutableArray alloc] initWithCapacity:temparr.count];
    for (NSDictionary* dict in temparr) {
        ItemCategory* catobj = [[ItemCategory alloc] initWithDictionary:dict error:nil];
        [muarr addObject:catobj];
    }
    return muarr;
}

#pragma mark - Subcategory table
- (void)createSubcategoryTable
{
    [self executeUpdate:@"create table if not exists SubCategory (subcatID primary key, subcategory, category)"];
}

- (void)insertSubcategory:(Subcategory*)subcat
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into SubCategory (subcategory,category) values "];
    [insert_query appendFormat:@"('%@', '%@')", subcat.subcategory, subcat.category];
    [self executeUpdate:insert_query];
    
}

- (BOOL)getSubcategory:(NSString*)subcatStr
{
    NSArray* temparr = [self executeQuery:[NSString stringWithFormat:@"select * from SubCategory where subcategory='%@'",subcatStr]];
    if (temparr.count > 0) {
        return true;
    }
    return false;
}

- (NSArray*)getAllSubcategory
{
    NSArray* temparr = [self executeQuery:@"select subcategory,category from SubCategory"];
    NSMutableArray* muarr = [[NSMutableArray alloc] initWithCapacity:temparr.count];
    for (NSDictionary* dict in temparr) {
        Subcategory* subcatobj = [[Subcategory alloc] initWithDictionary:dict error:nil];
        [muarr addObject:subcatobj];
    }
    return muarr;
}

- (NSArray*)getSubCategoryByCategory:(NSString*)cat
{
     NSArray* temparr = [self executeQuery:[NSString stringWithFormat:@"select subcategory from SubCategory where category='%@'",cat]];
    NSMutableArray* muArr = [[NSMutableArray alloc] initWithCapacity:temparr.count];
    for (NSDictionary* dict in temparr) {
        [muArr addObject:dict[@"subcategory"]];
    }
    return muArr;
}

@end
