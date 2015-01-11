#import "MyTableView.h"
#import <sqlite3.h>
#import "DTItem.h"

@implementation MyTableView

@synthesize state;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        cellCustomHeight = 40;
        CGRect rframe = CGRectMake(0, -cellCustomHeight, frame.size.width, cellCustomHeight);
        [self addRefreshView:rframe];
        self.dataSource = self;
        self.delegate = self;
        upsideState = READY;

        datetimeItems = [[NSMutableArray alloc]init];
        [self testDatabase];
        maxIdentity = [self maxIdentityInDatabase];
        numberOfVisiableRows = self.frame.size.height / cellCustomHeight + 1;
        int count = [self numberOfItemsInDatabase];
        int from = (count-numberOfVisiableRows<0) ? 0 : (count-numberOfVisiableRows);
        [datetimeItems addObjectsFromArray:[[[self readDataFrom:from to:count] reverseObjectEnumerator] allObjects]];

        _hack_flag  = NO;
        _hack_y     = 0.0;
    }
    return self;
}

- (void)addRefreshView:(CGRect)frame {
    refreshLabel = [[UILabel alloc]initWithFrame:frame];
    refreshLabel.text = @"Pull down to refresh...";
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabelOriginalTransform = refreshLabel.transform;
    [self addSubview:refreshLabel];
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
    int result = 0;
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

- (int)minIdentityInDatabase {
    int result = 0;
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documents stringByAppendingPathComponent:@"data.s3db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        sqlite3* db;
        if (sqlite3_open([path UTF8String], &db)==SQLITE_OK) {
            sqlite3_stmt *statement;
            char* sql = "SELECT MIN(ID) FROM INFO";
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
    int result = 0;
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
            NSString* sql = [NSString stringWithFormat:@"SELECT * FROM INFO ORDER BY ID ASC LIMIT %d OFFSET %ld", to-from, (long)from];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_hack_flag) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, _hack_y);
        _hack_flag = NO;
    }

    if (state == UP) {
        if (scrollView.contentOffset.y < 0.0) {
            CGPoint p = CGPointMake(scrollView.contentOffset.x, 0);
            scrollView.contentOffset = p;
        }
    }
    if (state == DW) {
        if (scrollView.contentOffset.y > 0.0) {
            CGPoint p = CGPointMake(scrollView.contentOffset.x, 0);
            scrollView.contentOffset = p;
        }
    }

    if (upsideState == LOADED) {
        refreshLabel.transform = refreshLabelOriginalTransform;
        refreshLabel.alpha = 1.0;
        upsideState = READY;
    }
    if (downsideState == LOADED) {
        downsideState = READY;
    }

    if (scrollView.contentOffset.y < -cellCustomHeight) {
        if (upsideState == READY) {
            refreshLabel.text = @"Release to refresh...";
        }
        CGRect frame = refreshLabel.frame;
        frame.origin = CGPointMake(frame.origin.x, scrollView.contentOffset.y);
        frame.size = CGSizeMake(frame.size.width, -scrollView.contentOffset.y);
        refreshLabel.frame = frame;
    }else {
        if (upsideState == READY) {
            refreshLabel.text = @"Pull down to refresh...";
        }
        refreshLabel.frame = CGRectMake(0, -cellCustomHeight, refreshLabel.frame.size.width, cellCustomHeight);
    }

    if (upsideState == WILL_LOADING) {
        refreshLabel.text = @"Loading...";
        upsideState = IS_LOADING;
        [NSThread detachNewThreadSelector:@selector(updateInBackground) toTarget:self withObject:nil];
    }

    if (scrollView.contentSize.height < scrollView.frame.size.height || downsideState != READY) return;
    if (scrollView.contentOffset.y+scrollView.frame.size.height > scrollView.contentSize.height) {
        if (downsideState == READY) {
            downsideState = WILL_LOADING;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -cellCustomHeight && upsideState==READY) {
        _hack_flag = YES;
        _hack_y = scrollView.contentOffset.y;
        scrollView.contentInset = UIEdgeInsetsMake(cellCustomHeight, 0.0f, 0.0f, 0.0f);
        upsideState = WILL_LOADING;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (downsideState == WILL_LOADING) {
        downsideState = IS_LOADING;
        if (datetimeItems.count >= numberOfVisiableRows) {
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
            CGPoint p = CGPointMake(self.contentOffset.x, self.contentOffset.y+cellCustomHeight*objs.count);
            self.contentOffset = p;
            if (ips.count > 0) {
                [self insertRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        downsideState = LOADED;
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
        [UIView animateWithDuration:0.1 animations:^{
            self.contentInset = UIEdgeInsetsZero;
        }completion:^(BOOL finished) {
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            maxIdentity++;
            DTItem* item = [[DTItem alloc]initWithIdentity:maxIdentity dateTime:[df stringFromDate:[NSDate date]]];
            [datetimeItems insertObject:item atIndex:0];
            [self addDatetimeToDatabase:item.dateTime withIdentity:item.identity];

            [self beginUpdates];

            NSIndexPath* ip;

            if (datetimeItems.count<=numberOfVisiableRows) {
                ip = [NSIndexPath indexPathForRow:numberOfVisiableRows-1 inSection:0];
                [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationNone];
            }

            if (datetimeItems.count > numberOfVisiableRows*3) {
                [self deleteDataWithIdentity:[(DTItem*)[datetimeItems objectAtIndex:numberOfVisiableRows*3]identity]];
                [datetimeItems removeObjectAtIndex:numberOfVisiableRows*3];
                ip = [NSIndexPath indexPathForRow:numberOfVisiableRows*3-1 inSection:0];
                [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationNone];
            }
            while ([self numberOfItemsInDatabase] > numberOfVisiableRows*3) {
                [self deleteDataWithIdentity:[self minIdentityInDatabase]];
            }

            ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationBottom];

            [self endUpdates];

            upsideState = LOADED;
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datetimeItems.count>=numberOfVisiableRows ? datetimeItems.count : numberOfVisiableRows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (datetimeItems.count < numberOfVisiableRows && [indexPath row] >= datetimeItems.count) {
        [cell.textLabel setText:@""];
    }else {
        [cell.textLabel setText:[NSString stringWithFormat:@"Recorded at %@", [[datetimeItems objectAtIndex:[indexPath row]]dateTime]]];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellCustomHeight;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) return YES;
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    if (velocity.y >= 0 && state == UP && self.contentOffset.y <=0 ) {
        return NO;
    }else if(velocity.y <= 0 && state == DW){
        return NO;
    }
    return YES;
}

@end
