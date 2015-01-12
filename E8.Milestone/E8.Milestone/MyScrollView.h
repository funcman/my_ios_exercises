#import <UIKit/UIKit.h>

@interface MyScrollView : UIScrollView {
    CGSize          originalSize;
    UIImageView*    images[2];
    UILabel*        labels[2];
}

- (void)updateSubSize;

@end
