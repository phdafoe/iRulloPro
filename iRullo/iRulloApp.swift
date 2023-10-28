//
//  iRulloApp.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 15/10/23.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

@main
struct iRulloApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SplashView(viewModel: SplashViewModel())
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate{

    //MARK : - Variables locales
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        self.configureNotificacionPush(application)

        return true
    }
    
    func configureNotificacionPush(_ application: UIApplication) {
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        /*
         Regístro para recibir notificaciones remotas. Esto muestra un diálogo de permiso en la primera ejecución, para
         mostrar el cuadro de diálogo en un momento más apropiado, mover este registro en consecuencia.
         */
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        /*
         Si recibe un mensaje de notificación mientras la aplicación está en segundo plano,
         esta devolución de llamada no se activará hasta que el usuario toque la notificación para iniciar la aplicación
         */
        // TODO: Manejador de datos de la notificación
        
        /*With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
         Print message ID.*/
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        /*
         Si recibe un mensaje de notificación mientras la aplicación está en segundo plano,
         esta devolución de llamada no se activará hasta que el usuario toque la notificación para iniciar la aplicación
         */
        // TODO: Manejador de datos de la notificación
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    /*Esta función se agrega aquí solo con fines de depuración y se puede eliminar si el swizzling está habilitado.
     Si el swizzling está deshabilitado, esta función debe implementarse para que el token APN se pueda emparejar con
     el token de registro de FCM.
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // Con swizzling desactivado, debe configurar el token de APN aquí.
        Messaging.messaging().apnsToken = deviceToken
    }
  
}

// MARK: - AppDelegate: MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: Si es necesario, envíe el token al servidor de aplicaciones.
        // Note: Esta devolución de llamada se activa en el inicio de cada aplicación y cada vez que se genera un nuevo token..
    }
}

// MARK: - AppDelegate : UNUserNotificationCenterDelegate
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Reciba notificaciones mostradas para dispositivos iOS 10.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Cambie esto a su opción de presentación preferida
        completionHandler([[.banner, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
