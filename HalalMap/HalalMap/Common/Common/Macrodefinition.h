#import "BSUIBarButtonItem.h"
#import "AppDelegate.h"
//Device
#define isRetina            ([UIScreen mainScreen].scale > 1)

//系统版本
#define isIOS8              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define isIOS7              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define isIOS5              ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
//当前设备系统的版本号
#define currentDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//当前软件版本号
#define currentVersionString      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define currentShortVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define isIphone4Screen     (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)))
//是否iphone5的分辨率
#define isIphone5Screen     (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568)))
#define iPhone5             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) 

//#define isSimulator         (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
#define isIphone            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isIpad              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


// Screen Size
#define SCREEN_WIDTH            (MIN(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds])))
#define SCREEN_HEIGHT           (MAX(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds])))


// 偏好设置简写
#define USERDEFAULT                         [NSUserDefaults standardUserDefaults]
#define UserDefaultSynchronize              ([[NSUserDefaults standardUserDefaults] synchronize])

// 加载图片
#define LOADBUNDLEIMAGE(PATH,TYPE)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:PATH ofType:TYPE]]

// 设置ARBG
#define COLOR_WITH_ARGB(R,G,B,A)            [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
#define COLOR_WITH_RGB(R,G,B)               [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1]
#define COLOR_WITH_IMAGENAME(imageName)     [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]]
//黑色半透层
#define TRANSLUCENTCOLOR(A)           [UIColor colorWithRed:0.0f / 255.0 green:0.0f / 255.0 blue:0.0f / 255.0 alpha:A]


//当前用户的数据
#define HMRunDataShare ([HMRunData sharedHMRunData])


// block 弱引用
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

// 获取keywindow
#define HM_KEY_WINDOW           [[UIApplication sharedApplication]keyWindow]

// appwindow
#define HM_AppWindow            ([[UIApplication sharedApplication].delegate window])

// AppDelegate
#define HM_SharedAppDelegate    ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// 发送通知
#define HM_POST_MSG_WITH_OBJ_DICT(aName, anObject, aUserInfo)   [[NSNotificationCenter defaultCenter] \
postNotificationName: aName                                                                           \
object: anObject                                                                                      \
userInfo: aUserInfo];

#define HM_POST_MSG_WITH_DICT(aName, aUserInfo)                 HM_POST_MSG_WITH_OBJ_DICT(aName, nil, aUserInfo)
#define HM_POST_MSG_WITH_OBJ(aName, anObject)                   HM_POST_MSG_WITH_OBJ_DICT(aName, anObject, nil)
#define HM_POST_MSG(aName)                                      HM_POST_MSG_WITH_OBJ(aName, nil)

// 监听通知
#define  HM_BIND_MSG_WITH_OBJ(STRID, SELECTOR, OBJ)             [[NSNotificationCenter defaultCenter] addObserver : self \
selector : SELECTOR                                                                                                  \
name : STRID                                                                                                         \
object : OBJ];

#define  HM_BIND_MSG(STRID, SELECTOR)                           HM_BIND_MSG_WITH_OBJ(STRID, SELECTOR, nil);

// 移除通知
#define HM_Remove_MSG(STRID)                                    [[NSNotificationCenter defaultCenter] removeObserver : self name : STRID object : nil];
// 移除所有在View上的通知
#define HM_RemoveAll_MSGInView(View)                                  [[NSNotificationCenter defaultCenter] removeObserver : View]
// 移除所有自己上面的通知
#define HM_RemoveAll_MSG()                                      [[NSNotificationCenter defaultCenter] removeObserver : self]


