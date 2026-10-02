#line 1 "googleapp/signin.x"
#include <Foundation/Foundation.h>
#import "signinpolyfil.h"
#import <CommonCrypto/CommonDigest.h>
#include "appheaders.h"
#include "general.h"
#include "Translators/TRJSONUtils.h"

#import <execinfo.h>



static id gTRUserAuthenticator = nil;   
static id gTRLastUsedAuth = nil;        

static void TRRememberAuth(id auth) {
  if (auth && auth != gTRLastUsedAuth && [auth respondsToSelector:@selector(sid)]) {
    [gTRLastUsedAuth release];
    gTRLastUsedAuth = [auth retain];
  }
}

id TRCurrentSignedInAuth(void) {
  id auth = nil;
  if (gTRUserAuthenticator) {
    if ([gTRUserAuthenticator respondsToSelector:@selector(isAuthenticated)] && ![(YTUserAuthenticator *)gTRUserAuthenticator isAuthenticated]) {
      return nil;
    }
    id authentication = [gTRUserAuthenticator respondsToSelector:@selector(authentication)] ? [(YTUserAuthenticator *)gTRUserAuthenticator authentication] : nil;
    
    auth = [authentication respondsToSelector:@selector(identity)] ? [[(SSOAuthorizationImpl *)authentication identity] auth] : authentication;
  }
  if (![auth respondsToSelector:@selector(canAuthorize)]) {
    auth = gTRLastUsedAuth;
  }
  return ([auth respondsToSelector:@selector(canAuthorize)] && [(GTMOAuth2Authentication *)auth canAuthorize]) ? auth : nil;
}


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

@class GTMOAuth2ViewControllerTouch; @class GTMHTTPFetcher; @class AuthorizerCallback; @class SSOService; @class SSOAuthorizationImpl; @class SSOKeychain; @class SSOAuthAdvice; @class GTMOAuth2SignIn; @class GTMOAuth2Authentication; @class GTMOAuth2SignInInternal; @class YTUserAuthenticator; @class SSOIdentityPrivate; 
static YTUserAuthenticator* (*_logos_orig$_ungrouped$YTUserAuthenticator$init)(_LOGOS_SELF_TYPE_INIT YTUserAuthenticator*, SEL) _LOGOS_RETURN_RETAINED; static YTUserAuthenticator* _logos_method$_ungrouped$YTUserAuthenticator$init(_LOGOS_SELF_TYPE_INIT YTUserAuthenticator*, SEL) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$SSOIdentityPrivate$requestAuthAdviceReauthenticating$callback$)(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL, id, void (^)(SSOAuthAdvice *, NSError*)); static void _logos_method$_ungrouped$SSOIdentityPrivate$requestAuthAdviceReauthenticating$callback$(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL, id, void (^)(SSOAuthAdvice *, NSError*)); static NSDictionary* (*_logos_orig$_ungrouped$SSOIdentityPrivate$keychainItem)(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL); static NSDictionary* _logos_method$_ungrouped$SSOIdentityPrivate$keychainItem(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL); static SSOIdentityPrivate* (*_logos_orig$_ungrouped$SSOIdentityPrivate$initWithConfiguration$keychainItem$)(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL, id, NSDictionary*); static SSOIdentityPrivate* _logos_method$_ungrouped$SSOIdentityPrivate$initWithConfiguration$keychainItem$(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL, id, NSDictionary*); static id (*_logos_orig$_ungrouped$SSOIdentityPrivate$revokeToken$)(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL, void(^)(NSError* error)); static id _logos_method$_ungrouped$SSOIdentityPrivate$revokeToken$(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST, SEL, void(^)(NSError* error)); static void (*_logos_orig$_ungrouped$SSOService$requestProfileForIdentity$callback$)(_LOGOS_SELF_TYPE_NORMAL SSOService* _LOGOS_SELF_CONST, SEL, SSOIdentityPrivate *, void (^)(id profile, NSError *error)); static void _logos_method$_ungrouped$SSOService$requestProfileForIdentity$callback$(_LOGOS_SELF_TYPE_NORMAL SSOService* _LOGOS_SELF_CONST, SEL, SSOIdentityPrivate *, void (^)(id profile, NSError *error)); static id (*_logos_orig$_ungrouped$SSOService$terribleHackyResizedPhotoURL$byAddingSize$)(_LOGOS_SELF_TYPE_NORMAL SSOService* _LOGOS_SELF_CONST, SEL, id, unsigned int); static id _logos_method$_ungrouped$SSOService$terribleHackyResizedPhotoURL$byAddingSize$(_LOGOS_SELF_TYPE_NORMAL SSOService* _LOGOS_SELF_CONST, SEL, id, unsigned int); static BOOL (*_logos_meta_orig$_ungrouped$SSOKeychain$writeSharedKeychain$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSDictionary*, NSError**); static BOOL _logos_meta_method$_ungrouped$SSOKeychain$writeSharedKeychain$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSDictionary*, NSError**); static NSDictionary* (*_logos_meta_orig$_ungrouped$SSOKeychain$queryMatchingID$serviceName$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSString*); static NSDictionary* _logos_meta_method$_ungrouped$SSOKeychain$queryMatchingID$serviceName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSString*); static NSDictionary* (*_logos_meta_orig$_ungrouped$SSOKeychain$queryAllMatching)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSDictionary* _logos_meta_method$_ungrouped$SSOKeychain$queryAllMatching(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSDictionary* (*_logos_meta_orig$_ungrouped$SSOKeychain$deleteQueryMatchingID$serviceName$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSString*); static NSDictionary* _logos_meta_method$_ungrouped$SSOKeychain$deleteQueryMatchingID$serviceName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSString*); static NSURL* (*_logos_meta_orig$_ungrouped$GTMOAuth2SignInInternal$googleAuthorizationURL)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSURL* _logos_meta_method$_ungrouped$GTMOAuth2SignInInternal$googleAuthorizationURL(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$GTMOAuth2SignInInternal$generateSelectAccountPageWithSID$hsid$ssid$sapisid$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignInInternal* _LOGOS_SELF_CONST, SEL, NSString*, NSString*, NSString*, NSString*); static BOOL (*_logos_orig$_ungrouped$GTMOAuth2SignInInternal$cookiesChanged$)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignInInternal* _LOGOS_SELF_CONST, SEL, GTMCookieStorage*); static BOOL _logos_method$_ungrouped$GTMOAuth2SignInInternal$cookiesChanged$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignInInternal* _LOGOS_SELF_CONST, SEL, GTMCookieStorage*); static void (*_logos_orig$_ungrouped$SSOAuthorizationImpl$authorizeRequest$handler$delegate$didFinishSelector$)(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST, SEL, NSMutableURLRequest*, id, id, SEL); static void _logos_method$_ungrouped$SSOAuthorizationImpl$authorizeRequest$handler$delegate$didFinishSelector$(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST, SEL, NSMutableURLRequest*, id, id, SEL); static NSString* _logos_method$_ungrouped$SSOAuthorizationImpl$channelID(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$SSOAuthorizationImpl$pageID(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$SSOAuthorizationImpl$loginInfo(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$sid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$hsid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$ssid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$sapisid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$sidcc(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$datasyncID(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$channelID(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$pageID(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$loginInfo(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$GTMOAuth2Authentication$canAuthorize)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$GTMOAuth2Authentication$canAuthorize(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$_ungrouped$GTMOAuth2Authentication$persistenceResponseString)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static id _logos_method$_ungrouped$GTMOAuth2Authentication$persistenceResponseString(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$_ungrouped$GTMOAuth2Authentication$beginTokenFetchWithDelegate$didFinishSelector$)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, id, SEL); static id _logos_method$_ungrouped$GTMOAuth2Authentication$beginTokenFetchWithDelegate$didFinishSelector$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, id, SEL); static void _logos_method$_ungrouped$GTMOAuth2Authentication$fillInTokenExtraDataWithParameters$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, NSDictionary*); static void (*_logos_orig$_ungrouped$GTMOAuth2Authentication$tokenFetcher$finishedWithData$error$)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, GTMHTTPFetcher*, NSData*, NSError*); static void _logos_method$_ungrouped$GTMOAuth2Authentication$tokenFetcher$finishedWithData$error$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, GTMHTTPFetcher*, NSData*, NSError*); static BOOL _logos_method$_ungrouped$GTMOAuth2Authentication$authorizeNSRequest$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, NSMutableURLRequest **); static BOOL (*_logos_orig$_ungrouped$GTMOAuth2Authentication$authorizeRequestImmediateArgs$)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, GTMOAuth2AuthorizationArgs*); static BOOL _logos_method$_ungrouped$GTMOAuth2Authentication$authorizeRequestImmediateArgs$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST, SEL, GTMOAuth2AuthorizationArgs*); static void (*_logos_orig$_ungrouped$GTMOAuth2SignIn$fetchGoogleUserInfo)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignIn* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$GTMOAuth2SignIn$fetchGoogleUserInfo(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignIn* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$GTMHTTPFetcher$addCookiesToRequest$)(_LOGOS_SELF_TYPE_NORMAL GTMHTTPFetcher* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$GTMHTTPFetcher$addCookiesToRequest$(_LOGOS_SELF_TYPE_NORMAL GTMHTTPFetcher* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$GTMOAuth2ViewControllerTouch$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2ViewControllerTouch* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$GTMOAuth2ViewControllerTouch$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2ViewControllerTouch* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$GTMOAuth2ViewControllerTouch$webViewDidStartLoad$)(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2ViewControllerTouch* _LOGOS_SELF_CONST, SEL, UIWebView *); static void _logos_method$_ungrouped$GTMOAuth2ViewControllerTouch$webViewDidStartLoad$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2ViewControllerTouch* _LOGOS_SELF_CONST, SEL, UIWebView *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SSOAuthAdvice(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SSOAuthAdvice"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$AuthorizerCallback(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("AuthorizerCallback"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GTMOAuth2Authentication(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GTMOAuth2Authentication"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SSOKeychain(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SSOKeychain"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GTMHTTPFetcher(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GTMHTTPFetcher"); } return _klass; }
#line 38 "googleapp/signin.x"

