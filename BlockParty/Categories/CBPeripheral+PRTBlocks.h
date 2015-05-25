//
//  CBPeripheral+PRTBlocks.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

/**
 *  Block called when an RSSI reading is provided to the delegate.
 *
 *  @param peripheral Peripheral whose RSSI is being reported.
 *  @param RSSI       The RSSI reading of the peripheral device.
 *  @param error      Any error in reading the RSSI.
 */
typedef void (^PRTRSSIBlock)(CBPeripheral *peripheral, NSNumber *RSSI,
                             NSError *error);

/**
 *  Block that returns reference to peripheral and an error, if any, when 
 *  performing operations related to services and peripheral name.
 *
 *  @param peripheral @c CBPeripheral object being updated.
 *  @param error      Any error encountered in the requested operation.
 */
typedef void (^PRTPeripheralBlock)(CBPeripheral *peripheral, NSError *error);

/**
 *  Block called when services on a @c CBPeripheral device have been modified.
 *
 *  @param peripheral          The @c CBPeripheral with modified services.
 *  @param invalidatedServices The @c CBService that were invalidated on the 
 *                             device.
 */
typedef void (^PRTInvalidatedServicesBlock)(CBPeripheral *peripheral,
                                            NSArray *invalidatedServices);

/**
 *  Block called when discovering @c CBServices and their characteristics.
 *
 *  @param peripheral @c CBPeripheral with services being discovered.
 *  @param service    The owning @c CBService of included services or 
 *                    characteristics being discovered.
 *  @param error      Any error encountered in the discovery process.
 */
typedef void (^PRTServiceBlock)(CBPeripheral *peripheral, CBService *service,
                                NSError *error);

/**
 *  Block called when reading from or writing to a @c CBCharacteristic, or when
 *  discovering @c CBDescriptors on a @c CBCharacteristic.
 *
 *  @param peripheral     @c CBPeripheral object owning the characteristic.
 *  @param characteristic The @c CBCharacteristic being operated on.
 *  @param error          Any error in the characteristic operation.
 */
typedef void (^PRTCharacteristicBlock)(CBPeripheral *peripheral,
                                       CBCharacteristic *characteristic,
                                       NSError *error);

/**
 *  Block called when reading from or writing to a @c CBCharacteristic's 
 *  @c CBDescriptor.
 *
 *  @param peripheral @c CBPeripheral object owning the @c CBCharacteristic's
 *                    @c CBDescriptor.
 *  @param descriptor The @c CBDescriptor being operated on.
 *  @param error      Any error encountered in the descriptor operation.
 */
typedef void (^PRTDescriptorBlock)(CBPeripheral *peripheral,
                                   CBDescriptor *descriptor,
                                   NSError *error);

/**
 *  Category providing block-based methods that combine the methods on @c
 *  CBPeripheral with their corresponding callbacks in @c CBPeripheralDelegate.
 *
 *  @see @c CBPeripheral and @c CBPeripheralDelegate
 */
@interface CBPeripheral (PRTBlocks)

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 6

/**
 *  @see @c peripheralDidUpdateName:
 *
 *  @param handler Block called whenever the @c CBPeripheral updates its name. 
 *                 Does not return an @c NSError.
 */
- (void)prt_peripheralDidUpdateNameHandler:(PRTPeripheralBlock)handler;

#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7

/**
 *  @see @c peripheralDidInvalidateServices:
 *
 *  @param handler Block to call when a @c CBPeripheral object's services are 
 *                 invalidated.
 */
- (void)prt_peripheralDidInvalidateServicesHandler:(PRTPeripheralBlock)handler;

#else

/**
 *  @see @c peripheral:didModifyServices:
 *
 *  @param handler Block to call when a @c CBPeripheral object's services are
 *                 modified, returning those that were invalidated.
 */
- (void)prt_peripheralDidModifyServicesHandler:
    (PRTInvalidatedServicesBlock)handler;

#endif

/**
 *  Send message to get the RSSI of the @c CBPeripheral and read the value 
 *  returned in either @c peripheralDidUpdateRSSI:error: or @c 
 *  peripheral:didReadRSSI:error:, depending on the minimum iOS build version.
 *
 *  @see @c readRSSI
 *  @see @c peripheralDidUpdateRSSI:error: and @c peripheral:didReadRSSI:error:
 *
 *  @param completion Block to call when an RSSI reading is provided.
 */
