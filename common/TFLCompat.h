// TFLCompat.h
// TubeFixLegacy
//
// Prefix header for every target. Lets the sources build both with a
// current clang + iOS SDK (Theos) and with Xcode 4.6.3 (Apple LLVM 4.2,
// iPhoneOS 6.1 SDK), which predates nullability, lightweight generics,
// NS_DESIGNATED_INITIALIZER and a few public declarations.
//
// Only declarations and no-op macros live here - nothing that changes
// what the code does at runtime.

#ifndef TFL_COMPAT_H
#define TFL_COMPAT_H

#ifdef __OBJC__
// Theos' Prefix.pch used to import these implicitly with the iOS 6 SDK
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// The vendored sources had their nullability annotations removed (Apple
// LLVM 4.2 can't parse them), so the assume-nonnull regions are empty too.
#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#endif

#if !__has_feature(nullability)
#define nullable
#define nonnull
#define null_unspecified
#define null_resettable
#define _Nullable
#define _Nonnull
#define _Null_unspecified
#define __nullable
#define __nonnull
#endif

#if !__has_feature(objc_kindof)
#define __kindof
#endif

#ifndef NS_DESIGNATED_INITIALIZER
#define NS_DESIGNATED_INITIALIZER
#endif
#ifndef NS_UNAVAILABLE
#define NS_UNAVAILABLE UNAVAILABLE_ATTRIBUTE
#endif
#ifndef NS_SWIFT_NAME
#define NS_SWIFT_NAME(x)
#endif
#ifndef NS_REFINED_FOR_SWIFT
#define NS_REFINED_FOR_SWIFT
#endif
#ifndef NS_SWIFT_UNAVAILABLE
#define NS_SWIFT_UNAVAILABLE(msg)
#endif
#ifndef NS_NOESCAPE
#define NS_NOESCAPE
#endif
#ifndef NS_CLOSED_ENUM
#define NS_CLOSED_ENUM(type, name) NS_ENUM(type, name)
#endif
#ifndef NS_ERROR_ENUM
#define NS_ERROR_ENUM(domain, name) NS_ENUM(NSInteger, name)
#endif
#ifndef API_AVAILABLE
#define API_AVAILABLE(...)
#endif
#ifndef API_UNAVAILABLE
#define API_UNAVAILABLE(...)
#endif
#ifndef API_DEPRECATED
#define API_DEPRECATED(...)
#endif
#ifndef API_DEPRECATED_WITH_REPLACEMENT
#define API_DEPRECATED_WITH_REPLACEMENT(...)
#endif
#ifndef NS_FORMAT_ARGUMENT
#define NS_FORMAT_ARGUMENT(A)
#endif

// -[NSArray firstObject] exists since iOS 4 but was only made public in
// the iOS 7 SDK (CoreFoundation 6.1 implements it).
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
@interface NSArray (TFLCompat)
- (id)firstObject;
@end
#endif

#endif // __OBJC__
#endif // TFL_COMPAT_H