static YTUserAuthenticator* _logos_method$_ungrouped$YTUserAuthenticator$init(_LOGOS_SELF_TYPE_INIT YTUserAuthenticator* __unused self, SEL __unused _cmd) _LOGOS_RETURN_RETAINED {
  id authenticator = _logos_orig$_ungrouped$YTUserAuthenticator$init(self, _cmd);
  if (authenticator) {
    [gTRUserAuthenticator release];
    gTRUserAuthenticator = [authenticator retain];
  }
  return authenticator;
}



static void _logos_method$_ungrouped$SSOIdentityPrivate$requestAuthAdviceReauthenticating$callback$(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id a3, void (^callback)(SSOAuthAdvice *, NSError*)) {
    NSString *email = [self userEmail];
    BOOL isSignedIn = ([email length] != 0);

    if (isSignedIn) { 
        return _logos_orig$_ungrouped$SSOIdentityPrivate$requestAuthAdviceReauthenticating$callback$(self, _cmd, a3, callback);
    }
    

    SSOAuthAdvice *authAdvice = [_logos_static_class_lookup$SSOAuthAdvice() alloc];







    [authAdvice setValue:[NSURL URLWithString:@"https://accounts.google.com/ServiceLogin?service=youtube&uilel=3&passive=true&continue=https://m.youtube.com/ytscframe&app=m&hl=en&next=%2F&hl=en&flowName=WebLiteSignIn"] forKey:l(@"URI")];
    [authAdvice setValue:@(2) forKey:l(@"adviceCode")]; 
    [authAdvice setValue:@"ChIiEAiDoPbg0jIQ-tua6twzGCESAzAuMQ" forKey:l(@"clientState")]; 

    [_logos_static_class_lookup$SSOKeychain() setAuthAdviceState:@"ChIiEAiDoPbg0jIQ-tua6twzGCESAzAuMQ" error:nil];

    callback(authAdvice, nil);

  
  
  
  
  
  
  
  
  

  
}


static NSDictionary* _logos_method$_ungrouped$SSOIdentityPrivate$keychainItem(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  GTMOAuth2Authentication *auth = [self auth];

  if ([[auth sid] length] > 0) {
    NSDictionary *fun = @{
        (__bridge id)kSecAttrAccount:[auth datasyncID],
        (__bridge id)kSecValueData:[[auth persistenceResponseString] dataUsingEncoding:NSUTF8StringEncoding]
      };
      return fun;
  }
  return nil;
}
static SSOIdentityPrivate* _logos_method$_ungrouped$SSOIdentityPrivate$initWithConfiguration$keychainItem$(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id configuration, NSDictionary* keychainItem) {
  SSOIdentityPrivate *identity = [self initWithConfiguration:configuration];
  if ( identity )
  {
    NSData *keychainData = [keychainItem objectForKey:(__bridge id)kSecValueData];
    if ( keychainData )
    {
      NSDictionary *decodedData = [_logos_static_class_lookup$GTMOAuth2Authentication() dictionaryWithResponseString:[[NSString alloc] initWithData:keychainData encoding:4]];
      GTMOAuth2Authentication *auth = [identity auth];
      [auth setParameters:decodedData]; 
      if ([decodedData[@"fullName"] length]) {
        [self setUserFullName:decodedData[@"fullName"]];
      }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
  }
  return identity;
}


















static id _logos_method$_ungrouped$SSOIdentityPrivate$revokeToken$(_LOGOS_SELF_TYPE_NORMAL SSOIdentityPrivate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void(^callback)(NSError* error))  {
    callback(nil);
    [self setAuth:nil];
    return nil; 
}




static void _logos_method$_ungrouped$SSOService$requestProfileForIdentity$callback$(_LOGOS_SELF_TYPE_NORMAL SSOService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, SSOIdentityPrivate * identity, void (^callback)(id profile, NSError *error)) {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://m.youtube.com/getAccountSwitcherEndpoint"]]; 
    GTMHTTPFetcher *fetcher = [_logos_static_class_lookup$GTMHTTPFetcher() fetcherWithRequest:request];

    [fetcher setAuthorizer:[identity auth]];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *response, NSError *error) {
        if (error != nil) {
            callback(nil, error);
            return;
        }

        
        const unsigned char* bytes = [response bytes];
        NSUInteger length = [response length];
        NSData *cleanData = nil;
        if (length >= 5 &&  
            bytes[0] == ')' && 
            bytes[1] == ']' && 
            bytes[2] == '}' && 
            bytes[3] == '\'' && 
            bytes[4] == '\n') {
            bytes += 5;
            length -= 5;
            cleanData = [NSData dataWithBytes:bytes length:length];
        } else {
          cleanData = [response copy];
        }

        if (cleanData == nil || [cleanData length] == 0) {
            callback(nil, [NSError errorWithDomain:@"com.google.sso" code:-206 userInfo:nil]);
            return;
        }

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:cleanData options:0 error:&error];
        if (error != nil) {
            
            callback(nil, error);
            return;
        }

        NSString *name = [TRJSONUtils stringFromJSON:json 
            keyPath:@"data.actions[0].getMultiPageMenuAction.menu.multiPageMenuRenderer.sections[0].accountSectionListRenderer.header.googleAccountHeaderRenderer.name.simpleText"];
        NSString *picture = [TRJSONUtils stringFromJSON:json keyPath:@"data.actions[0].getMultiPageMenuAction.menu.multiPageMenuRenderer.sections[0].accountSectionListRenderer.contents[0].accountItemSectionRenderer.contents[0].accountItem.accountPhoto.thumbnails[0].url"];
        if (name == nil) {
            callback(nil, [NSError errorWithDomain:@"com.google.sso" code:-206 userInfo:nil]);
            return;
        }

        callback(@{
          @"id": [identity userID],
          @"email": [identity userEmail],
          @"verified_email": @YES,
          @"name": name,
          @"given_name": name,
          @"family_name": name, 
          @"picture": picture ? picture : @"https://ssl.gstatic.com/accounts/ui/avatar_2x.png", 
          @"locale": @"en" 
      }, nil);
    }];
}



