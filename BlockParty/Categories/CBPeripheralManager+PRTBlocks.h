//
//  CBPeripheralManager+PRTBlocks.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/28/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

/**
 *  Block called when updating the state of the @c CBPeripheralManager or it
 *  becomes ready (again) to notify subscribers of updates to characteristics.
 *
 *  @param manager The @c CBPeripheralManager being updated.
 */
typedef void (^PRTPeriphalManagerBlock)(CBPeripheralManager *manager);

/**
 *  Block called when a @c CBPeripheralManager's state will be restored.
 *
 *  @param manager   The @c CBPeripheralManager being state-restored.
 *  @param stateDict @c NSDictionary containing state information.
 */
typedef void (^PRTPeripheralManagerStateRestoreBlock)(
    CBPeripheralManager *manager, NSDictionary *stateDict);

/**
 *  Block called when a @c CBPeripheralManager begins advertising services, 
 *  after it receives a message to begin advertising.
 *
 *  @param manager The @c CBPeripheralManager that is advertising services.
 *  @param error   Any error that was encountered if the @c CBPeripheralManager 
 *                 could not begin advertising.
 */
typedef void (^PRTPeripheralManagerAdvertisingBlock)(
    CBPeripheralManager *manager, NSError *error);

/**
 *  Block called when a @c CBService is added to a @c CBPeripheralManager.
 *
 *  @param manager The @c CBPeripheralManager receiving the @c CBService.
 *  @param service The @c CBService that was added.
 *  @param error   Any error encountered if the service could not be added.
 */
typedef void (^PRTPeripheralManagerServiceBlock)(CBPeripheralManager *manager,
                                                 CBService *service,
                                                 NSError *error);

/**
 *  Block to call whenever a @c CBCentral updates the notification state of a @c
 *  CBCharacteristic.
 *
 *  @param manager        The @c CBPeripheralManager providing the update.
 *  @param central        The @c CBCentral that updated the notification state.
 *  @param characteristic The @c CBCharacteristic whose notification state is
 *                        being updated.
 */
typedef void (^PRTPeripheralManagerCharacteristicBlock)(
    CBPeripheralManager *manager, CBCentral *central,
    CBCharacteristic *characteristic);

/**
 *  Block to call when a request to read the value of a @c
 *  CBCharacteristic is received by a @c CBPeripheralManager.
 *
 *  @param manager The @c CBPeripheralManager receiving the request.
 *  @param request The @c CBATTRequest being issued.
 */
typedef void (^PRTPeripheralManagerReadRequestBlock)(
    CBPeripheralManager *manager, CBATTRequest *request);

/**
 *  Block to call when a requst to write to one or more @c CBCharacteristics are
 *  issued to a @c CBPeripheralManager.
 *
 *  @param manager  The @c CBPeripheralManager receiving the request(s).
 *  @param requests One or more @c CBATTRequest objects being issued.
 */
typedef void (^PRTPeripheralManagerWriteRequestsBlock)(
    CBPeripheralManager *manager, NSArray *requests);

/**
 *  Category providing block-based methods that combine the methods on @c 
 *  CBPeripheralManager with their corresponding callbacks in @c 
 *  CBPeripheralManagerDelegate.
 *
 *  @see CBPeripheralManager and @c CBPeripheralManagerDelegate
 */
@interface CBPeripheralManager (PRTBlocks)

/**
 *  @see @c peripheralManagerDidUpdateState:
 *
 *  @param handler Block to call when the @c CBPeripheralManager state updates.
 */
- (void)prt_peripheralManagerDidUpdateStateHandler:
        (PRTPeriphalManagerBlock)handler;

/**
 *  @see @c peripheralManager:willRestoreState:
 *
 *  @param handler Block to call when the state the @c CBPeripheralManager is
 *                 about to be restored with the provided information.
 */
- (void)prt_peripheralManagerWillRestoreStateHandler:
        (PRTPeripheralManagerStateRestoreBlock)handler;

/**
 *  @see @c startAdvertising:
 *  @see @c peripheralManagerDidStartAdvertising:error:
 *
 *  @param advertisementData Optional dictionary containing data to advertise.
 *  @param completion        Block to call when advertising is started or fails.
 */
- (void)prt_startAdvertising:(NSDictionary *)advertisementData
                  completion:(PRTPeripheralManagerAdvertisingBlock)completion;

/**
 *  @see @c addService:
 *  @see @c peripheralManager:didAddService:error:
 *
 *  @param service    The @c CBMutableService to add.
 *  @param completion Block to call when a service is added or addition fails.
 */
- (void)prt_addService:(CBMutableService *)service
            completion:(PRTPeripheralManagerServiceBlock)completion;

/**
 *  @see @c peripheralManager:central:didSubscribeToCharacteristic:
 *
 *  @param handler Block to call when notifications are enabled on the specified
 *                 @c CBCharacteristic.
 */
- (void)prt_peripheralManagerDidSubscribeToCharacteristicHandler:
        (PRTPeripheralManagerCharacteristicBlock)handler;

/**
 *  @see @c peripheralManager:central:didUnsubscribeFromCharacteristic:
 *
 *  @param handler Block to call when notifications are disabled on the 
 *                 specified @c CBCharacteristic.
 */
- (void)prt_peripheralManagerDidUnsubscribeToCharacteristicHandler:
        (PRTPeripheralManagerCharacteristicBlock)handler;

/**
 *  @see @c peripheralManager:didReceiveReadRequest:
 *
 *  @param handler Block to call when receiving a read request.
 */
- (void)prt_peripheralManagerDidReceiveReadRequestHandler:
        (PRTPeripheralManagerReadRequestBlock)handler;

/**
 *  @see @c peripheralManager:didReceiveWriteRequests:
 *
 *  @param handler Block to call when a collection of one or more write requests
 *                 is received.
 */
- (void)prt_peripheralManagerDidReceiveWriteRequestsHandler:
        (PRTPeripheralManagerWriteRequestsBlock)handler;

/**
 *  @see @c peripheralManagerIsReadyToUpdateSubscribers:
 *
 *  @param handler Block to call when the specified @c CBPeripheralManager is 
 *  ready to update subscribers to characteristics or becomes able to do so 
 *  after a failure.
 */
- (void)prt_peripheralManagerIsReadyToUpdateSubscribersHandler:
        (PRTPeriphalManagerBlock)handler;

@end
