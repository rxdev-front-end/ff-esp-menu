#import <UIKit/UIKit.h>
#include "esp.hpp"

@interface MenuView : UIView
@end

@implementation MenuView {
    CGPoint _lastLocation;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor greenColor].CGColor;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 180, 20)];
        title.text = @"FF Menu - ollie";
        title.textColor = [UIColor greenColor];
        title.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:title];

        UILabel *espLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 120, 30)];
        espLabel.text = @"Enemy ESP";
        espLabel.textColor = [UIColor whiteColor];
        [self addSubview:espLabel];

        UISwitch *espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(140, 45, 51, 31)];
        espSwitch.onTintColor = [UIColor greenColor];
        [espSwitch addTarget:self action:@selector(toggleESP:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:espSwitch];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)toggleESP:(UISwitch *)sender {
    ESP::enabled = sender.isOn;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.superview];
}
@end