static id _logos_method$_ungrouped$SSOService$terribleHackyResizedPhotoURL$byAddingSize$(_LOGOS_SELF_TYPE_NORMAL SSOService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id url, unsigned int size) {
  return url;
}














static BOOL _logos_meta_method$_ungrouped$SSOKeychain$writeSharedKeychain$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary* keys, NSError** error) {
  NSMutableDictionary *mutableKeys = [keys mutableCopy];
  [mutableKeys setObject:[[mutableKeys objectForKey:(NSString *)kSecAttrService] stringByReplacingOccurrencesOfString:@"com.google." withString:@"dev.preloading.tubereplacer."] forKey:(NSString *)kSecAttrService];
  return _logos_meta_orig$_ungrouped$SSOKeychain$writeSharedKeychain$error$(self, _cmd, mutableKeys, error);
}

static NSDictionary* _logos_meta_method$_ungrouped$SSOKeychain$queryMatchingID$serviceName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id matchingId, NSString* serviceName) {
  return _logos_meta_orig$_ungrouped$SSOKeychain$queryMatchingID$serviceName$(self, _cmd, matchingId, [serviceName stringByReplacingOccurrencesOfString:@"com.google." withString:@"dev.preloading.tubereplacer."]);
}

static NSDictionary* _logos_meta_method$_ungrouped$SSOKeychain$queryAllMatching(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  id orig = _logos_meta_orig$_ungrouped$SSOKeychain$queryAllMatching(self, _cmd);
  [orig setObject:[[orig objectForKey:(NSString *)kSecAttrService] stringByReplacingOccurrencesOfString:@"com.google." withString:@"dev.preloading.tubereplacer."] forKey:(NSString *)kSecAttrService];
  return orig;
}

static NSDictionary* _logos_meta_method$_ungrouped$SSOKeychain$deleteQueryMatchingID$serviceName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id matchingId, NSString* serviceName) {
  return _logos_meta_orig$_ungrouped$SSOKeychain$deleteQueryMatchingID$serviceName$(self, _cmd, matchingId, [serviceName stringByReplacingOccurrencesOfString:@"com.google." withString:@"dev.preloading.tubereplacer."]);
}





static NSURL* _logos_meta_method$_ungrouped$GTMOAuth2SignInInternal$googleAuthorizationURL(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return [NSURL URLWithString:@"https://accounts.google.com/ServiceLogin?service=youtube&uilel=3&passive=true&continue=https://www.youtube.com/ytscframe&app=m&hl=en&next=%2F&hl=en&flowName=WebLiteSignIn"];
}


static void _logos_method$_ungrouped$GTMOAuth2SignInInternal$generateSelectAccountPageWithSID$hsid$ssid$sapisid$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignInInternal* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* sid, NSString* hsid, NSString* ssid, NSString* sapisid) {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://m.youtube.com/getAccountSwitcherEndpoint"]]; 

  NSString *cookieData = [NSString stringWithFormat:@"hideBrowserUpgradeBox=true; HSID=%@; SSID=%@; SAPISID=%@; __Secure-3PAPISID=%@; SID=%@", hsid,ssid,sapisid,sapisid,sid];
  [request setValue:cookieData forHTTPHeaderField:@"Cookie"];

  [NSURLConnection sendAsynchronousRequest:request 
                                      queue:[NSOperationQueue mainQueue] 
                          completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      NSString *htmlString = @"";
      if (error) {
          htmlString = [NSString stringWithFormat:@"<html><body>Something went wrong. %@", error];
          NSLog(@"Error: %@", error.localizedDescription);
      } else {
          NSData *cleanData = [NSData dataWithBytes:([data bytes] + 5) length:([data length]-5)];
          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:cleanData options:NSJSONReadingMutableContainers error:nil];

          NSArray *accounts = [TRJSONUtils arrayFromJSON:json keyPath:@"data.actions[0].getMultiPageMenuAction.menu.multiPageMenuRenderer.sections[0].accountSectionListRenderer.contents[0].accountItemSectionRenderer.contents"];

          
          
          NSMutableString *allAccountsHTML = [[NSMutableString alloc] init];
          for (NSDictionary *account in accounts) {
              if (![TRJSONUtils stringFromJSON:account keyPath:@"accountItem.accountName.simpleText"]) continue;
              NSLog(@"account -> %@", account);
              

              NSString *pageId = [TRJSONUtils stringFromJSON:account keyPath:@"accountItem.serviceEndpoint.selectActiveIdentityEndpoint.supportedTokens[0].pageIdToken.pageId"];
              if (!pageId) {
                pageId = @"None";
              }

              NSString *accountElement = [NSString stringWithFormat:@"<li class=\"active-session-account\">"
                                  "<button onclick=\"javascript:selectAccount('%@')\">"
                                  "<img class=\"account-image\" alt=\"\" src=\"%@\">" 
                                  "<span class=\"account-name\">%@</span>" 
                                  "<span class=\"account-email\">%@</span>" 
                                  "</button>"
                                  "</li>", 
                                  pageId,
                                  [TRJSONUtils stringFromJSON:account keyPath:@"accountItem.accountPhoto.thumbnails[0].url"],
                                  [TRJSONUtils stringFromJSON:account keyPath:@"accountItem.accountName.simpleText"],
                                  [TRJSONUtils stringFromJSON:account keyPath:@"accountItem.channelHandle.simpleText"]
              ];

              [allAccountsHTML appendString:accountElement];
          }
          NSError *err = nil;
          NSString *baseHTML = [NSString stringWithContentsOfFile:@"/Library/Application Support/TubeFixLegacy/account_selector.html" encoding:NSUTF8StringEncoding error:&err];
          htmlString = [baseHTML stringByReplacingOccurrencesOfString:@"{{ SPECIAL_TUBEREPLACER_ACCOUNTS_FIELD }}" withString:allAccountsHTML];


          htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{ SPECIAL_TUBEREPLACER_SIDCC_FIELD }}" withString:allAccountsHTML]; 
        }

        
        NSHTTPCookieStorage *browserCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *urlCookies = [browserCookies cookiesForURL:[NSURL URLWithString:@"https://m.youtube.com/ytscframe"]];

        for (NSHTTPCookie* cookie in urlCookies) {
            NSString *cookieName = [cookie name];
            if ([cookieName isEqual:@"SID"]) {
                continue;
            }
            if ([cookieName isEqual:@"HSID"]) {
                continue;
            }
            if ([cookieName isEqual:@"SSID"]) {
                continue;
            }
            if ([cookieName isEqual:@"SAPISID"]) {
                continue;
            }
            if ([cookieName isEqual:@"SIDCC"]) {
                continue;
            }
            if ([cookieName isEqual:@"__Secure-3PAPISID"]) { 
                continue;
            }
            if ([cookieName isEqual:@"tubereplacer_account_selected"]) {
                continue;
            }
            if ([cookieName isEqual:@"LOGIN_INFO"]) {
                continue;
            }
            [browserCookies deleteCookie:cookie];
        }

        
        UIWebView *webView = [(GTMOAuth2ViewControllerTouch*)[self delegate] webView];
        [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"https://m.youtube.com/ytscframe?tubereplacer_next_login=1"]];
  }];

  


}

