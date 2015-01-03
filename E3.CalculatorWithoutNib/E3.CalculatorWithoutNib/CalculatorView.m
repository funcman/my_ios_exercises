#import "CalculatorView.h"

@implementation CalculatorView

enum OPERATOR {
    ADD,
    SUB,
    MUL,
    DIV,
    CLS,
};

enum OPERATOR last_op = CLS;

int result_num = 0;
int last_num = 0;
bool is_inputting = false;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if( self ) {
        NSArray *constraints;
        // [                    0]
        resultLabel = [[UILabel alloc]init];
        resultLabel.text = @"0";
        resultLabel.backgroundColor = [UIColor whiteColor];
        resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
        resultLabel.font = [UIFont systemFontOfSize:32];
        resultLabel.textColor = [UIColor blackColor];
        [resultLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:resultLabel];
        
        // [ 7 ] [ 8 ] [ 9 ]
        // [ 4 ] [ 5 ] [ 6 ]
        // [ 1 ] [ 2 ] [ 3 ]
        //       [ 0 ]
        for (int i=0; i<3; ++i) {
            for (int j=1; j<=3; ++j) {
                numberButtons[i*3+j] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                numberButtons[i*3+j].backgroundColor = [UIColor whiteColor];
                numberButtons[i*3+j].translatesAutoresizingMaskIntoConstraints = NO;
                numberButtons[i*3+j].titleLabel.font = [UIFont systemFontOfSize:32];
                [numberButtons[i*3+j] setTitle:[NSString stringWithFormat:@"%d",i*3+j] forState:UIControlStateNormal];
                [numberButtons[i*3+j] addTarget:self action:@selector(onNumClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:numberButtons[i*3+j]];
            }
        }
        numberButtons[0] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        numberButtons[0].backgroundColor = [UIColor whiteColor];
        numberButtons[0].translatesAutoresizingMaskIntoConstraints = NO;
        numberButtons[0].titleLabel.font = [UIFont systemFontOfSize:32];
        [numberButtons[0] setTitle:@"0" forState:UIControlStateNormal];
        [numberButtons[0] addTarget:self action:@selector(onNumClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:numberButtons[0]];
        
        //                   [ / ]
        //                   [ * ]
        //                   [ - ]
        // [ C ]             [ + ]
        for (int i=0; i<4; ++i) {
            operatorButtons[i] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            operatorButtons[i].backgroundColor = [UIColor whiteColor];
            operatorButtons[i].translatesAutoresizingMaskIntoConstraints = NO;
            operatorButtons[i].titleLabel.font = [UIFont systemFontOfSize:32];
            [operatorButtons[i] addTarget:self action:@selector(onOpClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:operatorButtons[i]];
        }
        operatorButtons[4] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        operatorButtons[4].backgroundColor = [UIColor whiteColor];
        operatorButtons[4].translatesAutoresizingMaskIntoConstraints = NO;
        operatorButtons[4].titleLabel.font = [UIFont systemFontOfSize:32];
        [operatorButtons[4] addTarget:self action:@selector(onOpClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:operatorButtons[4]];
        [operatorButtons[0] setTitle:@"+" forState:UIControlStateNormal];
        [operatorButtons[1] setTitle:@"-" forState:UIControlStateNormal];
        [operatorButtons[2] setTitle:@"*" forState:UIControlStateNormal];
        [operatorButtons[3] setTitle:@"/" forState:UIControlStateNormal];
        [operatorButtons[4] setTitle:@"C" forState:UIControlStateNormal];
        
        //             [ = ]
        resultButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        resultButton.backgroundColor = [UIColor whiteColor];
        resultButton.translatesAutoresizingMaskIntoConstraints = NO;
        resultButton.titleLabel.font = [UIFont systemFontOfSize:32];
        [resultButton setTitle:@"=" forState:UIControlStateNormal];
        [resultButton addTarget:self action:@selector(onResultClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resultButton];

        // What fucking constraints! @.@
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[resultLabel]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: NSDictionaryOfVariableBindings(resultLabel)];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[n7]-[n8(n7)]-[n9(n8)]-[div(n9)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[7],   @"n7",
                                                                        numberButtons[8],   @"n8",
                                                                        numberButtons[9],   @"n9",
                                                                        operatorButtons[3], @"div", nil]];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[n4(n7)]-[n5(n4)]-[n6(n5)]-[mul(n6)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[4],   @"n4",
                                                                        numberButtons[5],   @"n5",
                                                                        numberButtons[6],   @"n6",
                                                                        numberButtons[7],   @"n7",
                                                                        operatorButtons[2], @"mul", nil]];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[n1(n7)]-[n2(n1)]-[n3(n2)]-[sub(n3)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[1],   @"n1",
                                                                        numberButtons[2],   @"n2",
                                                                        numberButtons[3],   @"n3",
                                                                        numberButtons[7],   @"n7",
                                                                        operatorButtons[1], @"sub", nil]];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[C(n7)]-[n0(C)]-[R(n0)]-[add(R)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[0],   @"n0",
                                                                        numberButtons[7],   @"n7",
                                                                        operatorButtons[0], @"add",
                                                                        operatorButtons[4], @"C",
                                                                        resultButton,       @"R", nil]];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-30-[resultLabel(==40)]-16-[n7]-[n4(n7)]-[n1(n7)]-[C(n7)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[1],   @"n1",
                                                                        numberButtons[4],   @"n4",
                                                                        numberButtons[7],   @"n7",
                                                                        operatorButtons[4], @"C",
                                                                        resultLabel,        @"resultLabel", nil]];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-30-[resultLabel]-16-[n8(n7)]-[n5(n8)]-[n2(n8)]-[n0(n8)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[0],   @"n0",
                                                                        numberButtons[2],   @"n2",
                                                                        numberButtons[5],   @"n5",
                                                                        numberButtons[7],   @"n7",
                                                                        numberButtons[8],   @"n8",
                                                                        resultLabel,        @"resultLabel", nil]];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-30-[resultLabel]-16-[n9(n7)]-[n6(n9)]-[n3(n9)]-[R(n9)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[3],   @"n3",
                                                                        numberButtons[6],   @"n6",
                                                                        numberButtons[7],   @"n7",
                                                                        numberButtons[9],   @"n9",
                                                                        resultButton,       @"R",
                                                                        resultLabel,        @"resultLabel", nil]];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-30-[resultLabel]-16-[div(n7)]-[mul(div)]-[sub(div)]-[add(div)]-10-|"
                                                              options: 0
                                                              metrics: nil
                                                                views: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        numberButtons[7],   @"n7",
                                                                        operatorButtons[0], @"add",
                                                                        operatorButtons[1], @"sub",
                                                                        operatorButtons[2], @"mul",
                                                                        operatorButtons[3], @"div",
                                                                        resultLabel,   @"resultLabel", nil]];
        [self addConstraints:constraints];
    }
    return self;
}

