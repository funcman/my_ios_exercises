#import <UIKit/UIKit.h>
#import <sqlite3.h>

typedef enum RefreshViewState {
    READY,
    WILL_LOADING,
    IS_LOADING,
    LOADED,
} RefreshViewState;

@interface MyTableView : UITableView<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIView*             refreshView;
    float               refreshViewHeight;
    UILabel*            refreshLabel;
    CGAffineTransform   refreshLabelOriginalTransform;
    RefreshViewState    upside_state;
    RefreshViewState    downside_state;
    
    int                 numberOfVisiableRows;

    NSMutableArray*     datetimeItems;
    int                 maxIdentity;

    BOOL    _hack_flag;
    float   _hack_y;
}

@end
