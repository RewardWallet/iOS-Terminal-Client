//
//  AccountSectionController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-01.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//


import UIKit
import IGListKit
import Former

final class AccountSectionController: ListSectionController {
    
    // MARK: - Properties
    
    private weak var user: User?
    
    private let viewModels: [AccountCellViewModel] = [
        AccountCellViewModel(text: "Profile", icon: .icon_user, route: .profile),
        AccountCellViewModel(text: "Add Inventory", icon: .icon_shop, route: .addInventory),
        AccountCellViewModel(text: "Add Coupon", icon: .iconCoupon, route: .addCoupon ),
        AccountCellViewModel(text: "Notification", icon: .iconNotification, route: .notification),
        AccountCellViewModel(text: "About", icon: .icon_about, route: .about),
        AccountCellViewModel(text: "Log Out", icon: .icon_logOut, route: .logout)

    ]
    
    // MARK: - Subview Reference
    
    weak fileprivate var headerView: AccountHeaderViewCell?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        supplementaryViewSource = self
        scrollDelegate = self
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
    
    override func numberOfItems() -> Int {
        return viewModels.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: AccountCell.self, for: self, at: index) as? AccountCell else {
            fatalError()
        }
        cell.bindViewModel(viewModels[index])
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        guard let route = viewModels[index].route else { return }
//        if route == .logout {
//            AppRouter.shared.present(route, wrap: nil, from: nil, animated: true, completion: nil)
//        } else {
//            AppRouter.shared.push(route, context: nil, from: viewController?.navigationController, animated: true)
//        }
        
        AppRouter.shared.push(route, context: nil, from: viewController?.navigationController, animated: true)
   
    }
    
}

// MARK: - ListSupplementaryViewSource
extension AccountSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        
        // Stretchy Banner
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: AccountHeaderViewCell.self, at: index) as? AccountHeaderViewCell else {
            fatalError()
        }
        view.bindViewModel(user as Any)
        headerView = view
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        // Stretchy Banner
        return CGSize(width: containerSize.width, height: containerSize.height * 0.3)
    }
    
}

// MARK: - ListScrollDelegate
extension AccountSectionController: ListScrollDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, didScroll sectionController: ListSectionController) {
        guard let yOffset = listAdapter.collectionView?.contentOffset.y, yOffset <= 0 else { return }
        let headerHeight = sizeForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: 0).height
        let scale: CGFloat = 1 - (yOffset/headerHeight)
        headerView?.stretchImageView(to: scale, offsetBy: yOffset)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willBeginDragging sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDragging sectionController: ListSectionController, willDecelerate decelerate: Bool) {
        
    }
    
}

