//
//  AssertDemoViewController.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight (personal) on 2/11/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "AssertDemoViewController.h"

#import "PRTAssert.h"

#define trueExpression (YES == YES)
#define falseExpression (YES == NO)

@interface AssertDemoViewController ()

@property(weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation AssertDemoViewController

- (IBAction)testTrueProdAssert:(id)sender {
#if NS_BLOCK_ASSERTIONS == 0
  self.messageLabel.text = @"Careful! You have asserts enabled, and this would "
                           @"crash the app! Try running the demo with the "
                           @"Asserts Disabled build scheme.";
#else
  PRTAssert(trueExpression,
            ^{ self.messageLabel.text = @"passed :D"; },
            ^{ self.messageLabel.text = @"failed D:"; },
            @"This is a true expression. Why am I asserting?")
#endif
}

- (IBAction)testFalseProdAssert:(id)sender {
#if NS_BLOCK_ASSERTIONS == 0
  self.messageLabel.text = @"Careful! You have asserts enabled, and this would "
                           @"crash the app! Try running the demo with the "
                           @"Asserts Disabled build scheme.";
#else
  PRTAssert(falseExpression,
            ^{ self.messageLabel.text = @"passed :D"; },
            ^{ self.messageLabel.text = @"failed D:"; },
            @"I'm in production. Why am I asserting?")
#endif
}

- (IBAction)testTrueDevAssert:(id)sender {
#if NS_BLOCK_ASSERTIONS == 0
  PRTAssert(trueExpression,
            ^{ self.messageLabel.text = @"passed :D"; },
            ^{ self.messageLabel.text = @"failed D:"; },
            @"This is a true expression. Why am I asserting?")
#else
  self.messageLabel.text = @"You develop without assertions enabled? What me "
                           @"worry? Try running the demo with the Asserts "
                           @"Enabled build scheme.";
#endif
}

- (IBAction)testFalseDevAssert:(id)sender {
#if NS_BLOCK_ASSERTIONS == 0
  PRTAssert(falseExpression,
            ^{ self.messageLabel.text = @"passed :D"; },
            ^{ self.messageLabel.text = @"failed D:"; },
            @"This is a true expression. Why am I asserting?")
#else
  self.messageLabel.text = @"You develop without assertions enabled? What me "
                           @"worry? Try running the demo with the Asserts "
                           @"Enabled build scheme.";
#endif
}

@end
