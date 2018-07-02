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
    
    let inventory = Inventory()
    
    //let unitCost = ["1.50","2.0","2.0","3.5", "4.5","5.5"]
    let unitCost = ["1.0","2.0","2.0","3.5", "4.5","5.5"]
    let inventoryName = ["beer","cheese","chicken","coffee","doughnut","pancakes"]
    var inventoryImage: [UIImage] = [
        UIImage(named: "beer-1")!,
        UIImage(named: "cheese")!,
        UIImage(named: "chicken-leg")!,
        UIImage(named: "coffee")!,
        UIImage(named: "doughnut")!,
        UIImage(named: "pancakes")!
    ]
    
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
   
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        view.backgroundColor = .backgroundColor
        title = "Total Inventory"
        tabBarItem = UITabBarItem.init(title: title, image: UIImage.iconCheckout    , selectedImage: UIImage.iconCheckout)

        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: #selector(InventoryCollectionViewController.didTapAdd))
        navigationItem.rightBarButtonItem = addButton
        addButton.tintColor = UIColor.white
        //navigationBar.items = [navigationItem]
        
        
        //set Delegates
        //self.InventorycollectionView.delegate = self
        self.InventoryCollectionView.dataSource = self
        
        //Register cells
        self.InventoryCollectionView.register(UINib(nibName: "InventoryCell", bundle: nil), forCellWithReuseIdentifier: "InventoryCell")

        //setup Grid View
        self.setupGridView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupGridView()
        DispatchQueue.main.async {
            self.InventoryCollectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupGridView(){
        let flow = InventoryCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }

    
    @objc private func didTapAdd() {
       
    }
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InventoryCollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventoryName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = InventoryCollectionView.dequeueReusableCell(withReuseIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        cell.setInventoryName(text: self.inventoryName[indexPath.row])
        cell.setInventoryImage(image: self.inventoryImage[indexPath.row])
        cell.setCost(text: self.unitCost[indexPath.row])
        return cell
    }
    
}


extension InventoryCollectionViewController: UICollectionViewDelegateFlowLayout{
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


