#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FMDatabase 2.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions 2.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool 2.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue 2.h"
#import "FMDatabaseQueue.h"
#import "FMDB 2.h"
#import "FMDB.h"
#import "FMResultSet 2.h"
#import "FMResultSet.h"

FOUNDATION_EXPORT double FMDBVersionNumber;
FOUNDATION_EXPORT const unsigned char FMDBVersionString[];

