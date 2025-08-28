// ios/Runner/AppDelegate.swift
import Flutter
import UIKit
import SwiftUI
import AVKit
import Mega645

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var isGameActive = false
    
    // MARK: - App lifecycle
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureAppearance()
        configureAudioSession()
        setupIQKeyboardManager()
        
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
                guard let self = self else { return }
                
                switch call.method {
                case "mega645":
                    if let args = call.arguments as? [String: Any] {
                        self.isGameActive = true
                        forcePortraitOrientation()
                        self.presentMegaGame(nav: nav, args: args, channel: channel)
                    }
                    result(nil)
                    
                default:
                    self.isGameActive = false
                    result(nil)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
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
    
    private func presentMegaGame(nav: UINavigationController, args: [String: Any], channel: FlutterMethodChannel) {
        let tpToken = args["tpToken"] as? String ?? ""
        let balance = args["balance"] as? Double ?? 0
        
        // Create Mega645 view
        let gameView = Mega645(token: tpToken, balance: balance) {
            print("onRequestDeposit called")
            
            // 1) Pop back to Flutter first
            nav.popViewController(animated: true)
            // 2) Wait a bit for Flutter to be ready, then call deposit
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("Calling openDeposit method")
                channel.invokeMethod("openDeposit", arguments: [
                    "gameId" : "mega645"
                ])
            }
        }.ignoresSafeArea(edges: .top)
        
        let host = UIHostingController(rootView: gameView)
        host.hidesBottomBarWhenPushed = true
        nav.pushViewController(host, animated: true)
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

// MARK: - SB Presenter (Push)
private extension AppDelegate {
    
    func topMost(from root: UIViewController?) -> UIViewController? {
        var vc = root
        while let presented = vc?.presentedViewController { vc = presented }
        if let nav = vc as? UINavigationController { return nav.visibleViewController }
        if let tab = vc as? UITabBarController { return tab.selectedViewController }
        return vc
    }
}

// MARK: - Configs
private extension AppDelegate {
    func configureAppearance() {
        let nav = UINavigationBarAppearance()
        nav.configureWithTransparentBackground()
        nav.backgroundColor = .clear
        nav.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance = nav
        UIBarButtonItem.appearance().tintColor = .clear
    }
    
    func configureAudioSession() {
        try? AVAudioSession.sharedInstance()
            .setCategory(.playback, options: [.mixWithOthers])
    }
    
    func setupIQKeyboardManager() { }
    
    func handleDeepLink(_ url: URL) {
        // If root is a UINavigationController, get its FlutterViewController
        let rootVC: UIViewController? = {
            if let nav = window?.rootViewController as? UINavigationController {
                return nav.viewControllers.first
            }
            return window?.rootViewController
        }()
        
        if let flutterVC = rootVC as? FlutterViewController {
            let channel = FlutterMethodChannel(
                name: "deep_link",
                binaryMessenger: flutterVC.binaryMessenger
            )
            channel.invokeMethod("openURL", arguments: url.absoluteString)
        }
    }
}
