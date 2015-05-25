//
//  CBPeripheralManager+PRTBlocks.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/28/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^PRTPeriphalManagerBlock)(CBPeripheralManager *manager);
typedef void (^PRTPeripheralManagerStateRestoreBlock)(
    CBPeripheralManager *manager, NSDictionary *stateDict);
typedef void (^PRTPeripheralManagerAdvertisingBlock)(
    CBPeripheralManager *manager, NSError *error);
typedef void (^PRTPeripheralManagerServiceBlock)(CBPeripheralManager *manager,
                                                 CBService *service,
                                                 NSError *error);
typedef void (^PRTPeripheralManagerCharacteristicBlock)(
    CBPeripheralManager *manager, CBCentral *central,
    CBCharacteristic *characteristic);
typedef void (^PRTPeripheralManagerReadRequestBlock)(
    CBPeripheralManager *manager, CBATTRequest *request);
typedef void (^PRTPeripheralManagerWriteRequestsBlock)(
    CBPeripheralManager *manager, NSArray *requests);

@interface CBPeripheralManager (PRTBlocks)

- (void)prt_peripheralManagerDidUpdateStateHandler:
        (PRTPeriphalManagerBlock)handler;
- (void)prt_peripheralManagerWillRestoreStateHandler:
        (PRTPeripheralManagerStateRestoreBlock)handler;
- (void)prt_startAdvertising:(NSDictionary *)advertisementData
                  completion:(PRTPeripheralManagerAdvertisingBlock)completion;
- (void)prt_addService:(CBMutableService *)service
            completion:(PRTPeripheralManagerServiceBlock)completion;
- (void)prt_peripheralManagerDidSubscribeToCharacteristicHandler:
        (PRTPeripheralManagerCharacteristicBlock)handler;
- (void)prt_peripheralManagerDidUnsubscribeToCharacteristicHandler:
        (PRTPeripheralManagerCharacteristicBlock)handler;
- (void)prt_peripheralManagerDidReceiveReadRequestHandler:
        (PRTPeripheralManagerReadRequestBlock)handler;
- (void)prt_peripheralManagerDidReceiveWriteRequestsHandler:
        (PRTPeripheralManagerWriteRequestsBlock)handler;
- (void)prt_peripheralManagerIsReadyToUpdateSubscribersHandler:
        (PRTPeriphalManagerBlock)handler;

@end