static BOOL _logos_method$_ungrouped$GTMOAuth2SignInInternal$cookiesChanged$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignInInternal* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, GTMCookieStorage* cookieStorage) {

    
    NSURL *authorizationURL = [NSURL URLWithString:@"https://m.youtube.com/ytscframe"];
    NSLog(@"authorization URL: %@", authorizationURL);
    NSArray *cookies = [cookieStorage cookiesForURL:authorizationURL];
    NSHTTPCookie *sid = nil;
    NSHTTPCookie *hsid = nil;
    NSHTTPCookie *ssid = nil;
    NSHTTPCookie *sapisid = nil;
    NSHTTPCookie *sidcc = nil;
    NSHTTPCookie *logininfo = nil;
    NSHTTPCookie *pageid = nil;
    for (NSHTTPCookie* cookie in cookies) {
        NSString *cookieName = [cookie name];
        if ([cookieName isEqual:@"SID"]) {
            sid = cookie;
        }
        if ([cookieName isEqual:@"HSID"]) {
            hsid = cookie;
        }
        if ([cookieName isEqual:@"SSID"]) {
            ssid = cookie;
        }
        if ([cookieName isEqual:@"SAPISID"]) {
            sapisid = cookie;
        }
        if ([cookieName isEqual:@"SIDCC"]) {
            sidcc = cookie;
        }
        if ([cookieName isEqual:@"__Secure-3PAPISID"]) { 
            sapisid = cookie;
        }
        if ([cookieName isEqual:@"tubereplacer_account_selected"]) {
            pageid = cookie;
        }
        if ([cookieName isEqual:@"LOGIN_INFO"]) {
            logininfo = cookie;
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    

    BOOL result = 0;
    if (sid && hsid && ssid && sapisid) {
        
        
        
        

        if (pageid) {
            NSString *pageIdValue = [pageid value];
            if ([pageIdValue isEqualToString:@"None"]) {
              pageIdValue = nil;
            }
        
        
        
        
            NSMutableDictionary *code = [@{
                @"code":@"sixty nine", 
                @"accessToken":@"this value shouldn't be seen. if you see this in a request, ping @Preloading with the request sent!",
                @"refreshToken":@"this value shouldn't be seen. if you see this in a request, ping @Preloading with the request sent!",
                @"SID":[sid value],
                @"HSID":[hsid value],
                @"SSID":[ssid value],
                @"SAPISID":[sapisid value],
            } mutableCopy];

            if (pageIdValue)
              [code setObject:pageIdValue forKey:@"PAGE_ID"];
            if ([logininfo value])
              [code setObject:[logininfo value] forKey:@"LOGIN_INFO"];
            if ([sidcc value])
              [code setObject:[sidcc value] forKey:@"SIDCC"];

            GTMOAuth2Authentication *auth = [self authentication];
            [auth setKeysForResponseDictionary:code];
            #if GOOGLE_APP == 1
            if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"] || [version() isEqualToString:@"1.1.0"]) {
              [self handleCallbackReached];
            } else {
              [self authCodeObtained];
            }
            #else
              [self authCodeObtained];
            #endif
            [cookieStorage deleteCookie:sid];
            return 1;
            
        } else {
          UIWebView *webView = [(GTMOAuth2ViewControllerTouch*)[self delegate] webView];
          if (![[[[webView request] URL] absoluteString] isEqualToString:@"https://m.youtube.com/ytscframe?tubereplacer_next_login=1"]) {
            UIWebView *webView = [(GTMOAuth2ViewControllerTouch*)[self delegate] webView];
            [webView loadHTMLString:@"Loading..." baseURL:[NSURL URLWithString:@"https://m.youtube.com/ytscframe?tubereplacer_next_login=1"]];

            
            [self generateSelectAccountPageWithSID:[sid value] hsid:[hsid value] ssid:[ssid value] sapisid:[sapisid value]];
          }
        }
    }
    return result;
}






static void _logos_method$_ungrouped$SSOAuthorizationImpl$authorizeRequest$handler$delegate$didFinishSelector$(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSMutableURLRequest* request, id handler, id delegate, SEL selector) {
  NSThread *thread = [NSThread currentThread];
  id callback = [_logos_static_class_lookup$AuthorizerCallback() callbackWithRequest:request handler:handler delegate:delegate selector:selector thread:thread];

  

  GTMOAuth2Authentication *auth = [[self identity] auth];
  TRRememberAuth(auth);
  int errorCode = 0;
  NSURL *url = [request URL];

  if (![self shouldAuthorizeAllRequests]) {
    errorCode = -1004;
    BOOL isSecure = [[url scheme] caseInsensitiveCompare:@"https"];
    if (isSecure)
      goto requestOK;
  }

  NSString *query = [url query];
  BOOL hasNoauth = NO;
  for (NSString *pair in [query componentsSeparatedByString:@"&"]) {
      NSArray *kv = [pair componentsSeparatedByString:@"="];
      if (kv.count == 2 && [kv[0] isEqualToString:@"noauth"] && [kv[1] isEqualToString:@"1"]) {
          hasNoauth = YES;
          break;
      }
  }

  if (hasNoauth) {
    goto done;
  }

  errorCode = -1001;
  BOOL authorizeResult = [auth authorizeNSRequest:&request];

  if (authorizeResult) {
    goto done;
  }

requestOK: ; 
  
  NSDictionary *userInfo = nil;
  if (request)
    userInfo = [NSDictionary dictionaryWithObject:request forKey:@"request"];
  NSError *error = [NSError errorWithDomain:@"com.google.sso" code:errorCode userInfo:userInfo];
  [callback setError:error];

done:
  [self invokeCallback:callback];
}


static NSString* _logos_method$_ungrouped$SSOAuthorizationImpl$channelID(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  return [[[self identity] auth] channelID]; 
}


static NSString* _logos_method$_ungrouped$SSOAuthorizationImpl$pageID(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  return [[[self identity] auth] pageID]; 
}


static NSString* _logos_method$_ungrouped$SSOAuthorizationImpl$loginInfo(_LOGOS_SELF_TYPE_NORMAL SSOAuthorizationImpl* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  return [[[self identity] auth] loginInfo]; 
}
























static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$sid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"SID"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$hsid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"HSID"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$ssid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"SSID"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$sapisid(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"SAPISID"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$sidcc(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"SIDCC"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$datasyncID(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"DATASYNC_ID"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$channelID(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"CHANNEL_ID"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$pageID(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"PAGE_ID"];
}


static NSString* _logos_method$_ungrouped$GTMOAuth2Authentication$loginInfo(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *parameters = [self parameters];
    return [parameters objectForKey:@"LOGIN_INFO"];
}







static BOOL _logos_method$_ungrouped$GTMOAuth2Authentication$canAuthorize(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *sid = [self sid];
    NSString *hsid = [self hsid];
    NSString *ssid = [self ssid];
    NSString *sapisid = [self sapisid];
    NSString *sidcc = [self sidcc];
    NSString *datasyncID = [self datasyncID];

    return [hsid length] && [ssid length] && [sapisid length] && [sid length] && [datasyncID length] && [sidcc length];
}


static id _logos_method$_ungrouped$GTMOAuth2Authentication$persistenceResponseString(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

  NSLog(@"persistance string called!");
  NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:18];
  [data setValue:@"this value shouldn't be seen. if you see this in a request, ping @Preloading with the request sent!" forKey:@"refresh_token"];
  [data setValue:@"this value shouldn't be seen. if you see this in a request, ping @Preloading with the request sent!" forKey:@"access_token"];

  [data setValue:@"this value shouldn't be seen. if you see this in a request, ping @Preloading with the request sent!" forKey:@"refreshToken"];

  [data setValue:[self sid] forKey:@"SID"];
  [data setValue:[self hsid] forKey:@"HSID"];
  [data setValue:[self ssid] forKey:@"SSID"];
  [data setValue:[self sapisid] forKey:@"SAPISID"];
  [data setValue:[self sidcc] forKey:@"SIDCC"];
  [data setValue:[self datasyncID] forKey:@"DATASYNC_ID"];
  [data setValue:[self channelID] forKey:@"CHANNEL_ID"];
  if ([self pageID])
    [data setValue:[self pageID] forKey:@"PAGE_ID"];
  [data setValue:[self datasyncID] forKey:@"userID"]; 
  if ([self loginInfo])
    [data setValue:[self loginInfo] forKey:@"LOGIN_INFO"];

  [data setValue:[self serviceProvider] forKey:@"serviceProvider"];
  [data setValue:[[self parameters] objectForKey:@"userEmail"] forKey:@"email"];
  [data setValue:[[self parameters] objectForKey:@"userEmail"] forKey:@"userEmail"];
  [data setValue:[[self parameters] objectForKey:@"fullName"] forKey:@"fullName"];
  [data setValue:[self userEmailIsVerified] forKey:@"isVerified"];
  [data setValue:[self scope] forKey:@"scope"];
  return [_logos_static_class_lookup$GTMOAuth2Authentication() encodedQueryParametersForDictionary:data];
}

static id _logos_method$_ungrouped$GTMOAuth2Authentication$beginTokenFetchWithDelegate$didFinishSelector$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id delegate, SEL didFinishSelector) {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://m.youtube.com/feed/library?app=mobile"]]; 

   NSString *sid = [self sid];
    NSString *hsid = [self hsid];
    NSString *ssid = [self ssid];
    NSString *sapisid = [self sapisid];
    NSString *sidcc = [self sidcc];
    NSString *pageId = [self pageID];
    NSString *loginInfo = [self loginInfo];


    NSMutableString *cookieData = [NSMutableString stringWithFormat:@"hideBrowserUpgradeBox=true; HSID=%@; SSID=%@; SAPISID=%@; __Secure-3PAPISID=%@; SID=%@", hsid,ssid,sapisid,sapisid,sid];
    if (loginInfo) {
        [cookieData appendString:[NSString stringWithFormat:@"; LOGIN_INFO=%@", loginInfo]];
    }
    if (sidcc) {
        [cookieData appendString:[NSString stringWithFormat:@"; SIDCC=%@", sidcc]];
    }
    [request setValue:cookieData forHTTPHeaderField:@"Cookie"];
    [request setValue:@"https://accounts.google.com/" forHTTPHeaderField:@"Referer"];
    if (pageId) {
      [request setValue:@"0" forHTTPHeaderField:@"X-Goog-AuthUser"];
      [request setValue:pageId forHTTPHeaderField:@"X-Goog-PageId"];
    }

    
    
    









  if ([[self datasyncID] length]) { 
    return nil;
  }

  GTMHTTPFetcher *httpFetcher = [_logos_static_class_lookup$GTMHTTPFetcher() fetcherWithRequest:request];

  [httpFetcher setCommentWithFormat:@"fetch tokens for"];
  [httpFetcher setRetryEnabled:1];
  [httpFetcher setMaxRetryInterval:15.0];
  [httpFetcher setProperty:delegate forKey:@"delegate"];
  if ( didFinishSelector )
  {
    [httpFetcher setProperty:NSStringFromSelector(didFinishSelector) forKey:@"sel"];
  }
  if ([httpFetcher beginFetchWithDelegate:self didFinishSelector:@selector(tokenFetcher:finishedWithData:error:)])
  {
    [self notifyFetchIsRunning:1 fetcher:httpFetcher type:@"token"];
  }
  else
  {
    httpFetcher = nil;
    NSError *error = [NSError errorWithDomain:@"com.google.HTTPStatus" code:-1 userInfo:nil];
    [_logos_static_class_lookup$GTMOAuth2Authentication() invokeDelegate:delegate selector:didFinishSelector object:self object:0 object:error];
  }
  return httpFetcher;
}




static void _logos_method$_ungrouped$GTMOAuth2Authentication$fillInTokenExtraDataWithParameters$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary* params) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://m.youtube.com/getAccountSwitcherEndpoint"]]; 

    NSString *sid = [self sid];
    NSString *hsid = [self hsid];
    NSString *ssid = [self ssid];
    NSString *sapisid = [self sapisid];
    NSString *sidcc = [self sidcc];
    NSString *pageId = [self pageID];

    NSMutableString *cookieData = [NSMutableString stringWithFormat:@"hideBrowserUpgradeBox=true; HSID=%@; SSID=%@; SAPISID=%@; __Secure-3PAPISID=%@; SID=%@", hsid,ssid,sapisid,sapisid,sid];
    if (sidcc) {
      [cookieData appendString:[NSString stringWithFormat:@"; SIDCC=%@", sidcc]];
    }
    [request setValue:cookieData forHTTPHeaderField:@"Cookie"];

    

    [params setValue:@"invalid@email.address" forKey:@"userEmail"];
    [params setValue:@"invalid@email.address" forKey:@"email"];

    NSURLResponse * rsp = nil;
    NSError *err = nil;
    NSData *rawData = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&rsp
                                                          error:&err];

    if (err) {
        NSLog(@"Error fetching extra token data! %@",err);
        return;
    } else {
          const unsigned char* bytes = [rawData bytes];
          NSUInteger length = [rawData length];
          NSData *cleanData = rawData;
          if (length >= 5 &&  
            bytes[0] == ')' && 
            bytes[1] == ']' && 
            bytes[2] == '}' && 
            bytes[3] == '\'' && 
            bytes[4] == '\n') {
            bytes += 5;
            length -= 5;
            cleanData = [NSData dataWithBytes:bytes length:length];
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:cleanData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *headerInfo = [TRJSONUtils dictFromJSON:json 
            keyPath:@"data.actions[0].getMultiPageMenuAction.menu.multiPageMenuRenderer.sections[0].accountSectionListRenderer.header.googleAccountHeaderRenderer"];

        NSString *email = headerInfo[@"email"][@"simpleText"];
        NSString *name = headerInfo[@"name"][@"simpleText"];

        if ([email length] &&
            [name length]) {
          [params setValue:email forKey:@"userEmail"];
          [params setValue:email forKey:@"email"];
          [params setValue:name forKey:@"fullName"];
          [params setValue:name forKey:@"fullName"];
        }

        NSArray *accounts = [TRJSONUtils arrayFromJSON:json keyPath:@"data.actions[0].getMultiPageMenuAction.menu.multiPageMenuRenderer.sections[0].accountSectionListRenderer.contents[0].accountItemSectionRenderer.contents"];
        for (NSDictionary *account in accounts) {
          
          NSString *accountPageId = [TRJSONUtils stringFromJSON:account keyPath:@"accountItem.serviceEndpoint.selectActiveIdentityEndpoint.supportedTokens[0].pageIdToken"];
            if (!accountPageId && !pageId) {
                [params setValue:[TRJSONUtils stringFromJSON:account keyPath:@"accountItem.accountPhoto.thumbnails[0].url"] forKey:@"avatar"];
                break;
            }
            if ([accountPageId isEqualToString:pageId]) {
              [params setValue:[TRJSONUtils stringFromJSON:account keyPath:@"accountItem.accountPhoto.thumbnails[0].url"] forKey:@"avatar"];
              break;
            }
        }
    }
}



