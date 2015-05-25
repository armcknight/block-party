//
//  BluetoothBlocksDemoViewController.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "BluetoothBlocksDemoViewController.h"

#import "CBCentralManager+PRTBlocks.h"
#import "CBPeripheral+PRTBlocks.h"
#import "CBPeripheralManager+PRTBlocks.h"

#define TRANSFER_SERVICE_UUID @"E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
#define TRANSFER_CHARACTERISTIC_UUID @"08590F7E-DB05-467E-8757-72F6FAEB13D4"
#define NOTIFY_MTU 20

@interface BluetoothBlocksDemoViewController ()

// properties for acting as central
@property(strong, nonatomic) CBCentralManager* centralManager;
@property(strong, nonatomic) CBPeripheral* peripheral;
@property(strong, nonatomic) CBService* foundService;
@property(strong, nonatomic) CBCharacteristic* foundCharacteristic;
@property(strong, nonatomic) NSMutableData* data;

// properties for acting as peripheral
@property(strong, nonatomic) CBPeripheralManager* peripheralManager;
@property(strong, nonatomic) CBMutableService* transferService;
@property(strong, nonatomic) CBMutableCharacteristic* transferCharacteristic;

@property(strong, nonatomic) NSData* dataToSend;
@property(nonatomic, readwrite) NSInteger sendDataIndex;

@property(weak, nonatomic) IBOutlet UIView* selectionButtons;
@property(weak, nonatomic) IBOutlet UITextField* inputTextField;
@property(weak, nonatomic) IBOutlet UIButton* sendButton;
@property(weak, nonatomic) IBOutlet UILabel* receivedTextLabel;

@end

@implementation BluetoothBlocksDemoViewController

#pragma mark - IBActions

- (IBAction)sendPressed:(UIButton*)sender {
  sender.enabled = NO;
  self.dataToSend =
      [self.inputTextField.text dataUsingEncoding:NSUTF8StringEncoding];
  self.inputTextField.text = nil;
  [self sendData];
}

- (IBAction)centralPressed:(id)sender {
  self.selectionButtons.hidden = YES;
  self.receivedTextLabel.hidden = NO;

  self.centralManager =
      [[CBCentralManager alloc] initWithDelegate:nil queue:nil];

  PRTCharacteristicBlock characteristicUpdateCompletion =
      ^(CBPeripheral* peripheral, CBCharacteristic* characteristic,
        NSError* error) {
        if (error) {
          NSLog(@"Error discovering " @"characteristics: %@",
                [error localizedDescription]);
          return;
        }

        NSString* stringFromData =
            [[NSString alloc] initWithData:characteristic.value
                                  encoding:NSUTF8StringEncoding];

        // Have we got everything we need?
        if ([stringFromData isEqualToString:@"EOM"]) {
          // We have, so show the data,
          [self.receivedTextLabel
              setText:[[NSString alloc] initWithData:self.data
                                            encoding:NSUTF8StringEncoding]];
          self.data = [NSMutableData data];
        } else {
          if (!self.data) {
            self.data = [NSMutableData data];
          }
          [self.data appendData:characteristic.value];
        }
      };

  PRTCharacteristicBlock characteristicNotificationCompletion =
      ^(CBPeripheral* peripheral, CBCharacteristic* characteristic,
        NSError* error) {
        if (error) {
          NSLog(@"error " @"enabling" @" notific" @"ations: " @"%@", error);
        } else {
          [self.peripheral
              prt_characteristicUpdateHandler:characteristicUpdateCompletion];
        }
      };

  PRTServiceBlock characteristicCompletion = ^(CBPeripheral* peripheral,
                                                    CBService* service,
                                                    NSError* error) {
    if (error) {
      NSLog(@"error discovering " @"characteristics: %@", error);
    } else {
      for (CBCharacteristic* characteristic in service.characteristics) {
        if ([characteristic.UUID
                isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
          self.foundCharacteristic = characteristic;
          [self.peripheral
              prt_setNotifyValue:YES
               forCharacteristic:characteristic
                      completion:characteristicNotificationCompletion];
        }
      }
    }
  };

  PRTPeripheralBlock serviceCompletion = ^(CBPeripheral* peripheral,
                                                NSError* error) {
    if (error) {
      NSLog(@"error discovering services %@", error);
    } else {
      for (CBService* service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:TRANSFER_SERVICE_UUID]) {
          self.foundService = service;
          [self.peripheral prt_discoverCharacteristics:@[
            [CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
          ] forService:self.foundService completion:characteristicCompletion];
          break;
        }
      }
    }
  };

  NSArray* services = @[ [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] ];

  PRTCBPeripheralBlock peripheralConnectionCompletion =
      ^(CBCentralManager* central, CBPeripheral* peripheral, NSError* error) {
        if (error) {
          NSLog(@"error connecting %@", error);
        } else {
          [peripheral prt_discoverServices:services
                                completion:serviceCompletion];
        }
      };

  PRTCBPeripheralFoundBlock foundCompletion =
      ^(CBCentralManager* central, CBPeripheral* peripheral,
        NSDictionary* advData, NSNumber* RSSI) {
        self.peripheral = peripheral;
        //        [central stopScan];
        [central prt_connectPeripheral:peripheral
                               options:nil
                            completion:peripheralConnectionCompletion];
      };

  [self.centralManager
      prt_centralManagerDidUpdateStateHandler:^(CBCentralManager* central) {
        if (central.state != CBCentralManagerStatePoweredOn) {
          return;
        }

        [central prt_scanForPeripheralsWithServices:
                     services options:@{
          CBCentralManagerScanOptionAllowDuplicatesKey : @NO
        } completion:foundCompletion];
      }];
}

