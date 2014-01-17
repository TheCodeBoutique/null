//
//  TRMAddressBookApi.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMAddressBookApi.h"
#import <AddressBook/AddressBook.h>
#import "TRMCoreApi.h"
#import "TRMPhoneContactModel.h"

NSString *const kDenied = @"Access to address book is denied";
NSString *const kRestricted = @"Access to address book is restricted";

ABAddressBookRef addressBook;

@implementation TRMAddressBookApi
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (TRMAddressBookApi *)sharedInstance
{
    static TRMAddressBookApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TRMAddressBookApi alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


-(void)requestAccessForAddressBook {
    CFErrorRef error = NULL;
    
    switch (ABAddressBookGetAuthorizationStatus()){
        case kABAuthorizationStatusAuthorized:{
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            [self useAddressBook:addressBook];
            if (addressBook != NULL){
                CFRelease(addressBook);
            }
            break;
        }
        case kABAuthorizationStatusDenied:{
            NSLog(@"%@",kDenied);
            break;
        }
        case kABAuthorizationStatusNotDetermined:{
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABAddressBookRequestAccessWithCompletion
            (addressBook, ^(bool granted, CFErrorRef error) {
                if (granted){
                    NSLog(@"Access was granted");
                    [self useAddressBook:addressBook];
                } else {
                    NSLog(@"Access was not granted");
                }
                if (addressBook != NULL){
                    CFRelease(addressBook);
                }
            });
            break;
        }
        case kABAuthorizationStatusRestricted:{
            NSLog(@"%@",kRestricted);
            break;
        }
    }
    
}

- (void) useAddressBook:(ABAddressBookRef)paramAddressBook{
    /* Work with the address book here */
    
    /* Let's see whether we have made any changes to the
     address book or not, before attempting to save it */
    
    if (ABAddressBookHasUnsavedChanges(paramAddressBook)){
        /* Now decide if you want to save the changes to
         the address book */
        NSLog(@"Changes were found in the address book.");
        
        BOOL doYouWantToSaveChanges = YES;
        
        /* We can make a decision to save or revert the
         address book back to how it was before */
        if (doYouWantToSaveChanges){
            
            CFErrorRef saveError = NULL;
            
            if (ABAddressBookSave(paramAddressBook, &saveError)){
                /* We successfully saved our changes to the
                 address book */
            } else {
                /* We failed to save the changes. You can now
                 access the [saveError] variable to find out
                 what the error is */
            }
            
        } else {
            
            /* We did NOT want to save the changes to the address
             book so let's revert it to how it was before */
            ABAddressBookRevert(paramAddressBook);
            
        }
        
    } else {
        /* We have not made any changes to the address book */
        NSLog(@"No changes to the address book.");
        [self readFromAddressBook:addressBook];
    }
}

- (NSMutableArray *) logPersonEmails:(ABRecordRef)paramPerson{
    NSMutableArray *allEmails = [[NSMutableArray alloc] init];
    if (paramPerson == NULL){
        NSLog(@"The given person is NULL.");
        return nil;
    }
    
    ABMultiValueRef emails =
    ABRecordCopyValue(paramPerson, kABPersonEmailProperty);
    
    if (emails == NULL){
        NSLog(@"This contact does not have any emails.");
        return nil;
    }
    
    /* Go through all the emails */
    NSUInteger emailCounter = 0;
    
    for (emailCounter = 0;
         emailCounter < ABMultiValueGetCount(emails);
         emailCounter++){
        
        /* Get the label of the email (if any) */
        NSString *emailLabel = (__bridge_transfer NSString *)
        ABMultiValueCopyLabelAtIndex(emails, emailCounter);
        
        NSString *localizedEmailLabel = (__bridge_transfer NSString *)
        ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)emailLabel);
        
        /* And then get the email address itself */
        NSString *email = (__bridge_transfer NSString *)
        ABMultiValueCopyValueAtIndex(emails, emailCounter);
        
        NSLog(@"Label = %@, Localized Label = %@, Email = %@",
              emailLabel,
              localizedEmailLabel,
              email);
        
        emailLabel = (emailLabel.length != 0) ? emailLabel : @"Other";
        NSDictionary *emailDict = [[NSDictionary alloc] initWithObjectsAndKeys:email, emailLabel,nil];
        [allEmails addObject:emailDict];
    }
    
    CFRelease(emails);
    
    return allEmails;
}


