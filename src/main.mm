#import <UIKit/UIKit.h>
#include "esp.hpp" // <- AQUI ESTAVA O ERRO

@interface MenuView : UIView
@end
@interface ESPView : UIView
@end

__attribute__((constructor))
static void on_load() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    keyWindow = scene.windows.firstObject;
                    break;
                }
            }
        }
        // Ignora o aviso do keyWindow deprecated, ele funciona de boa
        if (!keyWindow) keyWindow = [UIApplication sharedApplication].keyWindow;

        if (keyWindow) {
            UIViewController *rootVC = keyWindow.rootViewController;
            if (!rootVC) return;

            // Inicializa a base do Unity
            ESP::init();

            // Adiciona o Desenho
            ESPView *esp = [[ESPView alloc] initWithFrame:keyWindow.bounds];
            [rootVC.view addSubview:esp];

            // Adiciona o Menu
            MenuView *menu = [[MenuView alloc] initWithFrame:CGRectMake(40, 100, 220, 100)];
            [rootVC.view addSubview:menu];
        }
    });
}
