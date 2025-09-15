// ios/Runner/AppDelegate.swift
import Flutter
import UIKit
import SwiftUI

@main
@objc class AppDelegate: FlutterAppDelegate {
    var isGameActive = false
    
    // MARK: - App lifecycle
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureAppearance()
        configureAudioSession()
        setupIQKeyboardManager()
        configureSBComponent()
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Embed FlutterViewController inside UINavigationController to enable PUSH
        if let flutterVC = window?.rootViewController as? FlutterViewController {
            
            let nav = UINavigationController(rootViewController: flutterVC)
            nav.setNavigationBarHidden(true, animated: false)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            
            let channel = FlutterMethodChannel(
                name: "games_engine",
                binaryMessenger: flutterVC.binaryMessenger
            )
            
            channel.setMethodCallHandler { [weak self] (call, result) in
                print("need to open the game")
                guard let self = self else { return }
                
                switch call.method {
                case "techplay_mn_1008", "techplay_mn_1009", "techplay_lodemd5", "techplay_lode_virtual":
                    if let args = call.arguments as? [String: Any] {
                        self.isGameActive = true
                        forcePortraitOrientation()
                        self.presentBasicGame(nav: nav, args: args, channel: channel)
                    }
                    result(nil)
                    
                case "ksport_minigame":
                    let args = call.arguments as? [String: Any]
                    self.pushSBComponent(
                        from: self.topMost(from: self.window?.rootViewController),
                        args: args,
                        channel: channel,
                        onExit: {
                            // Notify Flutter that the game closed
                            channel.invokeMethod("gameClosed", arguments: nil)
                        }
                    )
                    result(nil)
                    
                default:
                    print("The default")
                    self.isGameActive = false
                    result(nil)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        print("IS GAME ACTIVE: \(isGameActive)")
        if isGameActive {
            return .portrait
        }
        return .all
    }
    
    private func forcePortraitOrientation() {
        // Force the device orientation
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
        windowScene.requestGeometryUpdate(geometryPreferences) { error in
            print("Orientation change error: \(error)")
        }
    }
        
    
    func requestDeposit(nav: UINavigationController, channel: FlutterMethodChannel, gameID: String) {
        print("onRequestDeposit called")
        // gameID is the argument for the dialog to return to the specific game
        
        // 1) Pop back to Flutter first
        nav.popViewController(animated: true)
        // 2) Wait a bit for Flutter to be ready, then call deposit
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Calling openDeposit method")
            channel.invokeMethod("openDeposit", arguments: [
                "gameID" : gameID
            ])
        }
    }
    // MARK: - Deeplinks
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleDeepLink(url)
        return true
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            handleDeepLink(url)
            return true
        }
        return false
    }
}
