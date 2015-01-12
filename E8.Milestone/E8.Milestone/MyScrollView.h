#import <UIKit/UIKit.h>

@interface MyScrollView : UIScrollView<UIScrollViewDelegate> {
    CGSize          originalSize;
    UIImageView*    images[2];
    UILabel*        labels[2];
    UIPageControl*  pageControl;
}

- (void)addPageControlToView:(UIView*)view withY:(float)y;
- (void)updateSubSize;

@end
