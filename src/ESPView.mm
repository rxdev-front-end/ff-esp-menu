#import <UIKit/UIKit.h>
#include "esp.hpp"

@interface ESPView : UIView
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ESPView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO; // Deixa os toques passarem pro jogo
        
        // Roda o tick do ESP 60 vezes por segundo
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)update {
    ESP::tick();
    [self setNeedsDisplay]; // Manda a view se redesenhar
}

- (void)drawRect:(CGRect)rect {
    if (!ESP::enabled) return;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    // Exemplo de caixa fixa no meio da tela
    CGContextStrokeRect(context, CGRectMake(100, 100, 100, 150));
}

@end
