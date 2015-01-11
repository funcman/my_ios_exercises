#import <Foundation/Foundation.h>

@interface DTItem : NSObject {
    int         _identity;
    NSString*   _dateTime;
}

@property int       identity;
@property NSString* dateTime;

- (id)initWithIdentity:(int)identity dateTime:(NSString*)datetime;

@end
