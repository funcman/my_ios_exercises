#import "DTItem.h"

@implementation DTItem

@synthesize identity = _identity;
@synthesize dateTime = _dateTime;

- (id)initWithIdentity:(int)identity dateTime:(NSString *)datetime {
    self = [super init];
    if (self) {
        _identity = identity;
        _dateTime = datetime;
    }
    return self;
}

@end
