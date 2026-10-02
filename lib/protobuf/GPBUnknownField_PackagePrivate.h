// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.  All rights reserved.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

#import <Foundation/Foundation.h>

#import "GPBUnknownField.h"

@interface GPBUnknownField ()

- (instancetype)initWithNumber:(int32_t)number varint:(uint64_t)varint;
- (instancetype)initWithNumber:(int32_t)number fixed32:(uint32_t)fixed32;
- (instancetype)initWithNumber:(int32_t)number fixed64:(uint64_t)fixed64;
- (instancetype)initWithNumber:(int32_t)number lengthDelimited:(NSData *)data;
- (instancetype)initWithNumber:(int32_t)number group:(GPBUnknownFields *)group;

- (size_t)computeSerializedSize __attribute__((objc_direct));
- (void)writeToCodedOutputStream:(GPBCodedOutputStream *)output
    __attribute__((objc_direct));

@end
