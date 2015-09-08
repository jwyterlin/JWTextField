//
//  JWTextField.h
//  Demo
//
//  Created by Jhonathan Wyterlin on 06/09/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWTextFieldDelegate;

@interface JWTextField : UITextField

-(void)setup;

@property(weak) id<JWTextFieldDelegate> jw_delegate;

@end

@protocol JWTextFieldDelegate <NSObject>

@optional

-(BOOL)jw_textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
-(void)jw_textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
-(BOOL)jw_textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
-(void)jw_textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

-(BOOL)jw_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

-(BOOL)jw_textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
-(BOOL)jw_textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key press

@end
