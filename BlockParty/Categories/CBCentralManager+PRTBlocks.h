//
//  CBCentralManager+PRTBlocks.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^PRTCBCentralBlock)(CBCentralManager *central);
typedef void (^PRTCBCentralRestoreBlock)(CBCentralManager *central,
                                         NSDictionary *stateDict);
typedef void (^PRTCBPeripheralBlock)(CBCentralManager *central,
                                          CBPeripheral *peripheral,
                                          NSError *error);
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7
typedef void (^PRTCBPeripheralsBlock)(CBCentralManager *central,
                                      NSArray *peripherals);
#endif
typedef void (^PRTCBPeripheralFoundBlock)(CBCentralManager *central,
                                          CBPeripheral *peripheral,
                                          NSDictionary *advertisementData,
                                          NSNumber *RSSI);

@interface CBCentralManager (PRTBlocks)

- (void)prt_centralManagerDidUpdateStateHandler:(PRTCBCentralBlock)handler;

- (void)prt_centralManagerWillRestoreStateHandler:
        (PRTCBCentralRestoreBlock)handler;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7

- (void)prt_retrievePeripherals:(NSArray *)peripheralUUIDs
                     completion:(PRTCBPeripheralsBlock)completion;

- (void)prt_retrieveConnectedPeripheralsWithCompletion:
        (PRTCBPeripheralsBlock)completion;

#endif

- (void)prt_scanForPeripheralsWithServices:(NSArray *)serviceUUIDs
                                   options:(NSDictionary *)options
                                completion:
                                    (PRTCBPeripheralFoundBlock)completion;

- (void)prt_connectPeripheral:(CBPeripheral *)peripheral
                      options:(NSDictionary *)options
                   completion:(PRTCBPeripheralBlock)completion;

- (void)prt_cancelPeripheralConnection:(CBPeripheral *)peripheral
                            completion:(PRTCBPeripheralBlock)completion;

@end
