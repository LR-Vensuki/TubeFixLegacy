#line 1 "googleapp/settings.x"
#import <Foundation/Foundation.h>
#import "appheaders.h"
#import "general.h"

@interface YTSettingsViewController : YTBaseViewController_iPhone

+ (id)openSourceLicensesURL;
+ (id)privacyPolicyURL;
+ (id)termsOfServiceURL;
+ (id)helpURL;
- (void)dismissModalViewControllerWithAnimation;
- (id)reuseableCellForTableView:(id)fp8;
- (id)youtubeCellForRow:(int)fp8;
- (id)aboutCellForRow:(int)fp8;
- (id)getSafeSearchString:(int)fp8;
- (id)getHomeFeedContentString:(int)fp8;
- (void)showWebViewWithURL:(id)fp8;
- (void)presentModalViewController:(id)fp8;
- (void)tableView:(id)fp8 didSelectRowAtIndexPath:(id)fp12;
- (int)tableView:(id)fp8 numberOfRowsInSection:(int)fp12;
- (float)tableView:(id)fp8 heightForFooterInSection:(int)fp12;
- (float)tableView:(id)fp8 heightForHeaderInSection:(int)fp12;
- (id)tableView:(id)fp8 viewForHeaderInSection:(int)fp12;
- (int)numberOfSectionsInTableView:(id)fp8;
- (id)tableView:(id)fp8 cellForRowAtIndexPath:(id)fp12;
- (void)showSendFeedbackPopup;
- (void)didSelectItemAtIndex:(id)fp8 inPicker:(id)fp12;
- (void)dealloc;
- (id)initWithServices:(id)fp8 navigation:(id)fp12;

@end


@interface YTSettingsPickerViewController : YTContainerViewController <UITableViewDataSource, UITableViewDelegate>
- (void)tableView:(id)fp8 didSelectRowAtIndexPath:(id)fp12;
- (int)tableView:(id)fp8 numberOfRowsInSection:(int)fp12;
- (int)numberOfSectionsInTableView:(id)fp8;
- (id)tableView:(id)fp8 cellForRowAtIndexPath:(id)fp12;
- (void)setChoiceTarget:(id)fp8 action:(SEL)fp12;
- (void)dealloc;
- (id)init;
- (id)initWithResourceLoader:(id)fp8 title:(id)fp12 items:(id)fp16 selectedItemIndex:(unsigned int)fp20;

@end

