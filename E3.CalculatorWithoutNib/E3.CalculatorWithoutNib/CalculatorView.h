#import <UIKit/UIKit.h>

@interface CalculatorView : UIView {
    UILabel     *resultLabel;
    UIButton    *numberButtons[10];
    UIButton    *operatorButtons[5];
    UIButton    *resultButton;
}

//@property (nonatomic, retain) UILabel   *resultLabel;
//@property (nonatomic, retain) UIButton  *numberButtons[0];


- (id)initWithFrame:(CGRect)frame;

@end
