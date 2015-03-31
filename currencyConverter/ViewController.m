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

@interface ViewController () {
    
    CGFloat cadRate;
    CGFloat euroRate;
    CGFloat jpyRate;
}

@property (weak, nonatomic) IBOutlet UITextField *txtUsaDollar;
@property (weak, nonatomic) IBOutlet UITextField *txtEuro;
@property (weak, nonatomic) IBOutlet UITextField *txtCanadianDollar;
@property (weak, nonatomic) IBOutlet UITextField *txtJapaneseYen;
@property (weak, nonatomic) IBOutlet UIScrollView *vwScroll;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indNetworkLoading;

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

    [_indNetworkLoading startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                    NSError *error = nil;
                    NSString *urlString = [[NSString stringWithFormat:@"http://api.fixer.io/latest?base=USD"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:urlString];
                    NSData* rateDataJSON = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                    NSDictionary *rateDataDict = [NSJSONSerialization JSONObjectWithData:rateDataJSON options:kNilOptions error:&error];
                    NSDictionary *rates = [rateDataDict objectForKey:@"rates"];
    
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          if (error != nil) {
                                              
                                              NSLog(@"Server error = %@", error.description);
                                              NSLog(@"Using default exchange rates");
                                              
                                              cadRate = canadaDollarExchangeRate;
                                              euroRate = euroExchangeRate;
                                              jpyRate = yenExchangeRate;
                                          }
                                          else {
                                              
                                              cadRate = [[rates objectForKey:@"CAD"] floatValue];
                                              euroRate = [[rates objectForKey:@"EUR"] floatValue];
                                              jpyRate = [[rates objectForKey:@"JPY"] floatValue];
                                              
                                              NSLog(@"CAD Rate = %f", cadRate);
                                              NSLog(@"EUR Rate = %f", euroRate);
                                              NSLog(@"JPY Rate = %f", jpyRate);
                                              
                                              [self updateCurrencyTextFeilds:[_txtUsaDollar.text floatValue]];
                                          }

                                          [_indNetworkLoading stopAnimating];
                                     });//end block
                   });
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Private selectors

- (void) updateCurrencyTextFeilds:(CGFloat)dollar {
    
    _txtCanadianDollar.text = [NSString stringWithFormat:@"%.4f", cadRate * dollar];
    _txtEuro.text = [NSString stringWithFormat:@"%.4f", euroRate * dollar];
    _txtJapaneseYen.text = [NSString stringWithFormat:@"%.4f", jpyRate * dollar];
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