@interface GIPWebViewController : NSObject
+ (BOOL)URLValidForSafari:(id)fp8;
- (void)setClearHistoryOnLoad:(BOOL)fp8;
- (BOOL)clearHistoryOnLoad;
- (id)toolbarColor;
- (void)setTimeoutInterval:(double)fp8;
- (double)timeoutInterval;
- (void)setCachePolicy:(unsigned int)fp8;
- (unsigned int)cachePolicy;
- (BOOL)webViewLoaded;
- (void)setWebView:(id)fp8;
- (id)webView;
- (void)setUsePageTitleAsViewTitle:(BOOL)fp8;
- (BOOL)usePageTitleAsViewTitle;
- (void)setToolbar:(id)fp8;
- (id)toolbar;
- (void)setShowsOpenInSafariInToolbar:(BOOL)fp8;
- (BOOL)showsOpenInSafariInToolbar;
- (BOOL)showsToolbar;
- (void)setShowsSpinner:(BOOL)fp8;
- (BOOL)showsSpinner;
- (void)setShowSpinnerInToolbar:(BOOL)fp8;
- (BOOL)showSpinnerInToolbar;
- (void)setAllowBrowserSelection:(BOOL)fp8;
- (BOOL)allowBrowserSelection;
- (void)setShowPromptWhenOpeningSafari:(BOOL)fp8;
- (BOOL)showPromptWhenOpeningSafari;
- (void)setShowErrorPageOnLoadFail:(BOOL)fp8;
- (BOOL)showErrorPageOnLoadFail;
- (void)setRewriteNewWindowLinks:(BOOL)fp8;
- (BOOL)rewriteNewWindowLinks;
- (void)setOpenInSafariURL:(id)fp8;
- (id)openInSafariURL;
- (int)numberOfItemsLoading;
- (void)setInitialRequest:(id)fp8;
- (id)initialRequest;
- (void)setHistory:(id)fp8;
- (id)history;
- (void)setHideToolbarWithoutHistory:(BOOL)fp8;
- (BOOL)hideToolbarWithoutHistory;
- (void)setDetectExternalURLs:(BOOL)fp8;
- (BOOL)detectExternalURLs;
- (id)delegate;
- (void)setCurrentURL:(id)fp8;
- (id)currentURL;
- (void)setCurrentPageTitle:(id)fp8;
- (id)currentPageTitle;
- (void)setToolbarColor:(id)fp8;
- (void)openExternalURL:(id)fp8;
- (void)alertView:(id)fp8 clickedButtonAtIndex:(int)fp12;
- (void)actionSheet:(id)fp8 clickedButtonAtIndex:(int)fp12;
- (void)showBrowserSelectionPrompt;
- (void)showOpenInSafariPrompt;
- (void)openURLInSafari:(id)fp8;
- (id)convertURLToChrome:(id)fp8;
- (BOOL)isChromeInstalled;
- (void)displayErrorMessage:(id)fp8 withReload:(BOOL)fp12;
- (void)hideSpinner;
- (void)showSpinner;
- (void)updateSpinnerFrame;
- (id)spinner;
- (void)didReceiveMemoryWarning;
- (void)didRotateFromInterfaceOrientation:(int)fp8;
- (BOOL)shouldAutorotateToInterfaceOrientation:(int)fp8;
- (void)openInSafari;
- (id)safariURL;
- (void)goForward;
- (void)goBack;
- (void)reload;
- (void)emptyPage;
- (void)callDidExhaustHistoryStack;
- (BOOL)shouldCallDidExhaustHistoryStack;
- (id)getPageTitle;
- (void)addURLToHistory:(id)fp8;
- (void)recordCurrentRequestInHistory;
- (void)webView:(id)fp8 didFailLoadWithError:(id)fp12;
- (void)webViewDidFinishLoad:(id)fp8;
- (void)webViewDidStartLoad:(id)fp8;
- (BOOL)webView:(id)fp8 shouldStartLoadWithRequest:(id)fp12 navigationType:(int)fp16;
- (void)loadRequest:(id)fp8;
- (void)loadURL:(id)fp8;
- (void)loadHTML:(id)fp8 baseURL:(id)fp12;
- (id)createWebViewIfNeeded;
- (void)showsOpenInSafariInToolbar:(BOOL)fp8;
- (void)setShowsToolbar:(BOOL)fp8;
- (void)setDelegate:(id)fp8;
- (struct CGRect)toolbarFrame;
- (struct CGRect)webViewFrame;
- (void)setWebViewFrame:(struct CGRect)fp8;
- (void)updateToolbarState;
- (void)setSafariButtonEnabled:(BOOL)fp8;
- (void)setReloadButtonEnabled:(BOOL)fp8;
- (void)setForwardButtonEnabled:(BOOL)fp8;
- (void)setBackButtonEnabled:(BOOL)fp8;
- (void)unloadToolbar;
- (void)loadToolbar;
- (void)viewDidUnload;
- (void)loadView;
- (void)dealloc;
- (id)initWithDelegate:(id)fp8 loader:(id)fp12 webViewClass:(Class)fp16 clearHistoryOnLoad:(BOOL)fp20;
- (id)initWithDelegate:(id)fp8 loader:(id)fp12 webViewClass:(Class)fp16;
- (id)initWithDelegate:(id)fp8 loader:(id)fp12;
- (id)initWithDelegate:(id)fp8;
- (id)init;

@end

@interface YTSettingsTableControllerDelegate
-(void)presentViewController:(id)fp8;
@end

@interface YTWebViewController : NSObject
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

__asm__(".linker_option \"-framework\", \"CydiaSubstrate\"");

