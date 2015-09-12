//
//  JWTextField.m
//  Demo
//
//  Created by Jhonathan Wyterlin on 06/09/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "JWTextField.h"

@interface JWTextField()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *lineBelowTextField;
@property(nonatomic,strong) UITapGestureRecognizer *tapToDismiss;
@property(nonatomic) float keyHeight;
@property(nonatomic) BOOL screenHasMoved;
@property(nonatomic) int screenMoveValue;

@end

@implementation JWTextField

-(id)init {
    
    self = [super init];
    
    if ( self ) {
        
        CGFloat x = 8;
        CGFloat y = 40;
        CGFloat width = [UIScreen mainScreen].bounds.size.width - ( x * 2 );
        CGFloat height = 30;
        
        self.frame = CGRectMake( x, y, width, height );
        
        [self setup];
        
    }
    
    return self;
    
}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if ( self ) {
        
        [self setup];
        
    }
    
    return self;
    
}

-(void)didMoveToSuperview {
    
    UIView *superView = self.superview;
    
    if ( superView )
        if ( ! [self.lineBelowTextField isDescendantOfView:superView] )
            [superView addSubview:self.lineBelowTextField];
    
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Public methods

-(void)setup {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    
    self.borderStyle = UITextBorderStyleNone;
    self.textColor = [UIColor colorWithRed:186.0/256.0 green:193.0/256.0 blue:179.0/256.0 alpha:1.0];
    self.keyboardType = UIKeyboardTypeDefault;
    self.delegate = self;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    
    self.keyHeight = 224;
    
}

#pragma mark - IBAction methods

-(IBAction)tapToDismiss:(UITapGestureRecognizer *)sender {
    
    if ( self.superview )
        [self.superview endEditing:YES];
    
}

#pragma mark - UITextFieldDelegate methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ( [self.jw_delegate respondsToSelector:@selector(jw_textFieldShouldBeginEditing:)] )
        return [self.jw_delegate jw_textFieldShouldBeginEditing:textField];
    
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ( self.superview )
        [self.superview addGestureRecognizer:self.tapToDismiss];
    
    self.lineBelowTextField.backgroundColor = [UIColor colorWithRed:109.0/256.0 green:171.0/256.0 blue:242.0/256.0 alpha:1.0];
    [self animateTextField:YES];
    
    if ( [self.jw_delegate respondsToSelector:@selector(jw_textFieldDidBeginEditing:)] )
        [self.jw_delegate jw_textFieldDidBeginEditing:textField];
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if ( [self.jw_delegate respondsToSelector:@selector(jw_textFieldShouldEndEditing:)] )
        [self.jw_delegate jw_textFieldShouldEndEditing:textField];
    
    return YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ( self.superview )
        [self.superview removeGestureRecognizer:self.tapToDismiss];
    
    self.lineBelowTextField.backgroundColor = [UIColor colorWithRed:220.0/256.0 green:224.0/256.0 blue:216.0/256.0 alpha:1.0];
    [self animateTextField:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    if ( [self.jw_delegate respondsToSelector:@selector(jw_textFieldDidEndEditing:)] )
        [self.jw_delegate jw_textFieldDidEndEditing:textField];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ( [self.jw_delegate respondsToSelector:@selector(jw_textField:shouldChangeCharactersInRange:replacementString:)] )
        return [self.jw_delegate jw_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if ( [self.jw_delegate respondsToSelector:@selector(jw_textFieldShouldClear:)] )
        [self.jw_delegate jw_textFieldShouldClear:textField];
    
    return NO;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ( [self.jw_delegate respondsToSelector:@selector(jw_textFieldShouldReturn:)] )
        return [self.jw_delegate jw_textFieldShouldReturn:textField];
    
    return NO;
    
}

#pragma mark - Private methods

-(void) animateTextField:(BOOL)animate {
    
    if ( ! self.superview )
        return;
    
    CGFloat textSize = [self.superview convertPoint:self.frame.origin toView:nil].y + self.frame.size.height;
    
    if ( animate ) {
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        if ( screenHeight - textSize < self.keyHeight ) {
            
            self.screenMoveValue = self.keyHeight - ( screenHeight - textSize ) + 16; // tweak as needed
            const float movementDuration = 0.3f; // tweak as needed
            
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.superview.frame = CGRectOffset( self.superview.frame, 0, -self.screenMoveValue );
            [UIView commitAnimations];
            self.screenHasMoved = YES;
            
        }
        
    } else if ( self.screenHasMoved ) {
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        self.superview.frame = CGRectOffset( self.superview.frame, 0, self.screenMoveValue );
        [UIView commitAnimations];
        self.screenHasMoved = NO;
        
    }
    
}

#pragma mark - Notification methods

-(void)myNotificationMethod:(NSNotification*)notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.keyHeight = keyboardFrameBeginRect.size.height;
    
}

#pragma mark - Creating components

-(UIView *)lineBelowTextField {
    
    if ( ! _lineBelowTextField ) {
        
        int x = self.frame.origin.x;
        int y = self.frame.origin.y + self.frame.size.height - 2;
        int width = [UIScreen mainScreen].bounds.size.width - ( x * 2 );
        int height = 1;
        
        _lineBelowTextField = [[UIView alloc] initWithFrame:CGRectMake( x, y, width, height )];
        _lineBelowTextField.backgroundColor = [UIColor colorWithRed:186.0/256.0 green:193.0/256.0 blue:179.0/256.0 alpha:1.0];
        
    }
    
    return _lineBelowTextField;
    
}

-(UITapGestureRecognizer *)tapToDismiss {
    
    if ( ! _tapToDismiss )
        _tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss:)];
    
    return _tapToDismiss;
    
}


@end
