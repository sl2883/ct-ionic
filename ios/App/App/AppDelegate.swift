import UIKit
import Capacitor
import Firebase

import CleverTapSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Called when the app was launched with a url. Feel free to add additional processing here,
        // but if you want the App API to support tracking app url opens, make sure to keep this call
        return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Called when the app was launched with an activity, including Universal Links.
        // Feel free to add additional processing here, but if you want the App API to support
        // tracking app url opens, make sure to keep this call
        return ApplicationDelegateProxy.shared.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let statusBarRect = UIApplication.shared.statusBarFrame
        guard let touchPoint = event?.allTouches?.first?.location(in: self.window) else { return }

        if statusBarRect.contains(touchPoint) {
            NotificationCenter.default.post(name: .capacitorStatusBarTapped, object: nil)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let deviceTokenStr = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
            CleverTap.sharedInstance()?.setPushTokenAs(deviceTokenStr)
            print("Sending push token to clevertap ", deviceTokenStr)
        
            Messaging.messaging().apnsToken = deviceToken
            Messaging.messaging().token(completion: { (token, error) in
                if let error = error {
                    NotificationCenter.default.post(name: .capacitorDidFailToRegisterForRemoteNotifications, object: error)
                } else if let token = token {
                    NotificationCenter.default.post(name: .capacitorDidRegisterForRemoteNotifications, object: token)
                    
                    print("Device token to use from Firebase messaging ", token)
                    
                }
              })
        }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NotificationCenter.default.post(name: Notification.Name.capacitorDidFailToRegisterForRemoteNotifications, object: error)
      }
    
    
    func application(didReceive
        notification: UNNotificationRequest) {
        CleverTap.sharedInstance()?.handleNotification(withData: notification)
    }

    // As of iOS 8 and above
    func application(handleActionWithIdentifier identifier: String?,
                     forLocalNotification notification: UNNotificationRequest, completionHandler: () -> Void) {
        CleverTap.sharedInstance()?.handleNotification(withData: notification)
        completionHandler()
    }

    func application(handleActionWithIdentifier identifier: String?,
                     forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        CleverTap.sharedInstance()?.handleNotification(withData: userInfo)
        completionHandler()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        CleverTap.sharedInstance()?.handleNotification(withData: userInfo)
        completionHandler(.noData)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            
        /**
         Use this method to perform the tasks associated with your app’s custom actions. When the user responds to a notification, the system calls this method with the results. You use this method to perform the task associated with that action, if at all. At the end of your implementation, you must call the completionHandler block to let the system know that you are done processing the notification.
         
         You specify your app’s notification types and custom actions using UNNotificationCategory and UNNotificationAction objects. You create these objects at initialization time and register them with the user notification center. Even if you register custom actions, the action in the response parameter might indicate that the user dismissed the notification without performing any of your actions.
         
         If you do not implement this method, your app never responds to custom actions.
         
         see https://developer.apple.com/reference/usernotifications/unusernotificationcenterdelegate/1649501-usernotificationcenter
         
         **/
        
        // if you wish CleverTap to record the notification open and fire any deep links contained in the payload. Skip this line if you have opted for auto-integrate.
        CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        
        completionHandler()
            
    }

}
