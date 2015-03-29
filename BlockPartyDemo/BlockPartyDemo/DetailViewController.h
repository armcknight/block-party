//
//  DetailViewController.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 2/11/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PRTDemo) {
  PRTDemoNavBlocks,
  PRTDemoAsserts,
  PRTDemoBluetooth
};

@interface DetailViewController : UIViewController

@property(assign, nonatomic) PRTDemo demo;

@end