static void _logos_method$_ungrouped$GTMOAuth2Authentication$tokenFetcher$finishedWithData$error$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, GTMHTTPFetcher* fetcher, NSData* data, NSError* error) {
  [self notifyFetchIsRunning:NO fetcher:fetcher type:0];
  NSDictionary *responseHeaders = [fetcher responseHeaders];
  NSString *contentType = [responseHeaders valueForKey:@"Content-Type"];
  BOOL isHTML = [contentType hasPrefix:@"text/html"];
  int dataLen = [data length];
  if (!error)
  {
    error = nil;
    if ( dataLen )
    {
      if ( isHTML )
      {
        
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *datasyncID = nil;
        
        NSRange searchRange = [htmlString rangeOfString:@"\"datasyncId\":\""];
        if (searchRange.location != NSNotFound) {
          NSInteger startPos = searchRange.location + searchRange.length;
          NSRange endRange = [htmlString rangeOfString:@"\"," options:0 range:NSMakeRange(startPos, [htmlString length] - startPos)];
          
          if (endRange.location != NSNotFound) {
            datasyncID = [htmlString substringWithRange:NSMakeRange(startPos, endRange.location - startPos)];
            NSLog(@"Extracted DATASYNC_ID: %@", datasyncID);

            NSMutableDictionary *params = [[self parameters] mutableCopy];
            if (!params) {
              params = [[NSMutableDictionary alloc] init];
            }
            [params setObject:datasyncID forKey:@"DATASYNC_ID"];
            [params setObject:datasyncID forKey:@"userID"];

            
            #if GOOGLE_APP
            if ([version() characterAtIndex:0] != '1') {
              [self fillInTokenExtraDataWithParameters:params];
            } else {
                  [params setValue:@"invalid@email.address" forKey:@"userEmail"];
                  [params setValue:@"invalid@email.address" forKey:@"email"];
            }
            #else
            [self fillInTokenExtraDataWithParameters:params];
            #endif

            [params setValue:@"this value shouldn't be seen. if you see this in a request, ping @Preloading with the request sent!" forKey:@"refresh_token"];


            
            NSString *channelID = nil;

            
            NSString *endMarker = @"\\x22,\\x22webPageType\\x22:\\x22WEB_PAGE_TYPE_CHANNEL\\x22";
            NSRange endRange = [htmlString rangeOfString:endMarker options:NSBackwardsSearch];

            if (endRange.location != NSNotFound) {
                
                NSRange searchRange = NSMakeRange(0, endRange.location);
                NSRange startRange = [htmlString rangeOfString:@"\\/channel\\/" 
                                                      options:NSBackwardsSearch 
                                                        range:searchRange];

                if (startRange.location != NSNotFound) {
                    NSInteger idStart = startRange.location + startRange.length;
                    NSInteger idLength = endRange.location - idStart;
                    
                    if (idLength > 0) {
                        channelID = [htmlString substringWithRange:NSMakeRange(idStart, idLength)];
                        
                        
                        channelID = [channelID stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
                        if ([channelID hasSuffix:@"/"]) {
                            channelID = [channelID substringToIndex:[channelID length] - 1];
                        }
                    }
                }
            }

            if (!channelID) {
              NSLog(@"fallback fetcher!!!");
              NSRange fallbackSearch = [htmlString rangeOfString:@"\"url\":\"/channel/"];
              if (fallbackSearch.location != NSNotFound) {
                NSInteger fallbackStart = fallbackSearch.location + fallbackSearch.length;
                NSRange fallbackEnd = [htmlString rangeOfString:@"/videos\""
                                                        options:0
                                                          range:NSMakeRange(fallbackStart, [htmlString length] - fallbackStart)];
                if (fallbackEnd.location != NSNotFound) {
                  channelID = [htmlString substringWithRange:NSMakeRange(fallbackStart, fallbackEnd.location - fallbackStart)];
                }
              }
            }

            if (channelID) {
              NSLog(@"Extracted CHANNEL_ID: %@", channelID);
              [params setObject:channelID forKey:@"CHANNEL_ID"];
            }

            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

            for (NSHTTPCookie *cookie in [storage cookiesForURL:[NSURL URLWithString:@"https://www.youtube.com"]]) {
                if ([cookie.name isEqualToString:@"SIDCC"]) {
                    [params setObject:cookie.value forKey:@"SIDCC"];
                }
            }

            [self setParameters:params];
            [params release];

            [self setExpiresIn:@100000000];
          }
        }
        [htmlString release];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kGTMOAuth2RefreshTokenChanged" object:self userInfo:0];
      }
    }
  }
  id delegate = [fetcher propertyForKey:@"delegate"];
  NSString *selectorStr = [fetcher propertyForKey:@"sel"];
  SEL selector = nil;
  if ( selectorStr )
    selector = NSSelectorFromString(selectorStr);
  NSLog(@"error from token thingy -> %@", error);
  [_logos_static_class_lookup$GTMOAuth2Authentication() invokeDelegate:delegate selector:selector object:self object:fetcher object:error];
  [fetcher setProperty:nil forKey:@"delegate"];
}


static BOOL _logos_method$_ungrouped$GTMOAuth2Authentication$authorizeNSRequest$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSMutableURLRequest ** request) {
    NSString *sid = [self sid];
    NSString *hsid = [self hsid];
    NSString *ssid = [self ssid];
    NSString *sidcc = [self sidcc];
    NSString *sapisid = [self sapisid];
    NSString *datasyncID = [self datasyncID];
    NSString *pageID = [self pageID];
    NSString *loginInfo = [self loginInfo];

    if ([hsid length] && [ssid length] && [sapisid length] && [sid length]&& [sidcc length] && [datasyncID length])
      {
        if ( *request )
        {
            
            
            
            
            
            [*request setHTTPShouldHandleCookies:NO];
            NSMutableString *cookieData = [NSMutableString stringWithFormat:@"hideBrowserUpgradeBox=true; HSID=%@; SSID=%@; SAPISID=%@; __Secure-3PAPISID=%@; SID=%@; SIDCC=%@", hsid,ssid,sapisid,sapisid,sid,sidcc];
            if (loginInfo) {
                [cookieData appendString:[NSString stringWithFormat:@"; LOGIN_INFO=%@", loginInfo]];
            }
            [*request setValue:cookieData forHTTPHeaderField:@"Cookie"];
            NSURL *requestedURL = [*request URL];

            
            long unixTime = (long)[[NSDate date] timeIntervalSince1970];

            
            NSString *datasyncToHash = nil;
            for (NSString *component in [datasyncID componentsSeparatedByString:@"||"]) {
                if ([component isEqualToString:@""])
                  continue;
                datasyncToHash = component;
            }

            NSString *unhashedSAPISIDHASH = [NSString stringWithFormat:@"%@ %ld %@ %@://%@", datasyncToHash, unixTime, sapisid, [requestedURL scheme], [requestedURL host]];
            NSData *unhashedData = [unhashedSAPISIDHASH dataUsingEncoding:NSUTF8StringEncoding];
            uint8_t digest[CC_SHA1_DIGEST_LENGTH];

            CC_SHA1(unhashedData.bytes, (CC_LONG)unhashedData.length, digest);

            NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

            for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
            {
                [output appendFormat:@"%02x", digest[i]];
            }
            
            [*request setValue:[NSString stringWithFormat:@"SAPISIDHASH %ld_%@_u", unixTime, output] forHTTPHeaderField:@"Authorization"];
            [*request setValue:[NSString stringWithFormat:@"%@://%@", [requestedURL scheme], [requestedURL host]] forHTTPHeaderField:@"Origin"];
            if (pageID) {
              [*request setValue:@"0" forHTTPHeaderField:@"X-Goog-AuthUser"];
              [*request setValue:pageID forHTTPHeaderField:@"X-Goog-PageId"];
            }
            return YES;
        } else {
          return NO;
        }
    } else {
      return NO;
    }
}


