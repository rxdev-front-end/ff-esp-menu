#import <UIKit/UIKit.h>
#include "esp.hpp"

@interface ESPView : UIView
@end

@implementation ESPView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO; // Deixa os dedos passarem pro jogo
        
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)update {
    ESP::tick(self.bounds.size.width, self.bounds.size.height);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!ESP::enabled || ESP::screenPositions.empty()) return;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Cor vermelha pra inimigo
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);

    for (const auto& pos : ESP::screenPositions) {
        // Desenha a caixa em volta do osso da cabeça
        CGRect box = CGRectMake(pos.x - 25, pos.y - 40, 50, 80);
        CGContextStrokeRect(ctx, box);
        
        // Desenha a linha de mira (Skeleton simples)
        CGContextMoveToPoint(ctx, pos.x, pos.y - 40);
        CGContextAddLineToPoint(ctx, pos.x, pos.y + 40);
        CGContextStrokePath(ctx);
    }
}
@end
