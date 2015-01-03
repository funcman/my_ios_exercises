#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize resultLabel;

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.resultLabel setText:[NSString stringWithFormat:@"%d", result_num]];
}

- (IBAction)onNumClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    int num = [btn.titleLabel.text intValue];
    if (is_inputting) {
        num = [self.resultLabel.text intValue]*10 + num;
    }else {
        is_inputting = true;
    }
    [self.resultLabel setText:[NSString stringWithFormat:@"%d", num]];
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

- (IBAction)onOpClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    enum OPERATOR op = [self getOpValue:btn.titleLabel.text];
    if (op==CLS) {
        last_op = CLS;
        result_num = 0;
        last_num = 0;
        is_inputting = false;
        [self.resultLabel setText:@"0"];
    }
    if(!is_inputting) {
        last_op = op;
        return;
    }
    last_num = [self.resultLabel.text intValue];
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

- (IBAction)onResultClicked:(id)sender {
    if(is_inputting) {
        is_inputting = false;
        last_num = [self.resultLabel.text intValue];
    }
    [self clac:last_num];
}

@end