- (void)clac:(int)num {
    switch (last_op) {
        case ADD:
            result_num += num;
            break;
        case SUB:
            result_num -= num;
            break;
        case MUL:
            result_num *= num;
            break;
        case DIV:
            result_num /= num;
            break;
        default:
            result_num = num;
            break;
    }
    [resultLabel setText:[NSString stringWithFormat:@"%d", result_num]];
}

- (enum OPERATOR)getOpValue:(NSString*)op {
    if ([op isEqual:@"+"]) {
        return ADD;
    }else if ([op isEqual:@"-"]) {
        return SUB;
    }else if ([op isEqual:@"*"]) {
        return MUL;
    }else if ([op isEqual:@"/"]) {
        return DIV;
    }else {
        return CLS;
    }
}

- (void)onNumClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    int num = [btn.titleLabel.text intValue];
    if (is_inputting) {
        num = [resultLabel.text intValue]*10 + num;
    }else {
        is_inputting = true;
    }
    [resultLabel setText:[NSString stringWithFormat:@"%d", num]];}

- (void)onOpClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    enum OPERATOR op = [self getOpValue:btn.titleLabel.text];
    if (op==CLS) {
        last_op = CLS;
        result_num = 0;
        last_num = 0;
        is_inputting = false;
        [resultLabel setText:@"0"];
    }
    if(!is_inputting) {
        last_op = op;
        return;
    }
    last_num = [resultLabel.text intValue];
    [self clac:last_num];
    switch (op) {
        case ADD:
            last_op = ADD;
            break;
        case SUB:
            last_op = SUB;
            break;
        case MUL:
            last_op = MUL;
            break;
        case DIV:
            last_op = DIV;
            break;
        default:
            break;
    }
    
    is_inputting = false;
}

- (void)onResultClicked:(id)sender {
    if(is_inputting) {
        is_inputting = false;
        last_num = [resultLabel.text intValue];
    }
    [self clac:last_num];}

@end
