//
//  Place.m
//  BookMyShowTask
//
//  Created by Jagadeeshwar on 06/11/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "Place.h"

#define kGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
static NSTimeInterval cacheTime =  (double)604800;

@implementation PlacePhoto

-(id)initWithMaxWidth:(NSInteger)maxWidth withMaxHeight:(NSInteger)maxHeight withPhotoReference:(NSString *)photo_reference withPlace:(NSString *)placeId{
    self=[super init];
    
    if (self) {
        self.maxWidth=maxWidth;
        self.maxHeight=maxHeight;
        self.photo_reference=photo_reference;
        self.placeId=placeId;
    }
    return self;
}

-(void)getImageObjectWithCompletionBlock:(void (^)(NSData *data))finishBlock{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* fullFilePath = [[self cacheDirectoryName] stringByAppendingPathComponent:self.placeId];

    //check if the image is available in cache
    if ([fileManager fileExistsAtPath:fullFilePath]) {
        
        //check if cache expired
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:fullFilePath error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:fullFilePath error:nil];
            
            [self loadImageFromServerWithCompletionBlock:^(NSData *data) {
                finishBlock(data);
            }];
            
        } else {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:fullFilePath]];
            finishBlock(imageData);
        }
    }else{

        [self loadImageFromServerWithCompletionBlock:^(NSData *data) {
            finishBlock(data);
        }];
    }
}
-(void)loadImageFromServerWithCompletionBlock:(void (^)(NSData *data))block{
    dispatch_async(kGlobalQueue, ^{
        
        NSString* fullFilePath = [[self cacheDirectoryName] stringByAppendingPathComponent:self.placeId];

        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=AIzaSyBroCC5NHKPzai5A3odoEh4-dUvumTvWTc",self.photo_reference];
        NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        
        if (imageData) {
            [imageData writeToFile:fullFilePath atomically:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(imageData);
        });
    });
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"PlacesImages"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:cacheDirectoryName isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return cacheDirectoryName;
}
@end

@implementation PlaceGeometry
-(id)initWithLat:(NSString*)latitude andLong:(NSString*)longitude;
{
    self=[super init];
    
    if (self) {
        self.latitude=latitude;
        self.longitude=longitude;
    }
    return self;
}
@end



@implementation Place
-(id)initWithJsonData:(NSDictionary *)JsonDict{
    self = [super init];
    if (self) {
        self.pid= JsonDict[@"id"];
        self.iconPath= JsonDict[@"icon"];
        self.name= JsonDict[@"name"];
        self.vicinity=JsonDict[@"vicinity"];
        
        NSDictionary *locationDict = JsonDict[@"geometry"][@"location"];
        self.geometry=[[PlaceGeometry alloc] initWithLat:[locationDict[@"lat"] stringValue] andLong:[locationDict[@"lng"] stringValue]];
        
        NSArray *photos=JsonDict[@"photos"];
        self.placePhotos=[[NSMutableArray alloc] initWithCapacity:photos.count];
        [photos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [self.placePhotos addObject:[[PlacePhoto alloc] initWithMaxWidth:[obj[@"width"] integerValue] withMaxHeight:[obj[@"height"] integerValue] withPhotoReference:obj[@"photo_reference"] withPlace:self.pid]];
        }];
        
    }
    return self;
}

@end



