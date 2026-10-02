#line 1 "googleapp/comments.x"





#import <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "Translators/TRContinuation.h"
#include "general.h"

#pragma mark - Request Building


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

@class YTCommentParser; @class YTGDataRequestFactory; @class YTGDataRequest; @class YTCommentsFeedTableSectionController; @class YTGDataService; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddCommentWithVideoID$authentication$content$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id, NSString*); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddCommentWithVideoID$authentication$content$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddCommentWithVideoID$authentication$content$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddCommentWithVideoID$authentication$content$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id, NSString*); static void (*_logos_orig$_ungrouped$YTGDataService$makeCommentsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeCommentsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static id (*_logos_orig$_ungrouped$YTCommentParser$parseElement$error$)(_LOGOS_SELF_TYPE_NORMAL YTCommentParser* _LOGOS_SELF_CONST, SEL, NSDictionary*, NSError *); static id _logos_method$_ungrouped$YTCommentParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTCommentParser* _LOGOS_SELF_CONST, SEL, NSDictionary*, NSError *); static void (*_logos_orig$_ungrouped$YTCommentsFeedTableSectionController$setHeaderCellCommentsCount$)(_LOGOS_SELF_TYPE_NORMAL YTCommentsFeedTableSectionController* _LOGOS_SELF_CONST, SEL, uint64_t); static void _logos_method$_ungrouped$YTCommentsFeedTableSectionController$setHeaderCellCommentsCount$(_LOGOS_SELF_TYPE_NORMAL YTCommentsFeedTableSectionController* _LOGOS_SELF_CONST, SEL, uint64_t); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 14 "googleapp/comments.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddCommentWithVideoID$authentication$content$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id authentication, NSString* content) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/comment/create_comment?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder addCommentBodyWithVideoId:videoId 
                                                                      commentText:content 
                                                                           client:[YoutubeClientType webMobileClient]]];
}





static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddCommentWithVideoID$authentication$content$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id authentication, NSString* content) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/comment/create_comment?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder addCommentBodyWithVideoId:videoId 
                                                                      commentText:content 
                                                                           client:[YoutubeClientType webMobileClient]]];
}



#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeCommentsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id originalRequest, id responseBlock, id errorBlock) {
    YTGDataRequest *request = nil;
    NSLog(@"requesting comments!!!!!!!!");
    if ([[originalRequest valueForKey:l(@"URL")] isKindOfClass:[TRContinuation class]]) {
        TRContinuation *continuation = [originalRequest valueForKey:l(@"URL")];
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            request = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder continueWithContext:[continuation token]
                        client:[YoutubeClientType webMobileClient]]];
        } else {
            request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder continueWithContext:[continuation token]
                        client:[YoutubeClientType webMobileClient]]];
        }
        
    } else {
        NSString* videoId = [originalRequest valueForKey:l(@"URL")];
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            request = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder commentsBodyWithVideoId:videoId 
                                                        sortBy:@"top" 
                                                        client:[YoutubeClientType webMobileClient]]];
        } else {
            request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder commentsBodyWithVideoId:videoId 
                                                        sortBy:@"top" 
                                                        client:[YoutubeClientType webMobileClient]]];
        }
    }    
    
    [self makePOSTRequest:request 
               withParser:[self valueForKey:l(@"commentPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}



#pragma mark - Comment Parsing



static id _logos_method$_ungrouped$YTCommentParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTCommentParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary* body, NSError * error) {
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        TRCommentTranslator *translator = [[[TRCommentTranslator alloc] init] autorelease];
        NSError *translatorError = nil;
        id comment = [translator translateJSON:body error:&translatorError];
        
        if (translatorError) {
            NSLog(@"TRCommentTranslator error: %@", translatorError);
        }
        
        return comment;
    }
    
    NSLog(@"YTCommentParser: input is not NSDictionary");
    return nil;
}




static void _logos_method$_ungrouped$YTCommentsFeedTableSectionController$setHeaderCellCommentsCount$(_LOGOS_SELF_TYPE_NORMAL YTCommentsFeedTableSectionController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, uint64_t commentCount) {
    if (commentCount == 2147483647) {
        [[self valueForKey:@"headerCell"] setTitle:localizedStringForKeyUILib(@"watch.comments")];
    } else {
        _logos_orig$_ungrouped$YTCommentsFeedTableSectionController$setHeaderCellCommentsCount$(self, _cmd, commentCount);
    }
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToAddCommentWithVideoID:authentication:content:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToAddCommentWithVideoID$authentication$content$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddCommentWithVideoID$authentication$content$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToAddCommentWithVideoID:authentication:content:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToAddCommentWithVideoID$authentication$content$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddCommentWithVideoID$authentication$content$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeCommentsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeCommentsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeCommentsRequest$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTCommentParser = objc_getClass("YTCommentParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTCommentParser, @selector(parseElement:error:), (IMP)&_logos_method$_ungrouped$YTCommentParser$parseElement$error$, (IMP*)&_logos_orig$_ungrouped$YTCommentParser$parseElement$error$);}Class _logos_class$_ungrouped$YTCommentsFeedTableSectionController = objc_getClass("YTCommentsFeedTableSectionController"); { MSHookMessageEx(_logos_class$_ungrouped$YTCommentsFeedTableSectionController, @selector(setHeaderCellCommentsCount:), (IMP)&_logos_method$_ungrouped$YTCommentsFeedTableSectionController$setHeaderCellCommentsCount$, (IMP*)&_logos_orig$_ungrouped$YTCommentsFeedTableSectionController$setHeaderCellCommentsCount$);}} }
#line 117 "googleapp/comments.x"
