//
//  ViewController.m
//  currencyConverter
//
//  Created by Thomas DiZoglio on 3/29/15.
//  Copyright (c) 2015 Thomas DiZoglio. All rights reserved.
//

#import "ViewController.h"

static const CGFloat canadaDollarExchangeRate = 1.26;
static const CGFloat euroExchangeRate = 1.10;
static const CGFloat yenExchangeRate = 119.24;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUsaDollar;
@property (weak, nonatomic) IBOutlet UITextField *txtEuro;
@property (weak, nonatomic) IBOutlet UITextField *txtCanadianDollar;
@property (weak, nonatomic) IBOutlet UITextField *txtJapaneseYen;
@property (weak, nonatomic) IBOutlet UIScrollView *vwScroll;

@end

@implementation ViewController

#pragma mark - View handlers

- (void)viewDidLoad {

    [super viewDidLoad];

    // Handle hiding keyboard - Use tap gesture because of scroll view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [_vwScroll addGestureRecognizer:tap];

    // Initialize the US Dollar to "1"
    _txtUsaDollar.text = @"1";
    [self updateCurrencyTextFeilds:[_txtUsaDollar.text floatValue]];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Private selectors

- (void) updateCurrencyTextFeilds:(CGFloat)dollar {
    
    _txtCanadianDollar.text = [NSString stringWithFormat:@"%.4f", dollar / canadaDollarExchangeRate];
    _txtEuro.text = [NSString stringWithFormat:@"%.4f", dollar / euroExchangeRate];
    _txtJapaneseYen.text = [NSString stringWithFormat:@"%.4f", dollar / yenExchangeRate];
}

#pragma mark - UITapGestureRecognizer handler

- (void)hideKeyboard:(id)senbder {
    
    [_txtUsaDollar resignFirstResponder];
    [_txtEuro resignFirstResponder];
    [_txtCanadianDollar resignFirstResponder];
    [_txtJapaneseYen resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    // Recalculate the other textfields to show new values after dollar changes
    CGFloat newUSDollar = [_txtUsaDollar.text floatValue];
    [self updateCurrencyTextFeilds:newUSDollar];
}

@end
