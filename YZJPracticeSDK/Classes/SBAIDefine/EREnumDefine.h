//
//  EREnumDefine.h
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#ifndef EREnumDefine_h
#define EREnumDefine_h


/// 单一弹框类型
typedef NS_ENUM(NSInteger, ERAlertSingleType) {
    ///清除缓存
    ERAlertSingleTypeCacheClear             = 0,
    /// 退出登录
    ERAlertSingleTypeLoginOut               = 1,
    /// 解绑邮箱
    ERAlertSingleTypeUnbindEMail            = 2,
    
};
#endif /* EREnumDefine_h */
