#import "ViewController.h"
#import "MyTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen]bounds];
    tableViewHeight = frame.size.height * 0.7;
    tableViewOriginY = frame.size.height * 0.6;

    UIView* view = [[UIView alloc]initWithFrame:frame];
    [self setView:view];

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
            tempOriginY = panView.frame.origin.y;
        }break;
        case UIGestureRecognizerStateChanged: {
            if (tempOriginY+translation.y >= frame.size.height-tableViewHeight && tempOriginY+translation.y <= tableViewOriginY) {
                CGRect f = panView.frame;
                f.origin = CGPointMake(0, tempOriginY + translation.y);
                panView.frame = f;
            }
        }break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint p = panView.frame.origin;
            CGSize s;
            if (velocity.y >= 0) {
                p.y = tableViewOriginY;
                s = CGSizeMake(panView.frame.size.width, frame.size.height-tableViewOriginY);
            }else {
                p.y = frame.size.height-tableViewHeight;
                s = CGSizeMake(panView.frame.size.width, tableViewHeight);
            }
            [UIView animateWithDuration:0.2 animations:^{
                CGRect f = panView.frame;
                f.origin = p;
                f.size = s;
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
