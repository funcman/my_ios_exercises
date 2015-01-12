#import "ViewController.h"
#import "MyScrollView.h"
#import "MyTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen]bounds];
    tableViewHeight = frame.size.height * 0.7;
    tableViewOriginY = frame.size.height * 0.6;

    UIView* view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self setView:view];

    scrollView = [[MyScrollView alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, tableViewOriginY-20)];
    [view addSubview:scrollView];

    panView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, tableViewOriginY, frame.size.width, frame.size.height-tableViewOriginY)];
    tableView = [[MyTableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, tableViewHeight)];
    [panView addSubview:tableView];
    [view addSubview:panView];

    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [panView addGestureRecognizer:panGesture];

    [tableView setState:DW];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPan:(UIPanGestureRecognizer*)gr {
    CGRect frame = [[UIScreen mainScreen]bounds];
    CGPoint translation = [gr translationInView:panView];
    CGPoint velocity = [gr velocityInView:panView];

    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            tempOriginHeight = scrollView.frame.size.height;
            tempOriginY = panView.frame.origin.y;
        }break;
        case UIGestureRecognizerStateChanged: {
            if (tempOriginY+translation.y >= frame.size.height-tableViewHeight && tempOriginY+translation.y <= tableViewOriginY) {
                CGRect f = scrollView.frame;
                f.size = CGSizeMake(f.size.width, tempOriginHeight + translation.y);
                scrollView.frame = f;
                [scrollView updateSubSize];
                f = panView.frame;
                f.origin = CGPointMake(0, tempOriginY + translation.y);
                panView.frame = f;
            }
        }break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGSize ss = scrollView.frame.size;
            CGPoint po = panView.frame.origin;
            CGSize ps;
            if (velocity.y >= 0) {
                ss.height = tableViewOriginY-20;
                po.y = tableViewOriginY;
                ps = CGSizeMake(panView.frame.size.width, frame.size.height-tableViewOriginY);
            }else {
                ss.height = frame.size.height-tableViewHeight-20;
                po.y = frame.size.height-tableViewHeight;
                ps = CGSizeMake(panView.frame.size.width, tableViewHeight);
            }
            [UIView animateWithDuration:0.2 animations:^{
                CGRect f = scrollView.frame;
                f.size = ss;
                scrollView.frame = f;
                [scrollView updateSubSize];
                f = panView.frame;
                f.origin = po;
                f.size = ps;
                panView.frame = f;
            }completion:^(BOOL finished){
                if (panView.frame.origin.y == tableViewOriginY) {
                    [tableView setState:DW];
                }else {
                    [tableView setState:UP];
                }
            }];
        }break;
        default: break;
    }
}

@end
