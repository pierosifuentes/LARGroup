//
//  Flat+CoreDataProperties.h
//  LARGruop
//
//  Created by Piero on 4/10/15.
//  Copyright © 2015 prsp.org. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Flat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Flat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *flatImageURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *size;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) Floor *floors;
@property (nullable, nonatomic, retain) Plant *plant;
@property (nullable, nonatomic, retain) NSSet<Rate *> *rates;

@end

@interface Flat (CoreDataGeneratedAccessors)

- (void)addRatesObject:(Rate *)value;
- (void)removeRatesObject:(Rate *)value;
- (void)addRates:(NSSet<Rate *> *)values;
- (void)removeRates:(NSSet<Rate *> *)values;

@end

NS_ASSUME_NONNULL_END
