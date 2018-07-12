//
//  InventoryCollectionViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-27.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit

class InventoryCollectionViewController: UIViewController  {


    @IBOutlet weak var InventoryCollectionView: UICollectionView!
    
    private var inventory = [Inventory]()
    
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Inventory"
        tabBarItem = UITabBarItem.init(title: title, image: UIImage.iconCheckout, selectedImage: UIImage.iconCheckout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Inventory"
        tabBarItem = UITabBarItem.init(title: title, image: UIImage.iconCheckout, selectedImage: UIImage.iconCheckout)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInventory))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        
        //setup Grid View
        self.setupGridView()
        loadInventory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if User.current()?.business?.rewardModel?.modelType?.intValue == 5 {
            navigationItem.prompt = nil
        } else {
            navigationItem.prompt = "Set your businesses RewardModel to `Inventory`"
        }
    }
    
    @objc
    func loadInventory() {
        API.shared.fetchInventoryList {
            self.inventory = $0
            self.InventoryCollectionView.reloadData()
            self.InventoryCollectionView.refreshControl?.endRefreshing()
        }
    }
    
   
    @objc
    func addInventory() {
        navigationController?.pushViewController(AddInventoryViewController(for: User.current()!.business!), animated: true)
    }

    func setupGridView(){
        self.InventoryCollectionView.alwaysBounceVertical = true
        self.InventoryCollectionView.delegate = self
        self.InventoryCollectionView.dataSource = self
        //Register cells
        self.InventoryCollectionView.register(UINib(nibName: "InventoryCell", bundle: nil), forCellWithReuseIdentifier: "InventoryCell")
        let flow = InventoryCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(loadInventory), for: .valueChanged)
        InventoryCollectionView.refreshControl = rc
    }

}

extension InventoryCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = InventoryCollectionView.dequeueReusableCell(withReuseIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        cell.setInventoryName(text: self.inventory[indexPath.row].name)
        cell.setInventoryImage(image: self.inventory[indexPath.row].image)
        cell.setCost(number: self.inventory[indexPath.row].price)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AddInventoryViewController(editing: inventory[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension InventoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
    }
    
    func calculateWith() -> CGFloat{
        let estimatedWidth =  CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
    
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
        
    }
}


