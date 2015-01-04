#import "ViewController.h"
#import "MyScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    MyScrollView *view = [[MyScrollView alloc] initWithFrame:frame];
    UIView *uv1 = [[UIView alloc]init];
    uv1.backgroundColor = [UIColor redColor];
    UIView *uv2 = [[UIView alloc]init];
    uv2.backgroundColor = [UIColor greenColor];
    [view setSubviewOnUpside:uv1 and:uv2];
    UIView *dv = [[UIView alloc]init];
    dv.backgroundColor = [UIColor blueColor];
    [view setSubviewOnDownsize:dv];
    [view updateContentSizeWithUpsideSegmentation:0.6 downsideSegmentation:0.6];
    [self setView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
