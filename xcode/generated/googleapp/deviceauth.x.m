#line 1 "googleapp/deviceauth.x"
#include <Foundation/Foundation.h>
#include "general.h"
#include "common-google/potoken-google.h"


@interface YTDeviceAuth : NSObject
{
    NSString *deviceId_;
    NSData *deviceKey_;
}
- (id)initWithDeviceId:(id)fp8 deviceKey:(id)fp12;
@end


@interface YTDeviceAuthorizer : NSObject
{
    NSMutableArray *requestQueue_;
    NSString *developerKey_;
    YTDeviceAuth *deviceAuth_;
    NSString *secret_;
    NSUserDefaults *storage_;
    NSString *uniqueInstallationID_;
}
- (void)saveRegistrationToStorage;
- (void)performRequestQueueWithError:(id)fp8;
+ (id)decryptDeviceKey:(id)fp8 secret:(id)fp12;
@end

@interface GIPToast : NSObject
+(void)showToast:(NSString*)text forDuration:(double)duration;
@end


@interface KUDeviceAuth : NSObject
{
    NSString *deviceId_;
    NSData *deviceKey_;
}
- (id)initWithDeviceId:(id)fp8 deviceKey:(id)fp12;
@end


@interface KUDeviceAuthorizer : NSObject
{
    NSMutableArray *requestQueue_;
    NSString *developerKey_;
    YTDeviceAuth *deviceAuth_;
    NSString *secret_;
    NSUserDefaults *storage_;
    NSString *uniqueInstallationID_;
}
- (void)saveRegistrationToStorage;
- (void)performRequestQueueWithError:(id)fp8;
+ (id)decryptDeviceKey:(id)fp8 secret:(id)fp12;
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

@class KUDeviceAuthorizer; @class GIPToast; @class YTDeviceAuthorizer; @class KUDeviceAuth; @class YTDeviceAuth; 
static void (*_logos_orig$_ungrouped$YTDeviceAuthorizer$beginDeviceRegistration)(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTDeviceAuthorizer$beginDeviceRegistration(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTDeviceAuthorizer$loadRegistrationFromStorage)(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTDeviceAuthorizer$loadRegistrationFromStorage(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST, SEL); static TRPOTokenSolver* _logos_method$_ungrouped$YTDeviceAuthorizer$challengeSolver(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$KUDeviceAuthorizer$beginDeviceRegistration)(_LOGOS_SELF_TYPE_NORMAL KUDeviceAuthorizer* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$KUDeviceAuthorizer$beginDeviceRegistration(_LOGOS_SELF_TYPE_NORMAL KUDeviceAuthorizer* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTDeviceAuth(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTDeviceAuth"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$KUDeviceAuth(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("KUDeviceAuth"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTDeviceAuthorizer(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTDeviceAuthorizer"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$KUDeviceAuthorizer(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("KUDeviceAuthorizer"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GIPToast(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GIPToast"); } return _klass; }
#line 58 "googleapp/deviceauth.x"





static void _logos_method$_ungrouped$YTDeviceAuthorizer$beginDeviceRegistration(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	id decryptedSecret = [_logos_static_class_lookup$YTDeviceAuthorizer() decryptDeviceKey:@"ULxlVAAVMhZ2GeqZA/X1GgqEEIP1ibcd3S+42pkWfmk=" secret:[self valueForKey:l(@"secret")]];
    YTDeviceAuth *deviceAuth = [[_logos_static_class_lookup$YTDeviceAuth() alloc] initWithDeviceId:@"dmVyeSBzZWN1cmUgaWQ=" deviceKey:decryptedSecret];
	[self setValue:[deviceAuth retain] forKey:l(@"deviceAuth")];
    if (deviceAuth)
    {
      [self saveRegistrationToStorage];
      [self performRequestQueueWithError:0];
      return;
    }
	[self performRequestQueueWithError:0]; 
}

static void _logos_method$_ungrouped$YTDeviceAuthorizer$loadRegistrationFromStorage(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    TRPOTokenSolver *solver = [TRPOTokenSolver sharedInstance];
    objc_setAssociatedObject(self, "_challengeSolver", solver, OBJC_ASSOCIATION_RETAIN);
    solver.errorAlert = ^(NSString *alertText) {
        [_logos_static_class_lookup$GIPToast() showToast:alertText forDuration:1.5];
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [solver setupPOTokenGenerationWithAuth:nil]; 
    });
    
    return _logos_orig$_ungrouped$YTDeviceAuthorizer$loadRegistrationFromStorage(self, _cmd);
}


static TRPOTokenSolver* _logos_method$_ungrouped$YTDeviceAuthorizer$challengeSolver(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthorizer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return objc_getAssociatedObject(self, "_challengeSolver");
}



















static void _logos_method$_ungrouped$KUDeviceAuthorizer$beginDeviceRegistration(_LOGOS_SELF_TYPE_NORMAL KUDeviceAuthorizer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	id decryptedSecret = [_logos_static_class_lookup$KUDeviceAuthorizer() decryptDeviceKey:@"ULxlVAAVMhZ2GeqZA/X1GgqEEIP1ibcd3S+42pkWfmk=" secret:[self valueForKey:l(@"secret")]];
    KUDeviceAuth *deviceAuth = [[_logos_static_class_lookup$KUDeviceAuth() alloc] initWithDeviceId:@"dmVyeSBzZWN1cmUgaWQ=" deviceKey:decryptedSecret];
	[self setValue:[deviceAuth retain] forKey:l(@"deviceAuth")];
    if (deviceAuth)
    {
      [self saveRegistrationToStorage];
      [self performRequestQueueWithError:0];
      return;
    }
	[self performRequestQueueWithError:0]; 
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTDeviceAuthorizer = objc_getClass("YTDeviceAuthorizer"); { MSHookMessageEx(_logos_class$_ungrouped$YTDeviceAuthorizer, @selector(beginDeviceRegistration), (IMP)&_logos_method$_ungrouped$YTDeviceAuthorizer$beginDeviceRegistration, (IMP*)&_logos_orig$_ungrouped$YTDeviceAuthorizer$beginDeviceRegistration);}{ MSHookMessageEx(_logos_class$_ungrouped$YTDeviceAuthorizer, @selector(loadRegistrationFromStorage), (IMP)&_logos_method$_ungrouped$YTDeviceAuthorizer$loadRegistrationFromStorage, (IMP*)&_logos_orig$_ungrouped$YTDeviceAuthorizer$loadRegistrationFromStorage);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(TRPOTokenSolver*), strlen(@encode(TRPOTokenSolver*))); i += strlen(@encode(TRPOTokenSolver*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTDeviceAuthorizer, @selector(challengeSolver), (IMP)&_logos_method$_ungrouped$YTDeviceAuthorizer$challengeSolver, _typeEncoding); }Class _logos_class$_ungrouped$KUDeviceAuthorizer = objc_getClass("KUDeviceAuthorizer"); { MSHookMessageEx(_logos_class$_ungrouped$KUDeviceAuthorizer, @selector(beginDeviceRegistration), (IMP)&_logos_method$_ungrouped$KUDeviceAuthorizer$beginDeviceRegistration, (IMP*)&_logos_orig$_ungrouped$KUDeviceAuthorizer$beginDeviceRegistration);}} }
#line 126 "googleapp/deviceauth.x"
