//
//  PRTAssert.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 2/11/15.
//
//  Copyright (c) 2015 Andrew McKnight.
//  http://armcknight.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#ifndef __PRT_ASSERT_H
#define __PRT_ASSERT_H

typedef BOOL (^PRTConditionBlock)(void);
typedef void (^PRTSuccessBlock)(void);
typedef void (^PRTFailureBlock)(void);

#define PRTAssert(conditionBlock, successBlock, failureBlock, desc) \
  NSAssert(conditionBlock(), desc);                                 \
  if (conditionBlock()) {                                           \
    successBlock();                                                 \
  } else {                                                          \
    failureBlock();                                                 \
  }

#define PRTAssertFormat(conditionBlock, successBlock, failureBlock, desc, ...) \
  NSAssert(conditionBlock(), desc, __VA_ARGS__);                               \
  if (conditionBlock()) {                                                      \
    successBlock();                                                            \
  } else {                                                                     \
    failureBlock();                                                            \
  }

#endif