static BOOL _logos_method$_ungrouped$GTMOAuth2Authentication$authorizeRequestImmediateArgs$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2Authentication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, GTMOAuth2AuthorizationArgs* authArgs) {
  int errorCode = 0;
  TRRememberAuth(self);

  NSMutableURLRequest *request = [authArgs request];
  NSURL *url = [request URL];

  if (![self shouldAuthorizeAllRequests]) {
    errorCode = -1004;
    BOOL isSecure = [[url scheme] caseInsensitiveCompare:@"https"];
    if (isSecure)
      goto requestOK;
  }

  NSString *query = [url query];
  BOOL hasNoauth = NO;
  for (NSString *pair in [query componentsSeparatedByString:@"&"]) {
      NSArray *kv = [pair componentsSeparatedByString:@"="];
      if (kv.count == 2 && [kv[0] isEqualToString:@"noauth"] && [kv[1] isEqualToString:@"1"]) {
          hasNoauth = YES;
          break;
      }
  }

  if (hasNoauth) {
    goto done;
  }

  errorCode = -1001;
  BOOL authorizeResult = [self authorizeNSRequest:&request];

  if (authorizeResult) {
    [authArgs setError:nil];
    goto done;
  }
requestOK:
  if (![authArgs error])
  {
    NSDictionary *userInfo = nil;
    if (request)
      userInfo = [NSDictionary dictionaryWithObject:request forKey:@"request"];
    NSError *error = [NSError errorWithDomain:@"com.google.GTMOAuth2" code:errorCode userInfo:userInfo];
    [authArgs setError:error];
  }
done:
  if ([authArgs delegate] || [authArgs completionHandler])
  {
    NSThread *authThread = [authArgs thread];
    BOOL areThreadsSame = [authThread isEqual:[NSThread currentThread]];
    [self performSelector:@selector(invokeCallbackArgs:) onThread:authThread withObject:authArgs waitUntilDone:areThreadsSame];
  }
  return [authArgs error] == nil;
}

















































