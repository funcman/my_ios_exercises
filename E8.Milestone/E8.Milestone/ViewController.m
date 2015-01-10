#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    UIView* view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    view.backgroundColor = [UIColor yellowColor];
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
