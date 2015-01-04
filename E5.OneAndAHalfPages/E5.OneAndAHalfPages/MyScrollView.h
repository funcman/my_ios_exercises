#import <UIKit/UIKit.h>

@interface MyScrollView : UIScrollView<UIScrollViewDelegate> {
    UIScrollView *scroll_view;
    UIView *up_view1;
    UIView *up_view2;
    UIView *down_view;

    CGRect scroll_view_frame;
    CGRect up_view1_frame;
    CGRect up_view2_frame;
}

- (id)initWithFrame:(CGRect)frame;
- (void)setSubviewOnUpside:(UIView*)view and:(UIView*)anotherv_view;
- (void)setSubviewOnDownsize:(UIView*)view;
- (void)updateContentSizeWithUpsideSegmentation:(float)up_per downsideSegmentation:(float)down_per;

@end