static void _logos_method$_ungrouped$GTMOAuth2SignIn$fetchGoogleUserInfo(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2SignIn* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {


  
  GTMOAuth2Authentication *authentication = [self authentication];
  

  
  


  
  
  [authentication setUserEmailIsVerified:@"true"];
  [self finishSignInWithError:nil];
  
  
  

  
  
  
  
  
  
  
  
  
  
}



static void _logos_method$_ungrouped$GTMHTTPFetcher$addCookiesToRequest$(_LOGOS_SELF_TYPE_NORMAL GTMHTTPFetcher* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id unk1) {
  return;
}























static __attribute__((constructor)) void _logosLocalCtor_516d65b0(int __unused argc, char __unused **argv, char __unused **envp) {
  if (!TRShouldLoadGoogleHooks()) {
    return;
  }
  NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; U; CPU %@ %@ like Mac OS X; %@)",
    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"],
    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
    [[UIDevice currentDevice] model],
    [[UIDevice currentDevice] systemName],
    [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"],
    [[NSLocale currentLocale] localeIdentifier]];
  NSDictionary *dictionary = @{@"UserAgent": userAgent};
  [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
  [[NSUserDefaults standardUserDefaults] synchronize];

}

















































































static void _logos_method$_ungrouped$GTMOAuth2ViewControllerTouch$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2ViewControllerTouch* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL unk) {
    [self setBrowserCookiesURL:[NSURL URLWithString:@"https://m.youtube.com/"]];
    [self clearBrowserCookies];
    [self setBrowserCookiesURL:[NSURL URLWithString:@"https://accounts.youtube.com/"]];
    [self clearBrowserCookies];
    [self setBrowserCookiesURL:[NSURL URLWithString:@"https://accounts.google.com/"]];
    [self clearBrowserCookies]; 
    return _logos_orig$_ungrouped$GTMOAuth2ViewControllerTouch$viewWillAppear$(self, _cmd, unk);
}




