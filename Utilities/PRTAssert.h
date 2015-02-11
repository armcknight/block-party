//
//  PRTAssert.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 2/11/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
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
