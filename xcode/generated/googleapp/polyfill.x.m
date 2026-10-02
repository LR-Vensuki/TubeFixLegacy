#line 1 "googleapp/polyfill.x"

























#include <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "general.h"

@interface __NSArrayM : NSMutableArray
@end

@interface __NSCFDictionary : NSMutableDictionary
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

@class __NSArrayI; @class __NSArrayM; @class __NSCFDictionary; 


#line 36 "googleapp/polyfill.x"
static id _logos_method$Subscripts$__NSArrayM$objectAtIndexedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSArrayM* _LOGOS_SELF_CONST, SEL, NSUInteger); static void _logos_method$Subscripts$__NSArrayM$setObject$atIndexedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSArrayM* _LOGOS_SELF_CONST, SEL, id, NSUInteger); static id _logos_method$Subscripts$__NSArrayI$objectAtIndexedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSArrayI* _LOGOS_SELF_CONST, SEL, NSUInteger); static id _logos_method$Subscripts$__NSCFDictionary$objectForKeyedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSCFDictionary* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$Subscripts$__NSCFDictionary$setObject$forKeyedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSCFDictionary* _LOGOS_SELF_CONST, SEL, id, id); 



static id _logos_method$Subscripts$__NSArrayM$objectAtIndexedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSArrayM* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSUInteger idx) {
    return [self objectAtIndex:idx];
}


static void _logos_method$Subscripts$__NSArrayM$setObject$atIndexedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSArrayM* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id obj, NSUInteger idx) {
    [self replaceObjectAtIndex:idx withObject:obj];
}






static id _logos_method$Subscripts$__NSArrayI$objectAtIndexedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSArrayI* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSUInteger idx) {
    return [self objectAtIndex:idx];
}






static id _logos_method$Subscripts$__NSCFDictionary$objectForKeyedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSCFDictionary* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id key) {
    return [self objectForKey:key];
}


static void _logos_method$Subscripts$__NSCFDictionary$setObject$forKeyedSubscript$(_LOGOS_SELF_TYPE_NORMAL __NSCFDictionary* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id obj, id key) {
    [self setObject:obj forKey:key];
}




static __attribute__((constructor)) void _logosLocalCtor_0271b2a0(int __unused argc, char __unused **argv, char __unused **envp) {
    if (!TRShouldLoadGoogleHooks()) {
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
        {Class _logos_class$Subscripts$__NSArrayM = objc_getClass("__NSArrayM"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSUInteger), strlen(@encode(NSUInteger))); i += strlen(@encode(NSUInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$Subscripts$__NSArrayM, @selector(objectAtIndexedSubscript:), (IMP)&_logos_method$Subscripts$__NSArrayM$objectAtIndexedSubscript$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; memcpy(_typeEncoding + i, @encode(NSUInteger), strlen(@encode(NSUInteger))); i += strlen(@encode(NSUInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$Subscripts$__NSArrayM, @selector(setObject:atIndexedSubscript:), (IMP)&_logos_method$Subscripts$__NSArrayM$setObject$atIndexedSubscript$, _typeEncoding); }Class _logos_class$Subscripts$__NSArrayI = objc_getClass("__NSArrayI"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSUInteger), strlen(@encode(NSUInteger))); i += strlen(@encode(NSUInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$Subscripts$__NSArrayI, @selector(objectAtIndexedSubscript:), (IMP)&_logos_method$Subscripts$__NSArrayI$objectAtIndexedSubscript$, _typeEncoding); }Class _logos_class$Subscripts$__NSCFDictionary = objc_getClass("__NSCFDictionary"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$Subscripts$__NSCFDictionary, @selector(objectForKeyedSubscript:), (IMP)&_logos_method$Subscripts$__NSCFDictionary$objectForKeyedSubscript$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$Subscripts$__NSCFDictionary, @selector(setObject:forKeyedSubscript:), (IMP)&_logos_method$Subscripts$__NSCFDictionary$setObject$forKeyedSubscript$, _typeEncoding); }}
    }
}