- (void)prt_readRSSIWithCompletion:(PRTRSSIBlock)completion;

/**
 *  @see @c discoverServices:
 *  @see @c peripheral:didDiscoverServices:
 *
 *  @param serviceUUIDs List of UUIDs for services to discover, or nil to find
 *                      all services.
 *  @param completion   Block to call when discovery is complete.
 */
- (void)prt_discoverServices:(NSArray *)serviceUUIDs
                  completion:(PRTPeripheralBlock)completion;

/**
 *  @see @c discoverIncludedServices:forService:
 *  @see @c peripheral:didDiscoverIncludedServicesForService:error:
 *
 *  @param includedServiceUUIDs List of UUIDs for services to discover, or nil
 *                              to find all included services.
 *  @param service              Service to search for included services.
 *  @param completion           Block to call when discovery is complete.
 */
- (void)prt_discoverIncludedServices:(NSArray *)includedServiceUUIDs
                          forService:(CBService *)service
                          completion:(PRTServiceBlock)completion;

/**
 *  @see @c discoverCharacteristics:forService:
 *  @see @c peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param characteristicUUIDs List of UUIDs for characteristics to discover, or
 *                             nil to find all characteristics.
 *  @param service             Service to search for characteristics.
 *  @param completion          Block to call when discovery is complete.
 */
- (void)prt_discoverCharacteristics:(NSArray *)characteristicUUIDs
                         forService:(CBService *)service
                         completion:(PRTServiceBlock)completion;

/**
 *  Writes a value to the specified characteristic with type @c
 *  CBCharacteristicWriteWithResponse.
 *
 *  @see @c writeValue:forCharacteristic:type:
 *  @see @c peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param data           Value to write to the characteristic.
 *  @param characteristic Characteristic to which to write the value.
 *  @param completion     Block to execute on receipt of @c
 *                        peripheral:didWriteValueForCharacteristic:error:
 */
- (void)prt_writeValue:(NSData *)data
     forCharacteristic:(CBCharacteristic *)characteristic
            completion:(PRTCharacteristicBlock)completion;

/**
 *  @see @c readValueForCharacteristic:
 *  @see @c peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param handler Block to call when a @c CBCharacteristic's value is ready for
 *                 reading a new value.
 */
- (void)prt_characteristicUpdateHandler:(PRTCharacteristicBlock)handler;

/**
 *  @see @c setNotifyValue:forCharacteristic:
 *  @see @c peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param enabled        @c YES to enable notifications on the @c 
 *                        CBCharacteristic, @c NO to disable them.
 *  @param characteristic The @c CBCharacteristic whose notification state shall
 *                        be updated.
 *  @param completion     Block to call when notification state is updated.
 */
- (void)prt_setNotifyValue:(BOOL)enabled
         forCharacteristic:(CBCharacteristic *)characteristic
                completion:(PRTCharacteristicBlock)completion;

/**
 *  @see @c discoverDescriptorsForCharacteristic:
 *  @see @c peripheral:didDiscoverDescriptorsForCharacteristic:error:
 *
 *  @param characteristic @c CBCharacteristic on which to discover @c 
 *                        CBDescriptors.
 *  @param completion     Block to call when discovery is complete.
 */
- (void)
    prt_discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
                                  completion:
                                      (PRTCharacteristicBlock)completion;

/**
 *  @see @c writeValue:forDescriptor:
 *  @see @c peripheral:didWriteValueForDescriptor:error:
 *
 *  @param data       @c NSData to write to the @c CBDescriptor.
 *  @param descriptor The @c CBDescriptor to receive the written data.
 *  @param completion Block to call when the write is acknowledged.
 */
- (void)prt_writeValue:(NSData *)data
         forDescriptor:(CBDescriptor *)descriptor
            completion:(PRTDescriptorBlock)completion;

/**
 *  @see @c readValueForDescriptor:
 *  @see @c peripheral:didUpdateValueForDescriptor:error:
 *
 *  @param handler Block to call when a @c CBDescriptor has new data ready to be
 *                 read.
 */
- (void)prt_descriptorUpdateHandler:(PRTDescriptorBlock)handler;

@end