@class YTSettingsTableController; @class YTSettingsViewController; @class GIPWebViewController; @class YTWebViewController; @class GIPResourceLoader; 
static void (*_logos_orig$_ungrouped$YTSettingsViewController$showWebViewWithURL$)(_LOGOS_SELF_TYPE_NORMAL YTSettingsViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$YTSettingsViewController$showWebViewWithURL$(_LOGOS_SELF_TYPE_NORMAL YTSettingsViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$YTSettingsTableController$showWebViewWithURL$)(_LOGOS_SELF_TYPE_NORMAL YTSettingsTableController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$YTSettingsTableController$showWebViewWithURL$(_LOGOS_SELF_TYPE_NORMAL YTSettingsTableController* _LOGOS_SELF_CONST, SEL, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GIPResourceLoader(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GIPResourceLoader"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTWebViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTWebViewController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GIPWebViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GIPWebViewController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTSettingsViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTSettingsViewController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTSettingsTableController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTSettingsTableController"); } return _klass; }
#line 160 "googleapp/settings.x"





    




static void _logos_method$_ungrouped$YTSettingsViewController$showWebViewWithURL$(_LOGOS_SELF_TYPE_NORMAL YTSettingsViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id url) {
    NSURL *targetURL = [_logos_static_class_lookup$YTSettingsViewController() openSourceLicensesURL];
    if (![[url standardizedURL] isEqual:[targetURL standardizedURL]]) {
        return _logos_orig$_ungrouped$YTSettingsViewController$showWebViewWithURL$(self, _cmd, url);
    }
  GIPWebViewController *webView = nil;

  if ([version() characterAtIndex:0] == '1') {
      GIPResourceLoader *resourseLoader = [[[_logos_static_class_lookup$GIPResourceLoader() alloc] initWithBundleName:@"GIPWebViewResources.bundle"] autorelease];
      webView = [[[_logos_static_class_lookup$GIPWebViewController() alloc] initWithDelegate:nil loader:resourseLoader] autorelease];
  } else {
      webView = [[[_logos_static_class_lookup$GIPWebViewController() alloc] initWithDelegate:[_logos_static_class_lookup$YTWebViewController() alloc]] autorelease];
  }

  [webView setToolbarColor:[UIColor backgroundDarkColor]];
  [webView loadURL:url];

  if (TRIsVersion2x()) {
      [(YTSettingsTableControllerDelegate*)[self valueForKey:l(@"delegate")] presentViewController:webView];
  } else {
      [self presentModalViewController:webView];
  }

  NSData* injectData = [NSData dataWithContentsOfFile:@"/Library/Application Support/TubeFixLegacy/licenseinject.html"];
  NSString* injectString = [[NSString alloc] initWithBytes:[injectData bytes]
                                              length:[injectData length]
                                            encoding:NSUTF8StringEncoding];

  injectString = [[[injectString stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];

  NSString *jsToRun = [NSString stringWithFormat:@"window.addEventListener('load', function () {document.body.insertAdjacentHTML('afterbegin', '%@');});", injectString];
  NSLog(@"jsToRun -> %@", jsToRun);


  [(UIWebView*)[webView webView] stringByEvaluatingJavaScriptFromString:jsToRun];

}





static void _logos_method$_ungrouped$YTSettingsTableController$showWebViewWithURL$(_LOGOS_SELF_TYPE_NORMAL YTSettingsTableController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id url) {
    NSURL *targetURL = [_logos_static_class_lookup$YTSettingsTableController() openSourceLicensesURL];
    if (![[url standardizedURL] isEqual:[targetURL standardizedURL]]) {
        return _logos_orig$_ungrouped$YTSettingsTableController$showWebViewWithURL$(self, _cmd, url);
    }
  GIPResourceLoader *resourseLoader = [[[_logos_static_class_lookup$GIPResourceLoader() alloc] initWithBundleName:@"GIPWebViewResources.bundle"] autorelease];
  GIPWebViewController *webView = [[[_logos_static_class_lookup$GIPWebViewController() alloc] initWithDelegate:nil loader:resourseLoader] autorelease];
  [webView setToolbarColor:[UIColor backgroundDarkColor]];
  [webView loadURL:url];
  
  [(YTSettingsTableControllerDelegate*)[self valueForKey:l(@"delegate")] presentViewController:webView];
    NSData* injectData = [NSData dataWithContentsOfFile:@"/Library/Application Support/TubeFixLegacy/licenseinject.html"];
  NSString* injectString = [[NSString alloc] initWithBytes:[injectData bytes]
                                              length:[injectData length]
                                            encoding:NSUTF8StringEncoding];

  injectString = [[[injectString stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];

  NSString *jsToRun = [NSString stringWithFormat:@"window.addEventListener('load', function () {document.body.insertAdjacentHTML('afterbegin', '%@');});", injectString];
  NSLog(@"jsToRun -> %@", jsToRun);


  [(UIWebView*)[webView webView] stringByEvaluatingJavaScriptFromString:jsToRun];

}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTSettingsViewController = objc_getClass("YTSettingsViewController"); { MSHookMessageEx(_logos_class$_ungrouped$YTSettingsViewController, @selector(showWebViewWithURL:), (IMP)&_logos_method$_ungrouped$YTSettingsViewController$showWebViewWithURL$, (IMP*)&_logos_orig$_ungrouped$YTSettingsViewController$showWebViewWithURL$);}Class _logos_class$_ungrouped$YTSettingsTableController = objc_getClass("YTSettingsTableController"); { MSHookMessageEx(_logos_class$_ungrouped$YTSettingsTableController, @selector(showWebViewWithURL:), (IMP)&_logos_method$_ungrouped$YTSettingsTableController$showWebViewWithURL$, (IMP*)&_logos_orig$_ungrouped$YTSettingsTableController$showWebViewWithURL$);}} }
#line 239 "googleapp/settings.x"