- (IBAction)peripheralPressed:(id)sender {
  self.selectionButtons.hidden = YES;
  self.inputTextField.hidden = NO;
  self.sendButton.hidden = NO;

  self.peripheralManager =
      [[CBPeripheralManager alloc] initWithDelegate:nil queue:nil];

  self.transferCharacteristic = [[CBMutableCharacteristic alloc]
      initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
        properties:CBCharacteristicPropertyNotify
             value:nil
       permissions:CBAttributePermissionsReadable];
  self.transferService = [[CBMutableService alloc]
      initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
           primary:YES];
  self.transferService.characteristics = @[ self.transferCharacteristic ];

  [self.peripheralManager
      prt_peripheralManagerDidUpdateStateHandler:^(CBPeripheralManager*
                                                       manager) {
        if (manager.state == CBPeripheralManagerStatePoweredOn) {
          if (!manager.isAdvertising) {
            [manager addService:self.transferService];
            [manager startAdvertising:@{
              CBAdvertisementDataServiceUUIDsKey :
                  @[ [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] ]
            }];
          }
        }
      }];

  [self.peripheralManager
      prt_peripheralManagerDidSubscribeToCharacteristicHandler:
          ^(CBPeripheralManager* manager, CBCentral* central,
            CBCharacteristic* characteristic) {
            self.sendButton.enabled = YES;
          }];

  [self.peripheralManager
      prt_peripheralManagerDidUnsubscribeToCharacteristicHandler:
          ^(CBPeripheralManager* manager, CBCentral* central,
            CBCharacteristic* characteristic) {
            self.sendButton.enabled = NO;
          }];

  [self.peripheralManager
      prt_peripheralManagerIsReadyToUpdateSubscribersHandler:
          ^(CBPeripheralManager* manager) {
            [self sendData];
          }];
}

// lifted straight from Apple's sample code at
// https://developer.apple.com/library/ios/samplecode/BTLE_Transfer/Introduction/Intro.html
- (void)sendData {
  // First up, check if we're meant to be sending an EOM
  static BOOL sendingEOM = NO;

  if (sendingEOM) {
    // send it
    BOOL didSend = [self.peripheralManager
                 updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding]
           forCharacteristic:self.transferCharacteristic
        onSubscribedCentrals:nil];

    // Did it send?
    if (didSend) {
      // It did, so mark it as sent
      sendingEOM = NO;

      self.sendButton.enabled = YES;

      self.sendDataIndex = 0;

      NSLog(@"Sent: EOM");
    }

    // It didn't send, so we'll exit and wait for
    // peripheralManagerIsReadyToUpdateSubscribers to call sendData again
    return;
  }

  // We're not sending an EOM, so we're sending data

  // Is there any left to send?

  if (self.sendDataIndex >= self.dataToSend.length) {
    // No data left.  Do nothing
    return;
  }

  // There's data left, so send until the callback fails, or we're done.

  BOOL didSend = YES;

  while (didSend) {
    // Make the next chunk

    // Work out how big it should be
    NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;

    // Can't be longer than 20 bytes
    if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;

    // Copy out the data we want
    NSData* chunk =
        [NSData dataWithBytes:self.dataToSend.bytes + self.sendDataIndex
                       length:amountToSend];

    // Send it
    didSend = [self.peripheralManager updateValue:chunk
                                forCharacteristic:self.transferCharacteristic
                             onSubscribedCentrals:nil];

    // If it didn't work, drop out and wait for the callback
    if (!didSend) {
      return;
    }

    NSString* stringFromData =
        [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
    NSLog(@"Sent: %@", stringFromData);

    // It did send, so update our index
    self.sendDataIndex += amountToSend;

    // Was it the last one?
    if (self.sendDataIndex >= self.dataToSend.length) {
      // It was - send an EOM

      // Set this so if the send fails, we'll send it next time
      sendingEOM = YES;

      // Send it
      BOOL eomSent = [self.peripheralManager
                   updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding]
             forCharacteristic:self.transferCharacteristic
          onSubscribedCentrals:nil];

      if (eomSent) {
        // It sent, we're all done
        sendingEOM = NO;

        NSLog(@"Sent: EOM");
      }

      return;
    }
  }
}

@end
