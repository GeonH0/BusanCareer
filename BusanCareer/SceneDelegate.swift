//
//  SceneDelegate.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 탭 바 컨트롤러 인스턴스 생성
        let tabBarController = UITabBarController()

        // 첫 번째 탭: ListViewController
        let listViewController = ListViewController(style: .plain)
        let listNavController = UINavigationController(rootViewController: listViewController)
        listNavController.tabBarItem = UITabBarItem(
            title: "목록",
            image: UIImage(systemName: "list.bullet.rectangle.portrait"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        )

        // 두 번째 탭: MapViewController
        let mapViewController = MapViewController()
        let mapNavController = UINavigationController(rootViewController: mapViewController)
        mapNavController.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        // 탭 바 컨트롤러에 뷰 컨트롤러 추가
        tabBarController.viewControllers = [listNavController, mapNavController]

        // UIWindow 인스턴스 생성 및 rootViewController 설정
        self.window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

