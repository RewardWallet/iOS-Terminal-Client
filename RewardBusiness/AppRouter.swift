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
    case welcome, login, signup, logout
    
    //checkout
    case checkout
    
    //redeem
    case redeem
    
    //shoppingList
    case shoppingList
    
    //numpad
    case numpad, numpaditem, inventory
    
    //qrcode
    case qrcode
    
    //account
    case account, profile
    
    //inventory
    case addInventory
    
    //coupon
    case addCoupon
    
    //notification
    case notification
    
    //RewardBusiness
    case about
    
    var pattern: URLPattern {
        
        let urlScheme = "rewardBusiness://rewardBusiness.io/"
        
        switch self {
        //case .dispatch: return urlScheme
        case .welcome: return urlScheme + "welcome/"
        case .login: return urlScheme + "login/"
        case .signup: return urlScheme + "signup/"
        case .checkout: return urlScheme + "checkout/"
        case .redeem: return urlScheme + "redeem/"
        case .shoppingList: return urlScheme + "shoppingList/"
        case .logout: return urlScheme + "logout/"
      
//        case .business : return urlScheme + "business/"
//
       case .account: return urlScheme + "account/"
       case .profile: return urlScheme + "profile/"
//        case .about: return urlScheme + "about/"
//        case .termsOfService: return urlScheme + "about/terms-and-service"
        case .numpad:
            return urlScheme + "numpad/"
        case .numpaditem:
            return urlScheme + "numpadItem/"
            
        case .inventory:
            return urlScheme + "inventory/"
        case .addCoupon:
            return urlScheme + "addCoupon/"
        case .qrcode:
            return urlScheme + "qrcode/"
        case .about:
            return urlScheme + "about/"
        case .notification:
            return urlScheme + "notification/"
        case .addInventory:
            return urlScheme + "addInventory/"

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
                    .switchRootViewController(navigationController,
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
            return present(route.pattern, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
        }
        
    }
    
    func push(_ route: AppRoute, context: Any?, from: UINavigationControllerType?, animated: Bool) {
        
        _ = push(route.pattern, context: context, from: from, animated: animated)
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
            case .welcome:
                return WelcomeViewController()
                
                
                
            case .login:
                return LoginViewController()
            case .logout:
                User.logoutInBackground(nil)
                return self.viewController(for: .welcome)
            case .signup:
                return SignUpViewController()
            case .numpad:
                return NumPadViewController()
            case .numpaditem:
                guard let totalAmount = context as? Double else { fatalError("totalAmount nil in context")}
                
                let vc = InventoryItemViewController()
                vc.cost = totalAmount
                return vc
            case .redeem:
                return RedeemViewController()
    
            case .qrcode:
                print(context)
                guard let context = context as? [Any] else {
                    fatalError("context is nil")
                }
                guard let transactionId = context[1] as? String else { fatalError("transactionId nil in context")}
                let vc = QRScanViewController()
                vc.transactionId = transactionId
                guard let isRedeem = context[0] as? Bool else
                    { fatalError("isRedeem nil in context")}
                vc.isRedeem = isRedeem
                return vc
            case .shoppingList:
                return InventoryPaymentViewController()
            case .checkout, .inventory, .account:
                let index = [.checkout, .inventory, .account].index(of: route)!
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let inventoryVC = sb.instantiateViewController(withIdentifier: "inventory_vc") as! InventoryCollectionViewController
                
                let viewControllers = [HomeViewController(user: User.current()!), inventoryVC, BusinessSettingViewController(for: User.current()!.business!)]
          
                let nav = viewControllers.map {
                    return PrimaryNavigationController(rootViewController: $0)
                }
               
                
                let tabBarController = MainContainerController(viewControllers: nav)
                tabBarController.displayViewController(at: index, animated: false)
                return tabBarController
            case .profile:
                guard let user = User.current() else { return self.viewController(for: .login) }
                return EditProfileViewController(user: user)
//            case .business:
//                guard let business = context as? Business else { fatalError("Business nil in context") }
//                return BusinessViewController(for: business)
//
            case .addInventory:
                guard let business = User.current()?.business else{ return
                    self.viewController(for: .login)
                }
                return AddInventoryViewController(for: business)
            case .addCoupon:
                guard let business = User.current()?.business else{ return
                    self.viewController(for: .login)
                }
                return AddCouponViewController(for: business)
                
            case .about:
                return RWViewController()
            case .notification:
                return NotificationViewController()
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
