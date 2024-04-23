//
//  ViewController.m
//  OcH5Demo
//
//  Created by b77 on 2024/4/9.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CommonCrypto/CommonDigest.h"

 

@interface ViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,strong)WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //3个js交互接口 1.获取imei 2.获取afid 3.外跳浏览器接口
    [userContentController addScriptMessageHandler:self name:@"getImei"];
    [userContentController addScriptMessageHandler:self name:@"getAfid"];
    [userContentController addScriptMessageHandler:self name:@"openUrl"];
    configuration.userContentController = userContentController;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    _webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_webView];

    if (@available(iOS 11.0, *)){
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    //测试链接
    NSURL *url = [NSURL URLWithString:@"http://fjks.rffzgnq.xyz/?web_PackageName=iw.iwillook.casino"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *url = navigationAction.request.URL;
    if([url.absoluteString containsString:@"openurl"]){
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString *name = message.name;
    if ([name isEqualToString:@"getImei"]) {
        NSString *imei = [self getIMEIid];
        NSString *jsStr = [NSString stringWithFormat:@"getImeiCallback('%@')", imei];
        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    } else if ([name isEqualToString:@"getAfid"]) {
        NSString *af = [[AppsFlyerLib shared] getAppsFlyerUID];
        NSString *jsStr = [NSString stringWithFormat:@"getAfidCallback('%@')", af];
        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    }else if([name isEqualToString:@"openUrl"]){
        NSString *urlString = message.body;
        NSURL*url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

    }
}

//此接口为获取设备唯一标识 根据设备标识识别用户id 确保每次运行和删除卸载后用户重新安装都能返回原来的值就行 长度大小32位
-(NSString *)getIMEIid {
    NSString* pkgName = [[NSBundle mainBundle] bundleIdentifier];
    NSString* imei = nil;
    NSMutableDictionary *kc_dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: (id)kSecClassGenericPassword,(id)kSecClass, pkgName, (id)kSecAttrService, pkgName, (id)kSecAttrAccount,(id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
    [kc_dic setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [kc_dic setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef dataKey = NULL;
    OSStatus ss =  SecItemCopyMatching((CFDictionaryRef)kc_dic, (CFTypeRef *)&dataKey);
    if (ss == noErr) {
        @try {
            imei = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)dataKey];
        } @catch (NSException *e) {
            imei = @"";
        }
    }
    else if (ss != errSecItemNotFound) {
        imei = @"";
    }
    if (dataKey){
        CFRelease(dataKey);
    }

    if (imei == nil || imei.length == 0) {
        CFUUIDRef uuidref = CFUUIDCreate(nil);
        CFStringRef uuidrefStr = CFUUIDCreateString(nil, uuidref);
        NSString* uuidStr = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidrefStr));
        CFRelease(uuidref);
        CFRelease(uuidrefStr);
        
        const char *uuidStr_str = [uuidStr UTF8String];
        unsigned char md5[CC_MD5_DIGEST_LENGTH];
        CC_MD5(uuidStr_str, (CC_LONG)strlen(uuidStr_str), md5);
        NSMutableString *mutable_str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [mutable_str appendFormat:@"%02x", md5[i]];
        }
        imei = mutable_str;
        
        NSMutableDictionary *kc_dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,pkgName, (id)kSecAttrService,pkgName, (id)kSecAttrAccount,(id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,nil];
        SecItemDelete((CFDictionaryRef)kc_dic2);
        [kc_dic2 setObject:[NSKeyedArchiver archivedDataWithRootObject:imei] forKey:(id)kSecValueData];
        SecItemAdd((CFDictionaryRef)kc_dic2, NULL);
    }
    return imei;
}
@end
