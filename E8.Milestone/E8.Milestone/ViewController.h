#import <UIKit/UIKit.h>

@class MyTableView;

@interface ViewController : UIViewController {
    UIView*         panView;
    MyTableView*    tableView;
    float           tableViewOriginY;
    float           tableViewHeight;
    float           tempOriginY;
    UIPanGestureRecognizer* panGesture;
}

@end
