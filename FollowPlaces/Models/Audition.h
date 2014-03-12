
#import "Icon.h"

@interface Audition : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) Icon *videoThumbnail;
@property (nonatomic, strong) NSString *dateCreated;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *userFacebookId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic) NSInteger applauseCount;
@property (nonatomic) NSInteger viewCount;


@end