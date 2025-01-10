//
//  SceneDelegate.swift
//  Example
//
//  Created by Harry Nguyezn on 01/10/25.
//
import SwiftUI
import TracePointKit
import TracePointKitImp

// MARK: - SceneDelegate

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  // MARK: Internal

  var window: UIWindow?

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions)
  {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    let dependency = AppDependencyImp(tracePointKit: TracePointKitImp(isEnabled: true))
    displayContentView(for: window, with: dependency)
  }

  func sceneDidEnterBackground(_ scene: UIScene) {}

  // MARK: Private

  private func displayContentView(for window: UIWindow,
                                  with dependency: AppDependency)
  {
    let contentView = ContentView(dependency: dependency)
    window.rootViewController = UIHostingController(rootView: contentView)
    self.window = window
    window.makeKeyAndVisible()
  }
}
