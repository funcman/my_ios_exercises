#import <UIKit/UIKit.h>

typedef enum MyTableViewState {
    UP,
    DW,
} MyTableViewState;

typedef enum RefreshViewState {
    READY,
    WILL_LOADING,
    IS_LOADING,
    LOADED,
} RefreshViewState;

@interface MyTableView : UITableView<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    MyTableViewState    state;
    RefreshViewState    upsideState;
    RefreshViewState    downsideState;

    UILabel*            refreshLabel;
    CGAffineTransform   refreshLabelOriginalTransform;

    float               cellCustomHeight;
    int                 numberOfVisiableRows;

    NSMutableArray*     datetimeItems;
    int                 maxIdentity;

    BOOL                _hack_flag;
    float               _hack_y;
}

@property MyTableViewState state;

@end
