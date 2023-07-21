//
//  ERFameDefine.h
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#ifndef ERFameDefine_h
#define ERFameDefine_h
/**
 *  设备是iPhoneX_ALL
 */
#define TARGET_IPHONE_X_ALL  ([UIScreen mainScreen].bounds.size.height >= 812)

// 屏幕size
#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)

// 屏幕宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 导航栏高度
#define NAV_BAR_HEIGHT        44

// 工具栏高度
#define TAB_BAR_HEIGHT        (TARGET_IPHONE_X_ALL ? 83 : 49)

// 状态栏高度
#define STATUS_BAR_HEIGHT     [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏高度
#define NAV_BAR_HEIGHT2       (self.navigationController.navigationBar.bounds.size.height)

// 工具栏高度
#define TAB_BAR_HEIGHT2       (self.tabBarController.tabBar.bounds.size.height)

//导航栏高度
#define NAV_HEIGHT            (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)


#endif /* ERFameDefine_h */
