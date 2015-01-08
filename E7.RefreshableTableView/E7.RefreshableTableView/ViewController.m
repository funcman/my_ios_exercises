#import "ViewController.h"
#import "MyTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen]bounds];
    UIView* view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    mtv = [[MyTableView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+20, frame.size.width, frame.size.height-20)];
    [view addSubview:mtv];
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
