#import <UIKit/UIKit.h>

@class MyScrollView;
@class MyTableView;

@interface ViewController : UIViewController {
    MyScrollView*   scrollView;
    UIView*         panView;
    MyTableView*    tableView;
    float           tableViewOriginY;
    float           tableViewHeight;
    float           tempOriginY;
    float           tempOriginHeight;
    UIPanGestureRecognizer* panGesture;
}

@end