- (NSMutableArray *) logPhoneNumbrs:(ABRecordRef)paramPerson{
    NSMutableArray *allPhoneNumbers = [[NSMutableArray alloc] init];
    if (paramPerson == NULL){
        NSLog(@"The given person is NULL.");
        return nil;
    }
    
    ABMultiValueRef phones =
    ABRecordCopyValue(paramPerson, kABPersonPhoneProperty);
    
    if (phones == NULL){
        NSLog(@"This contact does not have any phones.");
        return nil;
    }
    
    /* Go through all the phone numbers */
    NSUInteger phoneCounter = 0;
    
    for (phoneCounter = 0;
         phoneCounter < ABMultiValueGetCount(phones);
         phoneCounter++){
        
        /* Get the label of the phone (if any) */
        NSString *phoneLabel = (__bridge_transfer NSString *)
        ABMultiValueCopyLabelAtIndex(phones, phoneCounter);
        
        NSString *localizedPhoneLabel = (__bridge_transfer NSString *)
        ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)phoneLabel);
        
        /* And then get the phone address itself */
        NSString *phoneNumber = (__bridge_transfer NSString *)
        ABMultiValueCopyValueAtIndex(phones, phoneCounter);
        
        NSLog(@"Label = %@, Localized Label = %@, phone = %@",
              phoneLabel,
              localizedPhoneLabel,
              phoneNumber);
        
        phoneLabel = (phoneLabel.length != 0) ? phoneLabel : @"Other";
        NSDictionary *phoneDict = [[NSDictionary alloc] initWithObjectsAndKeys:phoneNumber, phoneLabel,nil];
        [allPhoneNumbers addObject:phoneDict];
    }
    
    CFRelease(phones);
    
    return allPhoneNumbers;
}


- (NSMutableArray *) logAddress:(ABRecordRef)paramPerson{
    NSMutableArray *allAddresses = [[NSMutableArray alloc] init];
    if (paramPerson == NULL){
        NSLog(@"The given person is NULL.");
        return nil;
    }
    
    ABMultiValueRef addresses =
    ABRecordCopyValue(paramPerson, kABPersonAddressProperty);
    
    if (addresses == NULL){
        NSLog(@"This contact does not have any addresses.");
        return nil;
    }
    
    /* Go through all the phone numbers */
    NSUInteger addressCounter = 0;
    
    for (addressCounter = 0;
         addressCounter < ABMultiValueGetCount(addresses);
         addressCounter++){
        
        /* Get the label of the phone (if any) */
        NSString *addressLabel = (__bridge_transfer NSString *)
        ABMultiValueCopyLabelAtIndex(addresses, addressCounter);
        
        NSString *localizedAddressLabel = (__bridge_transfer NSString *)
        ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)addressLabel);
        
        /* And then get the phone address itself */
        NSString *address = (__bridge_transfer NSString *)
        ABMultiValueCopyValueAtIndex(addresses, addressCounter);
        
        NSLog(@"Label = %@, Localized Label = %@, address = %@",
              addressLabel,
              localizedAddressLabel,
              address);
        
        addressLabel = (addressLabel.length != 0) ? addressLabel : @"Other";
        NSDictionary *addressDict = [[NSDictionary alloc] initWithObjectsAndKeys:address, addressLabel,nil];
        [allAddresses addObject:addressDict];
    }
    
    CFRelease(addresses);
    
    return allAddresses;
}

- (void) readFromAddressBook:(ABAddressBookRef)paramAddressBook{
    //user to write to core api
    NSMutableArray *localContacts = [[NSMutableArray alloc] init];
    
    NSArray *allPeople = (__bridge_transfer NSArray *)
    ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    
    NSUInteger peopleCounter = 0;
    for (peopleCounter = 0;
         peopleCounter < [allPeople count];
         peopleCounter++){
        
        ABRecordRef thisPerson =  (__bridge ABRecordRef)
        [allPeople objectAtIndex:peopleCounter];
        
        NSString *firstName = (__bridge_transfer NSString *)
        ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty);
        
        NSString *lastName = (__bridge_transfer NSString *)
        ABRecordCopyValue(thisPerson, kABPersonLastNameProperty);
        
        
        NSLog(@"First Name = %@", firstName);
        NSLog(@"Last Name = %@", lastName);
        
        NSMutableArray *emails = [self logPersonEmails:thisPerson];
        NSMutableArray *phoneNumbers = [self logPhoneNumbrs:thisPerson];
        NSMutableArray *address = [self logAddress:thisPerson];
        
        //add contact to array
        TRMPhoneContactModel *contact = [[TRMPhoneContactModel alloc] init];
        [contact setFirst_name:firstName];
        [contact setLast_name:lastName];
        [contact setAddresses:address];
        [contact setEmails:emails];
        [contact setPhone_numbers:phoneNumbers];
        [localContacts addObject:contact];
    }
    [[TRMCoreApi sharedInstance] setLocalContacts:localContacts];
}
@end
