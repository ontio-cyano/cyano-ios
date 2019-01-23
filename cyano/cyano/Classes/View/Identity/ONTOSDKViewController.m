//
//  ONTOSDKViewController.m
//  cyano
//
//  Created by Apple on 2019/1/22.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ONTOSDKViewController.h"
#import "ONTIdWebView.h"
@interface ONTOSDKViewController ()
@property (strong, nonatomic) ONTIdWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation ONTOSDKViewController

- (void)dealloc
{
    NSLog(@"ONTOSDKViewController dealloc...");
    [self.webView.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutMainView];
    
    [self initHandler];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)layoutMainView
{
    // Web View
    self.webView = [[ONTIdWebView alloc] init];
   
    //WithFrame:CGRectMake(0.0f, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 34 )];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    [self.webView setURL:@"http://192.168.3.31:8080"];
    // Progress
    [self layoutProgressView];
}

- (void)initHandler{
    [self.webView setAuthenticationCallback:^(NSDictionary * callbackDic) {
        NSLog(@"%@",callbackDic);
    }];
}


#pragma mark - Progress

- (void)layoutProgressView
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1.0f)];
    self.progressView.tintColor = [UIColor colorWithHexString:@"#32A4BE"];
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.webView.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.webView.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1)
        {
            [UIView animateWithDuration:0.2f animations:^ {
                self.progressView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.progressView removeFromSuperview];
            }];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
