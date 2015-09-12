//
//  ViewController.m
//  Demo
//
//  Created by Jhonathan Wyterlin on 05/09/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ViewController.h"

#import "JWTextField.h"

@interface ViewController ()

@property(nonatomic,strong) JWTextField *textfield;

@end

@implementation ViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.textfield];
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Creating components

-(JWTextField *)textfield {
    
    if ( ! _textfield ) {
        _textfield = [JWTextField new];
    }
    
    return _textfield;
    
}

@end
