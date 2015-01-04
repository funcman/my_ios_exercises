#import "MyScrollView.h"

@interface MyScrollView()

@end

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
    }
    return self;
}

- (void)setSubviewOnUpside:(UIView *)view and:(UIView *)anotherv_view {
    up_view1 = view;
    up_view2 = anotherv_view;
    scroll_view = [[UIScrollView alloc]init];
    [self addSubview:scroll_view];
    [scroll_view addSubview:up_view1];
    [scroll_view addSubview:up_view2];
}

- (void)setSubviewOnDownsize:(UIView *)view {
    down_view = view;
    [self addSubview:down_view];
}

- (void)updateContentSizeWithUpsideSegmentation:(float)up_per downsideSegmentation:(float)down_per {
    CGRect frame = [[UIScreen mainScreen] bounds];
    scroll_view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height*up_per);
    up_view1.frame = scroll_view.frame;
    up_view2.frame = CGRectOffset(up_view1.frame, up_view1.frame.size.width, 0);
    [scroll_view setContentSize:CGSizeMake(scroll_view.frame.size.width*2, scroll_view.frame.size.height)];
    scroll_view.pagingEnabled = YES;
    scroll_view.showsVerticalScrollIndicator = NO;
    scroll_view.showsHorizontalScrollIndicator = NO;
    down_view.frame = CGRectMake(0, frame.size.height*up_per, frame.size.width, frame.size.height*down_per);
    [self setContentSize:CGSizeMake(frame.size.width, frame.size.height*(up_per+down_per))];
    scroll_view_frame = scroll_view.frame;
    up_view1_frame = up_view1.frame;
    up_view2_frame = up_view2.frame;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scroll_view.frame = CGRectMake(scroll_view_frame.origin.x,
                                   scroll_view_frame.origin.y+scrollView.contentOffset.y,
                                   scroll_view_frame.size.width,
                                   scroll_view_frame.size.height-scrollView.contentOffset.y);
    up_view1.frame = CGRectMake(up_view1_frame.origin.x,
                                up_view1_frame.origin.y,
                                up_view1_frame.size.width,
                                up_view1_frame.size.height-scrollView.contentOffset.y);
    up_view2.frame = CGRectMake(up_view2_frame.origin.x,
                                up_view2_frame.origin.y,
                                up_view2_frame.size.width,
                                up_view2_frame.size.height-scrollView.contentOffset.y);
    [scroll_view setContentSize:CGSizeMake(scroll_view_frame.size.width*2,
                                           scroll_view_frame.size.height-scrollView.contentOffset.y)];
}

@end
