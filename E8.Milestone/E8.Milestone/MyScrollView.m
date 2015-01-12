#import "MyScrollView.h"

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        originalSize = frame.size;
        [self setContentSize:CGSizeMake(originalSize.width*2, originalSize.height)];
        self.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0];
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;

        images[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ring"]];
        images[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ring"]];
        images[0].contentMode = UIViewContentModeScaleToFill;
        CGSize s = CGSizeMake(frame.size.height-10, frame.size.height-10);
        images[0].frame = CGRectMake((frame.size.width-s.width)/2, 0, s.width, s.height);
        images[1].frame = CGRectMake((frame.size.width-s.width)/2+frame.size.width, 0, s.width, s.height);
        [self addSubview:images[0]];
        [self addSubview:images[1]];
        
        labels[0] = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-s.width)/2, 0, s.width, s.height)];
        labels[1] = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-s.width)/2+frame.size.width, 0, s.width, s.height)];
        labels[0].text = @"00:00";
        labels[1].text = @"0000 Steps";
        labels[0].font = [UIFont systemFontOfSize:32];
        labels[0].textColor = [UIColor whiteColor];
        labels[1].font = [UIFont systemFontOfSize:32];
        labels[1].textColor = [UIColor whiteColor];
        labels[0].textAlignment = NSTextAlignmentCenter;
        labels[1].textAlignment = NSTextAlignmentCenter;
        [self addSubview:labels[0]];
        [self addSubview:labels[1]];
    }
    return self;
}

- (void)addPageControlToView:(UIView *)view withY:(float)y {
    self.delegate = self;
    CGSize sizePageControl = CGSizeMake(120, 16);
    CGRect framePageControl = CGRectMake((self.frame.size.width-sizePageControl.width)/2, (y-sizePageControl.height), sizePageControl.width, sizePageControl.height);
    pageControl = [[UIPageControl alloc]initWithFrame:framePageControl];
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = 2;
    [view addSubview:pageControl];
}

- (void)updateSubSize {
    [self setContentSize:CGSizeMake(self.frame.size.width*2, self.frame.size.height)];
    images[0].frame = CGRectMake(images[0].frame.origin.x, images[0].frame.origin.y, images[0].frame.size.width, self.frame.size.height-10);
    images[1].frame = CGRectMake(images[1].frame.origin.x, images[1].frame.origin.y, images[1].frame.size.width, self.frame.size.height-10);
    labels[0].frame = CGRectMake(labels[0].frame.origin.x, labels[0].frame.origin.y, labels[0].frame.size.width, self.frame.size.height-10);
    labels[1].frame = CGRectMake(labels[1].frame.origin.x, labels[1].frame.origin.y, labels[1].frame.size.width, self.frame.size.height-10);
    float dy = originalSize.height - self.frame.size.height;
    float alpha =  1.0 - (dy/(originalSize.height/2)>1.0? 1.0 : dy/(originalSize.height/2));
    images[0].alpha = alpha;
    images[1].alpha = alpha;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    int index = fabs(scrollView.contentOffset.x)/self.frame.size.width;
    pageControl.currentPage = index;
}

@end
