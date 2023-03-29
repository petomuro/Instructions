//
//  ExampleApp.swift
//  Example
//
//  Created by Jake Heiser on 9/22/21.
//

import Instructions
import SwiftUI

class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else {
            return nil
        }
        
        return rootViewController?.view == hitView ? nil : hitView
    }
}

struct SceneView<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .ignoresSafeArea(.all)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    var scSceneWindow: UIWindow?
    weak var windowScene: UIWindowScene?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
    }
    
    func setupWindow<V: View>(@ViewBuilder content: () -> V) {
        guard let windowScene = windowScene else {
            return
        }
        
        let scSceneViewController = UIHostingController(rootView: SceneView {
            content()
        })
        scSceneViewController.view.backgroundColor = .clear
        
        let scSceneWindow = PassThroughWindow(windowScene: windowScene)
        scSceneWindow.rootViewController = scSceneViewController
        scSceneWindow.isHidden = false
        
        self.scSceneWindow = scSceneWindow
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        
        return sceneConfig
    }
}

@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor private var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            InstructionsContainerView {
                ContentView()
            }
        }
    }
}