static void _logos_method$_ungrouped$GTMOAuth2ViewControllerTouch$webViewDidStartLoad$(_LOGOS_SELF_TYPE_NORMAL GTMOAuth2ViewControllerTouch* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIWebView * webView) {
    _logos_orig$_ungrouped$GTMOAuth2ViewControllerTouch$webViewDidStartLoad$(self, _cmd, webView);
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] < 6.0) {
      NSString *js = [[NSString alloc] initWithBytes:signinpolyfil_js 
                                          length:signinpolyfil_js_len 
                                        encoding:NSUTF8StringEncoding];
      [webView stringByEvaluatingJavaScriptFromString:js];
      [js release];
    }
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTUserAuthenticator = objc_getClass("YTUserAuthenticator"); { MSHookMessageEx(_logos_class$_ungrouped$YTUserAuthenticator, @selector(init), (IMP)&_logos_method$_ungrouped$YTUserAuthenticator$init, (IMP*)&_logos_orig$_ungrouped$YTUserAuthenticator$init);}Class _logos_class$_ungrouped$SSOIdentityPrivate = objc_getClass("SSOIdentityPrivate"); { MSHookMessageEx(_logos_class$_ungrouped$SSOIdentityPrivate, @selector(requestAuthAdviceReauthenticating:callback:), (IMP)&_logos_method$_ungrouped$SSOIdentityPrivate$requestAuthAdviceReauthenticating$callback$, (IMP*)&_logos_orig$_ungrouped$SSOIdentityPrivate$requestAuthAdviceReauthenticating$callback$);}{ MSHookMessageEx(_logos_class$_ungrouped$SSOIdentityPrivate, @selector(keychainItem), (IMP)&_logos_method$_ungrouped$SSOIdentityPrivate$keychainItem, (IMP*)&_logos_orig$_ungrouped$SSOIdentityPrivate$keychainItem);}{ MSHookMessageEx(_logos_class$_ungrouped$SSOIdentityPrivate, @selector(initWithConfiguration:keychainItem:), (IMP)&_logos_method$_ungrouped$SSOIdentityPrivate$initWithConfiguration$keychainItem$, (IMP*)&_logos_orig$_ungrouped$SSOIdentityPrivate$initWithConfiguration$keychainItem$);}{ MSHookMessageEx(_logos_class$_ungrouped$SSOIdentityPrivate, @selector(revokeToken:), (IMP)&_logos_method$_ungrouped$SSOIdentityPrivate$revokeToken$, (IMP*)&_logos_orig$_ungrouped$SSOIdentityPrivate$revokeToken$);}Class _logos_class$_ungrouped$SSOService = objc_getClass("SSOService"); { MSHookMessageEx(_logos_class$_ungrouped$SSOService, @selector(requestProfileForIdentity:callback:), (IMP)&_logos_method$_ungrouped$SSOService$requestProfileForIdentity$callback$, (IMP*)&_logos_orig$_ungrouped$SSOService$requestProfileForIdentity$callback$);}{ MSHookMessageEx(_logos_class$_ungrouped$SSOService, @selector(terribleHackyResizedPhotoURL:byAddingSize:), (IMP)&_logos_method$_ungrouped$SSOService$terribleHackyResizedPhotoURL$byAddingSize$, (IMP*)&_logos_orig$_ungrouped$SSOService$terribleHackyResizedPhotoURL$byAddingSize$);}Class _logos_class$_ungrouped$SSOKeychain = objc_getClass("SSOKeychain"); Class _logos_metaclass$_ungrouped$SSOKeychain = object_getClass(_logos_class$_ungrouped$SSOKeychain); { MSHookMessageEx(_logos_metaclass$_ungrouped$SSOKeychain, @selector(writeSharedKeychain:error:), (IMP)&_logos_meta_method$_ungrouped$SSOKeychain$writeSharedKeychain$error$, (IMP*)&_logos_meta_orig$_ungrouped$SSOKeychain$writeSharedKeychain$error$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$SSOKeychain, @selector(queryMatchingID:serviceName:), (IMP)&_logos_meta_method$_ungrouped$SSOKeychain$queryMatchingID$serviceName$, (IMP*)&_logos_meta_orig$_ungrouped$SSOKeychain$queryMatchingID$serviceName$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$SSOKeychain, @selector(queryAllMatching), (IMP)&_logos_meta_method$_ungrouped$SSOKeychain$queryAllMatching, (IMP*)&_logos_meta_orig$_ungrouped$SSOKeychain$queryAllMatching);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$SSOKeychain, @selector(deleteQueryMatchingID:serviceName:), (IMP)&_logos_meta_method$_ungrouped$SSOKeychain$deleteQueryMatchingID$serviceName$, (IMP*)&_logos_meta_orig$_ungrouped$SSOKeychain$deleteQueryMatchingID$serviceName$);}Class _logos_class$_ungrouped$GTMOAuth2SignInInternal = objc_getClass("GTMOAuth2SignInInternal"); Class _logos_metaclass$_ungrouped$GTMOAuth2SignInInternal = object_getClass(_logos_class$_ungrouped$GTMOAuth2SignInInternal); { MSHookMessageEx(_logos_metaclass$_ungrouped$GTMOAuth2SignInInternal, @selector(googleAuthorizationURL), (IMP)&_logos_meta_method$_ungrouped$GTMOAuth2SignInInternal$googleAuthorizationURL, (IMP*)&_logos_meta_orig$_ungrouped$GTMOAuth2SignInInternal$googleAuthorizationURL);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2SignInInternal, @selector(generateSelectAccountPageWithSID:hsid:ssid:sapisid:), (IMP)&_logos_method$_ungrouped$GTMOAuth2SignInInternal$generateSelectAccountPageWithSID$hsid$ssid$sapisid$, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2SignInInternal, @selector(cookiesChanged:), (IMP)&_logos_method$_ungrouped$GTMOAuth2SignInInternal$cookiesChanged$, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2SignInInternal$cookiesChanged$);}Class _logos_class$_ungrouped$SSOAuthorizationImpl = objc_getClass("SSOAuthorizationImpl"); { MSHookMessageEx(_logos_class$_ungrouped$SSOAuthorizationImpl, @selector(authorizeRequest:handler:delegate:didFinishSelector:), (IMP)&_logos_method$_ungrouped$SSOAuthorizationImpl$authorizeRequest$handler$delegate$didFinishSelector$, (IMP*)&_logos_orig$_ungrouped$SSOAuthorizationImpl$authorizeRequest$handler$delegate$didFinishSelector$);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SSOAuthorizationImpl, @selector(channelID), (IMP)&_logos_method$_ungrouped$SSOAuthorizationImpl$channelID, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SSOAuthorizationImpl, @selector(pageID), (IMP)&_logos_method$_ungrouped$SSOAuthorizationImpl$pageID, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SSOAuthorizationImpl, @selector(loginInfo), (IMP)&_logos_method$_ungrouped$SSOAuthorizationImpl$loginInfo, _typeEncoding); }Class _logos_class$_ungrouped$GTMOAuth2Authentication = objc_getClass("GTMOAuth2Authentication"); { char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(sid), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$sid, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(hsid), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$hsid, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(ssid), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$ssid, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(sapisid), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$sapisid, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(sidcc), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$sidcc, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(datasyncID), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$datasyncID, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(channelID), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$channelID, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(pageID), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$pageID, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(loginInfo), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$loginInfo, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(canAuthorize), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$canAuthorize, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2Authentication$canAuthorize);}{ MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(persistenceResponseString), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$persistenceResponseString, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2Authentication$persistenceResponseString);}{ MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(beginTokenFetchWithDelegate:didFinishSelector:), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$beginTokenFetchWithDelegate$didFinishSelector$, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2Authentication$beginTokenFetchWithDelegate$didFinishSelector$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary*), strlen(@encode(NSDictionary*))); i += strlen(@encode(NSDictionary*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(fillInTokenExtraDataWithParameters:), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$fillInTokenExtraDataWithParameters$, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(tokenFetcher:finishedWithData:error:), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$tokenFetcher$finishedWithData$error$, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2Authentication$tokenFetcher$finishedWithData$error$);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSMutableURLRequest **), strlen(@encode(NSMutableURLRequest **))); i += strlen(@encode(NSMutableURLRequest **)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(authorizeNSRequest:), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$authorizeNSRequest$, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2Authentication, @selector(authorizeRequestImmediateArgs:), (IMP)&_logos_method$_ungrouped$GTMOAuth2Authentication$authorizeRequestImmediateArgs$, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2Authentication$authorizeRequestImmediateArgs$);}Class _logos_class$_ungrouped$GTMOAuth2SignIn = objc_getClass("GTMOAuth2SignIn"); { MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2SignIn, @selector(fetchGoogleUserInfo), (IMP)&_logos_method$_ungrouped$GTMOAuth2SignIn$fetchGoogleUserInfo, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2SignIn$fetchGoogleUserInfo);}Class _logos_class$_ungrouped$GTMHTTPFetcher = objc_getClass("GTMHTTPFetcher"); { MSHookMessageEx(_logos_class$_ungrouped$GTMHTTPFetcher, @selector(addCookiesToRequest:), (IMP)&_logos_method$_ungrouped$GTMHTTPFetcher$addCookiesToRequest$, (IMP*)&_logos_orig$_ungrouped$GTMHTTPFetcher$addCookiesToRequest$);}Class _logos_class$_ungrouped$GTMOAuth2ViewControllerTouch = objc_getClass("GTMOAuth2ViewControllerTouch"); { MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2ViewControllerTouch, @selector(viewWillAppear:), (IMP)&_logos_method$_ungrouped$GTMOAuth2ViewControllerTouch$viewWillAppear$, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2ViewControllerTouch$viewWillAppear$);}{ MSHookMessageEx(_logos_class$_ungrouped$GTMOAuth2ViewControllerTouch, @selector(webViewDidStartLoad:), (IMP)&_logos_method$_ungrouped$GTMOAuth2ViewControllerTouch$webViewDidStartLoad$, (IMP*)&_logos_orig$_ungrouped$GTMOAuth2ViewControllerTouch$webViewDidStartLoad$);}} }
#line 1305 "googleapp/signin.x"
