
@import UIKit;

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
//加遮罩
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

//切图
-(UIImage*)cropWithRatio:(CGFloat)CropRatio;
//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect;
//截圆形图
-(UIImage*) circleParam:(CGFloat) inset;

@end
