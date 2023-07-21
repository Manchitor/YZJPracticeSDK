//
//  ERColorDefine.h
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#ifndef ERColorDefine_h
#define ERColorDefine_h

//十六进制设置颜色
#define HEXCOLOR(c)     HEXCOLORA(c,1.0f)

#define HEXCOLORA(c,a)   [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:a]

#define COLOR(A)                         RGB(A,A,A)                 // 单色

#define COLOR_VIEW_BG                    HEXCOLOR(0XFFFFFF)         // 控制器背景颜色

#define COLOR_TEXT_DEFAULT               HEXCOLOR(0X333333)    //默认文字颜色

#define COLOR_TABBARITEM_DEFAULT         HEXCOLOR(0X9EA7B1)    //默认tabbaritem文字颜色


//暗黑模式下 指定placeholder颜色 不然会变浅
#define PLACE_HOLDER_COLOR          [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.000]


#define RGB(r,g,b)      RGBA(r,g,b,1.0f)

// rgbs设置颜色
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]





#endif /* ERColorDefine_h */
