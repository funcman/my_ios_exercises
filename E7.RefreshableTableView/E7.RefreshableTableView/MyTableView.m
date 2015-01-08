#import "MyTableView.h"

@implementation MyTableView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        refreshViewHeight = 40;
        CGRect rframe = CGRectMake(0, -refreshViewHeight, frame.size.width, refreshViewHeight);
        [self addRefreshView:rframe];
        self.dataSource = self;
        self.delegate = self;
        state = IS_READY;
        
        data = [[NSMutableArray alloc]init];

        _hack_flag  = NO;
        _hack_y     = 0.0;
    }
    return self;
}

- (void)addRefreshView:(CGRect)frame {
    refreshView = [[UIView alloc]initWithFrame:frame];
    refreshView.backgroundColor = [UIColor yellowColor];
    refreshLabel = [[UILabel alloc]initWithFrame:frame];
    refreshLabel.text = @"下拉刷新数据";
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabelOriginalTransform = refreshLabel.transform;
    [self addSubview:refreshView];
    [self addSubview:refreshLabel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_hack_flag) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, _hack_y);
        _hack_flag = NO;
    }
    if (state == LOADED) {
        refreshLabel.transform = refreshLabelOriginalTransform;
        refreshLabel.alpha = 1.0;
        state = IS_READY;
    }

    if (scrollView.contentOffset.y < -refreshViewHeight) {
        if (state == IS_READY) {
            refreshLabel.text = @"释放刷新数据";
        }
        CGRect frame = refreshView.frame;
        frame.origin = CGPointMake(frame.origin.x, scrollView.contentOffset.y);
        frame.size = CGSizeMake(frame.size.width, -scrollView.contentOffset.y);
        refreshView.frame = frame;
        refreshLabel.frame = frame;
    }else {
        if (state == IS_READY) {
            refreshLabel.text = @"下拉刷新数据";
        }
        refreshView.frame = CGRectMake(0, -refreshViewHeight, refreshView.frame.size.width, refreshViewHeight);
        refreshLabel.frame = refreshView.frame;
    }

    if (state == WILL_LOADING) {
        refreshLabel.text = @"正在更新...";
        state = IS_LOADING;
        [NSThread detachNewThreadSelector:@selector(updateInBackground) toTarget:self withObject:nil];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -refreshViewHeight && state==IS_READY) {
        _hack_flag = YES;
        _hack_y = scrollView.contentOffset.y;
        scrollView.contentInset = UIEdgeInsetsMake(refreshViewHeight, 0.0f, 0.0f, 0.0f);
        state = WILL_LOADING;
    }
}

- (void)updateInBackground {
    [NSThread sleepForTimeInterval:3];
    [self performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:YES];
}

- (void)loadData {
    [UIView animateWithDuration:0.3 animations:^{
        refreshLabel.transform = CGAffineTransformScale(refreshLabelOriginalTransform, 0.5, 0.5);
        refreshLabel.alpha = 0.0;
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.contentInset = UIEdgeInsetsZero;
            }completion:^(BOOL finished) {
                if (finished) {
                    NSDateFormatter *df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"记录时刻：yyyy-MM-dd HH:mm:ss"];
                    [data insertObject:[df stringFromDate:[NSDate date]] atIndex:0];
                    NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
                    state = LOADED;
                }
            }];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.textLabel setText:[data objectAtIndex:[indexPath row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [data removeObjectAtIndex:[indexPath row]];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
    return @"Pass";
}

@end
