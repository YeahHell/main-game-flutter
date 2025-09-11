//
//  SBGameProcessor.swift
//  Runner
//
//  Created by Karen on 11/09/2025.
//

import Flutter
import UIKit
import SwiftUI
import AVKit
import iOS_NNSBComponent

// MARK: - SB Presenter (Push)
extension AppDelegate {
    
    func topMost(from root: UIViewController?) -> UIViewController? {
        var vc = root
        while let presented = vc?.presentedViewController { vc = presented }
        if let nav = vc as? UINavigationController { return nav.visibleViewController }
        if let tab = vc as? UITabBarController { return tab.selectedViewController }
        return vc
    }
    
    // Push SBView instead of presenting it. No "X" button.
    func pushSBComponent(from presenter: UIViewController?,
                         args: [String: Any]?,
                         channel: FlutterMethodChannel,
                         onExit: @escaping () -> Void) {
        // Find a navigation controller to push onto
        let nav: UINavigationController? = (presenter as? UINavigationController)
        ?? presenter?.navigationController
        ?? (window?.rootViewController as? UINavigationController)
        
        guard let nav = nav else {
            assertionFailure("No UINavigationController available to push SBComponent")
            return
        }
        
        let tpToken = (args?["tpToken"] as? String) ?? ""
        let meta = (args?["meta"] as? [String: String]) ?? [:]
        
        let config = SBComponentConfiguration(
            tpToken: tpToken,
            agentId: 4, // giữ nguyên agentId của bạn
            userProfile: nil,
            signInAction: nil,
            signUpAction: nil,
            expiredAction: nil,
            onChangeRotation: { isLandscape in
                UIDevice.current.setValue(
                    isLandscape ? UIInterfaceOrientation.landscapeRight.rawValue
                    : UIInterfaceOrientation.portrait.rawValue,
                    forKey: "orientation"
                )
            },
            showToastAction: { _ in },
            metaData: meta
        )
        
        // Push SBView directly — no CloseWrapper, no X button
        let root = SBView(
            configuration: config,
            onFinish: {
                print("SB onFinish called") // Debug log
                // 1) notify Flutter that game closed
                onExit()
                // 2) go back to Flutter by popping
                nav.popViewController(animated: true)
            },
            onRequestDeposit: {
                print("SB onRequestDeposit called") // Debug log
                // 1) Pop back to Flutter first
                nav.popViewController(animated: true)
                
                // 2) Wait a bit for Flutter to be ready, then call deposit
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Calling openDeposit method") // Debug log
                    channel.invokeMethod("openDeposit", arguments: nil)
                }
            }
        )
        
        let host = UIHostingController(rootView: root)
        host.hidesBottomBarWhenPushed = true
        nav.pushViewController(host, animated: true)
    }
}

// MARK: - Configs
extension AppDelegate {
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
    
    func configureSBComponent() {
        SBComponentInstallConfig.configuration()
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
