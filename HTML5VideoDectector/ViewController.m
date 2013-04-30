//
//  ViewController.m
//  HTML5VideoDectector
//
//  Created by alan on 13-4-30.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *addressBar;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *video_src;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // address bar
    self.addressBar = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40.0f, 30.0f)];
    self.addressBar.delegate = self;
    self.addressBar.text = @"http://v.youku.com/v_show/id_XNTIxNTE0MjAw.html";
    self.addressBar.font = [UIFont fontWithName:@"System" size:14.0f];
    
    // go button
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    goButton.frame = CGRectMake(self.addressBar.frame.size.width, 0, 40, 30);
    [goButton addTarget:self action:@selector(addressChanged) forControlEvents:UIControlEventTouchUpInside];
    
    // web view
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.addressBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.addressBar.frame.size.height)];
    self.webView.userInteractionEnabled = YES;
    self.webView.delegate = self;
    self.webView.opaque = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:self.addressBar.text]]];
    
    // add views
    [self.view addSubview:self.addressBar];
    [self.view addSubview:goButton];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark delegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // inject js
    NSLog(@"js Injecting...");
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"js"];
    NSLog(@"%@", jsPath);
    NSString *js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"h5vd"]) {
        // parse video src
        NSString *query = request.URL.query;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        self.video_src = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                             (CFStringRef)[params objectForKey:@"video_src"],
                                                                             CFSTR(""),
                                                                             kCFStringEncodingUTF8);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Play Video ?"
                                                        message:@"Video Detected! Would you like to play this video?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    } else {
        self.video_src = @"";
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self playVideo];
            break;
            
        default:
            break;
    }
}

#pragma mark private methods
- (void)addressChanged
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:self.addressBar.text]]];
}

- (void)playVideo
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:self.video_src]]];
}

@end
