#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UIPageControl *pc;

- (void)loadView {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect rect = screen;
    rect.size.width *= 2;

    UIView *v = [[UIView alloc]initWithFrame:screen];
    v.backgroundColor = [UIColor blueColor];
    [self setView:v];

    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:screen];
    [v addSubview:sv];
    [sv setContentSize:rect.size];

    // add two pages: red and green
    UIView *v1 = [[UIView alloc]initWithFrame:screen];
    v1.backgroundColor = [UIColor redColor];
    [sv addSubview:v1];
    screen.origin.x += screen.size.width;
    UIView *v2 = [[UIView alloc]initWithFrame:screen];
    v2.backgroundColor = [UIColor greenColor];
    [sv addSubview:v2];
    sv.pagingEnabled = YES;
    sv.showsVerticalScrollIndicator = NO;
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;

    // add the page control
    CGSize sizePageControl = CGSizeMake(120, 40);
    CGRect framePageControl = CGRectMake((screen.size.width-sizePageControl.width)/2, (screen.size.height-sizePageControl.height-10), sizePageControl.width, sizePageControl.height);
    pc = [[UIPageControl alloc]initWithFrame:framePageControl];
    pc.hidesForSinglePage = YES;
    pc.userInteractionEnabled = NO;
    pc.backgroundColor = [UIColor clearColor];
    pc.numberOfPages = 2;
    [v addSubview:pc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    int index = fabs(scrollView.contentOffset.x)/self.view.frame.size.width;
    pc.currentPage = index;
}

@end
