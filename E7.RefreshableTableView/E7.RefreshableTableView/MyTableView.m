#import "MyTableView.h"
#import "DTItem.h"

@implementation MyTableView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        refreshViewHeight = 40;
        CGRect rframe = CGRectMake(0, -refreshViewHeight, frame.size.width, refreshViewHeight);
        [self addRefreshView:rframe];
        self.dataSource = self;
        self.delegate = self;
        upside_state = READY;
        
        datetimeItems = [[NSMutableArray alloc]init];
        [self testDatabase];
        maxIdentity = [self maxIdentityInDatabase];
        numberOfVisiableRows = self.frame.size.height / refreshViewHeight + 1;
        int count = [self numberOfItemsInDatabase];
        int from = (count-numberOfVisiableRows<0) ? 0 : (count-numberOfVisiableRows);
        [datetimeItems addObjectsFromArray:[[[self readDataFrom:from to:count] reverseObjectEnumerator] allObjects]];

        _hack_flag  = NO;
        _hack_y     = 0.0;
    }
    return self;
}

- (void)testDatabase {
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documents stringByAppendingPathComponent:@"data.s3db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        sqlite3* db;
        if (sqlite3_open([path UTF8String], &db)==SQLITE_OK) {
            char* sql = "CREATE TABLE IF NOT EXISTS INFO (ID INTEGER, DATE_TIME TEXT)";
            if (sqlite3_exec(db, sql, 0, 0, 0)!=SQLITE_OK) {
                [[[UIAlertView alloc]initWithTitle: @"Error"
                                           message: @"Failed to create table."
                                          delegate: nil
                                 cancelButtonTitle: @"OK"
                                 otherButtonTitles: nil]show];
            }
        }
        else {
            [[[UIAlertView alloc]initWithTitle: @"Error"
                                       message: @"Failed to create database"
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil]show];
        }
        sqlite3_close(db);
    }
}

