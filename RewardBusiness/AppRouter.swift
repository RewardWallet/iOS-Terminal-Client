//
//  AppRouter.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-21.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import URLNavigator
import SafariServices
import DynamicTabBarController

enum AppRoute {
    //case dispatch
    
    //Auth
    case login, signup//, logout
    
    //checkout
    case checkout
    
    //numpad
    case numpad, inventory
    
    //qrcode
    case qrcode
    
    //account
    case account
    
    var pattern: URLPattern {
        
        let urlScheme = "rewardBusiness://rewardBusiness.io/"
        
        switch self {
        //case .dispatch: return urlScheme
        case .login: return urlScheme + "login/"
        case .signup: return urlScheme + "signup/"
        case .checkout :return urlScheme + "checkout/"
        //case .logout: return urlScheme + "logout/"
      
//        case .business : return urlScheme + "business/"
//
       case .account: return urlScheme + "account/"
//        case .profile: return urlScheme + "profile/"
//        case .about: return urlScheme + "about/"
//        case .termsOfService: return urlScheme + "about/terms-and-service"
        case .numpad:
            return urlScheme + "numpad/"
        case .inventory:
            return urlScheme + "inventory/"
        case .qrcode:
            return urlScheme + "qrcode/"
        }
    }
}

class AppRouter: Navigator {
    static var shared = AppRouter()
    
    /// Initialization private, use the static `shared` property
    private override init() {
        super.init()
        delegate = self
        registerPaths()
    }
    
    // MARK: - Public API
    
    func viewController(for route: AppRoute, context: Any? = nil) -> UIViewController? {
        return viewController(for: route.pattern, context: context)
    }
    
    
    @discardableResult
    func present(_ route: AppRoute, context: Any? = nil, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
        
        if from == nil {
            guard let viewController = viewController(for: route, context: context) else { return nil }
            // Switch the windows rootViewController when `from` is nil
            if let wrapClass = wrap {
                let navigationController = wrapClass.init()
                navigationController.pushViewController(viewController, animated: false)
                UIApplication.shared.presentedWindow?
                    .switchRootViewController(viewController,
                                              animated: animated,
                                              duration: 0.5,
                                              options: .transitionFlipFromRight,
                                              completion: { success in
                                                if success {
                                                    completion?()
                                                }
                    })
                return navigationController
            } else {
                UIApplication.shared.presentedWindow?
                    .switchRootViewController(viewController,
                                              animated: animated,
                                              duration: 0.5,
                                              options: .transitionFlipFromRight,
                                              completion: { success in
                                                if success {
                                                    completion?()
                                                }
                    })
                return viewController
            }
        } else {
            return present(route, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
        }
        
    }
    
    func push(_ route: AppRoute, context: Any?, from: UINavigationControllerType?, animated: Bool) {
        
        _ = push(route, context: context, from: from, animated: animated)
    }
    
    // MARK: - Private API
    
    private func registerPaths() {
        
        for route in iterateEnum(AppRoute.self) {
            register(route.pattern, viewControllerFactory(for: route))
        }
        
        //        register("navigator://user/<username>") { url, values, context in
        //            guard let username = values["username"] as? String else { return nil }
        //            return UserViewController(navigator: navigator, username: username)
        //        }
        //        register("http://<path:_>", self.webViewControllerFactory)
        //        register("https://<path:_>", self.webViewControllerFactory)
        //
        //        handle("navigator://alert", self.alert(navigator: navigator))
        //        handle("navigator://<path:_>") { (url, values, context) -> Bool in
        //            // No navigator match, do analytics or fallback function here
        //            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
        //            return true
        //        }
    }
    private func viewControllerFactory(for route: AppRoute) -> ViewControllerFactory {
        return { (url, values, context) -> UIViewController? in
            // Code
            switch route {
//            case .dispatch:
//                return DispatchViewController()
            case .login:
                return LoginViewController()
//            case .logout:
//                User.logoutInBackground(nil)
//                return self.viewController(for: .welcome)
            case .signup:
                return SignUpViewController()
            case .numpad:
                return NumPadViewController()
//            case .inventory:
//                return InventoryItemViewController()
//
            case .qrcode:
                return  QRScanViewController()
            case .checkout, .inventory, .account:
                let index = [.checkout, .inventory, .account].index(of: route)!
                let viewControllers = [HomeViewController(), InventoryItemViewController(),  BusinessSettingViewController()]
                viewControllers.forEach { $0.viewDidLoad() }
                let nav = viewControllers.map {
                    return PrimaryNavigationController(rootViewController: $0)
                }
               
                
                let tabBarController = MainContainerController(viewControllers: nav)
                tabBarController.displayViewController(at: index, animated: false)
                return tabBarController
//            case .profile:
//                guard let user = User.current() else { return self.viewController(for: .login) }
//                return EditProfileViewController(user: user)
//            case .business:
//                guard let business = context as? Business else { fatalError("Business nil in context") }
//                return BusinessViewController(for: business)
//
//            case .about:
//                return RWViewController()
//            case .termsOfService:
//                return TermsOfServiceViewController()

            }
            
        }
    
    }
    private func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController)
            return true
        }
    }

    
    
}
extension AppRouter: NavigatorDelegate {
    
    func shouldPush(viewController: UIViewController, from: UINavigationControllerType) -> Bool {
        return true
    }
    
    func shouldPresent(viewController: UIViewController, from: UIViewControllerType) -> Bool {
        return true
    }

}
