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
        // [                    0]
        resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 118, 28)];
        resultLabel.text = @"0";
        resultLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:resultLabel];
        
        // [ 7 ] [ 8 ] [ 9 ]
        // [ 4 ] [ 5 ] [ 6 ]
        // [ 1 ] [ 2 ] [ 3 ]
        //       [ 0 ]
        for (int i=0; i<3; ++i) {
            for (int j=1; j<=3; ++j) {
                numberButtons[i*3+j] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                numberButtons[i*3+j].backgroundColor = [UIColor whiteColor];
                numberButtons[i*3+j].frame = CGRectMake(j*30, 140-i*30, 28, 28);
                [numberButtons[i*3+j] setTitle:[NSString stringWithFormat:@"%d",i*3+j] forState:UIControlStateNormal];
                [numberButtons[i*3+j] addTarget:self action:@selector(onNumClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:numberButtons[i*3+j]];
            }
        }
        numberButtons[0] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        numberButtons[0].backgroundColor = [UIColor whiteColor];
        numberButtons[0].frame = CGRectMake(60, 170, 28, 28);
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
            operatorButtons[i].frame = CGRectMake(120, 170-i*30, 28, 28);
            [operatorButtons[i] addTarget:self action:@selector(onOpClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:operatorButtons[i]];
        }
        operatorButtons[4] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        operatorButtons[4].backgroundColor = [UIColor whiteColor];
        operatorButtons[4].frame = CGRectMake(30, 170, 28, 28);
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
        resultButton.frame = CGRectMake(90, 170, 28, 28);
        [resultButton setTitle:@"=" forState:UIControlStateNormal];
        [resultButton addTarget:self action:@selector(onResultClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resultButton];
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
