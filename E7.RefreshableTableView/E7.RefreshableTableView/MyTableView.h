#import <UIKit/UIKit.h>

typedef enum RefreshViewState {
    IS_READY,
    WILL_LOADING,
    IS_LOADING,
    LOADED,
} RefreshViewState;

@interface MyTableView : UITableView<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIView*             refreshView;
    float               refreshViewHeight;
    UILabel*            refreshLabel;
    CGAffineTransform   refreshLabelOriginalTransform;
    RefreshViewState    state;
    
    NSMutableArray*     data;
    
    BOOL    _hack_flag;
    float   _hack_y;
}

@end
