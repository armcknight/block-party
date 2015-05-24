//
//  CBCentralManager+PRTBlocks.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

/**
 *  Block that returns the instance of @c CBCentralManager.
 *
 *  @param central The instance of @c CBCentralManager returned in the callback.
 */
typedef void (^PRTCBCentralBlock)(CBCentralManager *central);

/**
 *  Block called for state restoration preparation.
 *
 *  @param central   Instance of @c CBCentralManager performing the state 
 *                   restoration.
 *  @param stateDict @c NSDictionary containing state configuration.
 */
typedef void (^PRTCBCentralRestoreBlock)(CBCentralManager *central,
                                         NSDictionary *stateDict);

/**
 *  Block that returns a peripheral for completion of (dis)connection.
 *
 *  @param central    The @c CBCentralManager instance.
 *  @param peripheral The @c CBPeripheral just connected or disconnected.
 *  @param error      Any error during the (dis)connection event.
 */
typedef void (^PRTCBPeripheralBlock)(CBCentralManager *central,
                                          CBPeripheral *peripheral,
                                          NSError *error);

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7
/**
 *  Block called when a list of peripherals is retrieved from the 
 *  @c CBCentralManager.
 *
 *  @param central     The @c CBCentralManager instance.
 *  @param peripherals List of detected or connected peripherals.
 */
typedef void (^PRTCBPeripheralsBlock)(CBCentralManager *central,
                                      NSArray *peripherals);
#endif

/**
 *  Block called when a @c CBPeripheral is found during a scan.
 *
 *  @param central           The @c CBCentralManager instance.
 *  @param peripheral        The detected @c CBPeripheral.
 *  @param advertisementData Additional data about the detected @c CBPeripheral.
 *  @param RSSI              The strength of the peripheral's radio signal.
 */
typedef void (^PRTCBPeripheralFoundBlock)(CBCentralManager *central,
                                          CBPeripheral *peripheral,
                                          NSDictionary *advertisementData,
                                          NSNumber *RSSI);

/**
 *  A category providing block-based methods to replace the API's delegate 
 *  pattern for things like scanning for peripherals, connecting and 
 *  disconnecting them, and reading and writing data.
 */
@interface CBCentralManager (PRTBlocks)

/**
 *  Set a block to execute whenever the central manager's state changes 
 *  (replaces @c centralManagerDidUpdateState:).
 *
 *  @param handler Block to be executed on state changes.
 */
- (void)prt_centralManagerDidUpdateStateHandler:(PRTCBCentralBlock)handler;

/**
 *  Set a block to execute whenever the central manager is about to restore 
 *  state from a previous instance (replaces 
 *  @c centralManager:willRestoreState:).
 *
 *  @param handler Block to be called where you can synchronize the app's state 
 *         with the Core Bluetooth system.
 */
- (void)prt_centralManagerWillRestoreStateHandler:
        (PRTCBCentralRestoreBlock)handler;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7
/**
 *  Ask for a list of peripherals matching the provided UUIDs.
 *
 *  @param peripheralUUIDs List of UUIDs to match.
 *  @param completion      Block called providing all the detected peripherals.
 */
- (void)prt_retrievePeripherals:(NSArray *)peripheralUUIDs
                     completion:(PRTCBPeripheralsBlock)completion;

/**
 *  Ask for a list of all peripherals currently connected to this device.
 *
 *  @param completion Block called returning the list of peripherals.
 */
- (void)prt_retrieveConnectedPeripheralsWithCompletion:
        (PRTCBPeripheralsBlock)completion;
#endif

/**
 *  Scan for peripherals matching the list of service UUIDs provided and call 
 *  the completion block for each one.
 *
 *  @param serviceUUIDs List of UUIDs of services to match in peripherals.
 *  @param options      Optional dictionary of options for the scan.
 *  @param completion   Block called for each peripheral detected with one of 
 *                      the specified service UUIDs.
 */
- (void)prt_scanForPeripheralsWithServices:(NSArray *)serviceUUIDs
                                   options:(NSDictionary *)options
                                completion:
                                    (PRTCBPeripheralFoundBlock)completion;

/**
 *  Connect a discovered peripheral and call the completion block, reporting any 
 *  errors encountered.
 *
 *  @param peripheral Peripheral to connect.
 *  @param options    Optional dictionary of options for connection behavior.
 *  @param completion Block called on success or failure to connect.
 */
- (void)prt_connectPeripheral:(CBPeripheral *)peripheral
                      options:(NSDictionary *)options
                   completion:(PRTCBPeripheralBlock)completion;

/**
 *  Close an active or pending connection to a peripheral.
 *
 *  @param peripheral Peripheral to disconnect.
 *  @param completion Block called when connection is closed.
 */
- (void)prt_cancelPeripheralConnection:(CBPeripheral *)peripheral
                            completion:(PRTCBPeripheralBlock)completion;

@end