- (int)maxIdentityInDatabase {
    int result = maxIdentity;
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documents stringByAppendingPathComponent:@"data.s3db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        sqlite3* db;
        if (sqlite3_open([path UTF8String], &db)==SQLITE_OK) {
            sqlite3_stmt *statement;
            char* sql = "SELECT MAX(ID) FROM INFO";
            if (sqlite3_prepare_v2(db, sql, -1, &statement, 0)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    result = (int)sqlite3_column_int(statement, 0);
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(db);
    }
    return result;
}

- (int)numberOfItemsInDatabase {
    int result = maxIdentity;
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documents stringByAppendingPathComponent:@"data.s3db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        sqlite3* db;
        if (sqlite3_open([path UTF8String], &db)==SQLITE_OK) {
            sqlite3_stmt* statement;
            char* sql = "SELECT COUNT(*) FROM INFO";
            if (sqlite3_prepare_v2(db, sql, -1, &statement, 0)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    result = (int)sqlite3_column_int(statement, 0);
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(db);
    }
    return result;
}

- (NSArray*)readDataFrom:(NSInteger)from to:(NSInteger)to {
    NSMutableArray* items = [[NSMutableArray alloc]init];
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documents stringByAppendingPathComponent:@"data.s3db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        sqlite3* db;
        if (sqlite3_open([path UTF8String], &db)==SQLITE_OK) {
            sqlite3_stmt* statement;
            NSString* sql = [NSString stringWithFormat:@"SELECT * FROM INFO ORDER BY ID ASC LIMIT %ld OFFSET %ld", to-from, (long)from];
            if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    DTItem* item = [[DTItem alloc]initWithIdentity: (int)sqlite3_column_int(statement, 0)
                                                          dateTime: [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                    [items addObject:item];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(db);
    }
    return items;
}

- (void)addDatetimeToDatabase:(NSString*)datetime withIdentity:(int)identity {
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documents stringByAppendingPathComponent:@"data.s3db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        sqlite3* db;
        if (sqlite3_open([path UTF8String], &db)==SQLITE_OK) {
            NSString* sql = [NSString stringWithFormat:@"INSERT INTO INFO (ID, DATE_TIME) VALUES('%d', '%@')", identity, datetime];
            sqlite3_exec(db, [sql UTF8String], 0, 0, 0);
        }
        sqlite3_close(db);
    }
}

- (void)deleteDataWithIdentity:(int)identity {
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documents stringByAppendingPathComponent:@"data.s3db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        sqlite3* db;
        if (sqlite3_open([path UTF8String], &db)==SQLITE_OK) {
            NSString* sql = [NSString stringWithFormat:@"DELETE FROM INFO WHERE ID = '%d'", identity];
            sqlite3_exec(db, [sql UTF8String], 0, 0, 0);
        }
        sqlite3_close(db);
    }
}

- (void)addRefreshView:(CGRect)frame {
    refreshView = [[UIView alloc]initWithFrame:frame];
    refreshView.backgroundColor = [UIColor yellowColor];
    refreshLabel = [[UILabel alloc]initWithFrame:frame];
    refreshLabel.text = @"Pull down to refresh...";
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

    if (upside_state == LOADED) {
        refreshLabel.transform = refreshLabelOriginalTransform;
        refreshLabel.alpha = 1.0;
        upside_state = READY;
    }
    if (downside_state == LOADED) {
        downside_state = READY;
    }

    if (scrollView.contentOffset.y < -refreshViewHeight) {
        if (upside_state == READY) {
            refreshLabel.text = @"Release to refresh...";
        }
        CGRect frame = refreshView.frame;
        frame.origin = CGPointMake(frame.origin.x, scrollView.contentOffset.y);
        frame.size = CGSizeMake(frame.size.width, -scrollView.contentOffset.y);
        refreshView.frame = frame;
        refreshLabel.frame = frame;
    }else {
        if (upside_state == READY) {
            refreshLabel.text = @"Pull down to refresh...";
        }
        refreshView.frame = CGRectMake(0, -refreshViewHeight, refreshView.frame.size.width, refreshViewHeight);
        refreshLabel.frame = refreshView.frame;
    }

    if (upside_state == WILL_LOADING) {
        refreshLabel.text = @"Loading...";
        upside_state = IS_LOADING;
        [NSThread detachNewThreadSelector:@selector(updateInBackground) toTarget:self withObject:nil];
    }

    if (scrollView.contentSize.height < scrollView.frame.size.height || downside_state != READY) return;
    if (scrollView.contentOffset.y+scrollView.frame.size.height > scrollView.contentSize.height) {
        if (downside_state == READY) {
            downside_state = WILL_LOADING;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -refreshViewHeight && upside_state==READY) {
        _hack_flag = YES;
        _hack_y = scrollView.contentOffset.y;
        scrollView.contentInset = UIEdgeInsetsMake(refreshViewHeight, 0.0f, 0.0f, 0.0f);
        upside_state = WILL_LOADING;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (downside_state == WILL_LOADING) {
        downside_state = IS_LOADING;
        NSInteger idx = [self numberOfRowsInSection:0];
        int count = [self numberOfItemsInDatabase];
        long from = (count-idx-5<0) ? 0 : (count-idx-5);
        NSArray* objs = [self readDataFrom:from to:count-idx];
        objs = [[objs reverseObjectEnumerator] allObjects];
        NSRange range = NSMakeRange(idx, [objs count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [datetimeItems insertObjects:objs atIndexes:indexSet];
        NSMutableArray *ips = [[NSMutableArray alloc] init];
        for (int i = 0; i < objs.count; ++i) {
            [ips addObject:[NSIndexPath indexPathForRow:idx + i inSection:0]];
        }
        if (ips.count>0)
            [self insertRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationNone];
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint p = CGPointMake(self.contentOffset.x, self.contentOffset.y+refreshViewHeight*objs.count);
            self.contentOffset = p;
        }completion:^(BOOL finished) {
            downside_state = LOADED;
        }];
    }
}

- (void)updateInBackground {
    [NSThread sleepForTimeInterval:1];
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
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    maxIdentity++;
                    DTItem* item = [[DTItem alloc]initWithIdentity:maxIdentity dateTime:[df stringFromDate:[NSDate date]]];
                    [datetimeItems insertObject:item atIndex:0];
                    NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self addDatetimeToDatabase:item.dateTime withIdentity:item.identity];
                    [self insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationBottom];
                    upside_state = LOADED;
                }
            }];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datetimeItems.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"Recorded at %@", [[datetimeItems objectAtIndex:[indexPath row]]dateTime]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return refreshViewHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteDataWithIdentity:[(DTItem*)[datetimeItems objectAtIndex:[indexPath row]]identity]];
        [datetimeItems removeObjectAtIndex:[indexPath row]];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (datetimeItems.count < numberOfVisiableRows) {
            NSInteger idx = [self numberOfRowsInSection:0];
            int count = [self numberOfItemsInDatabase];
            long from = count-idx-1<0?0:count-idx-1;
            NSArray* objs = [self readDataFrom:from to:count-idx];
            if (objs.count) {
                [datetimeItems insertObject:[objs objectAtIndex:0] atIndex:idx];
                NSIndexPath* ip = [NSIndexPath indexPathForRow:idx inSection:0];
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
    return @"Pass";
}

@end
