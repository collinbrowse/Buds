//
//  ProfileViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/27/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD

class ProfileViewController: UITableViewController {
    
    var modelController: ModelController! {
        willSet {
            print("Printing the Model Controller Person's name from ProfileVC: \(newValue.person.name)")
        }
    }
    var username: String?
    var ref: DatabaseReference!
    var user: User?
    var storedOffsets = [Int: CGFloat]()
    var categories = [String]()
    var strains = [[String]]()
    var counter = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect to Realtime Database
        ref = Database.database().reference()
        
        // We are going to load this data into cache, and then have the tableview pull from the cache
        Network.getUserStrainData(userID: modelController.person.id) { (userInfo) in
            
            for (thing1, thing2) in userInfo {
                self.categories.append(thing1)
                self.strains.append(thing2)
            }
            self.tableView.reloadData()
        }
        
        if modelController.person.profilePicture != nil {
            setUpNavbar(modelController.person.profilePicture!)
        } else {
            
            // Make a network call to find the profile picture
            Network.getProfilePicture(userID: modelController.person.id) { (profilePicture) in
                self.setUpNavbar(profilePicture)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }

}


///////////////////////////////////////////
/// Table View Methods
///////////////////////////////////////////
extension ProfileViewController {
    
    ///numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    ///cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    ///heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200
        } else {
            return 120
        }
    }
    ///numberOfSectionsInTableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return strains.count
    }
    ///titleForHeaderInSection
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].uppercased()
    }
    ///viewForHeaderInSection
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 16, y: 10, width: tableView.bounds.width, height: 30))
        label.text = categories[section].uppercased()
        label.font = UIFont(name: "Arvo-Italic", size: 17)
        label.textColor = .black
        view.addSubview(label)
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    ///willDisplay cell forRowAt
    override func tableView(_ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forSection: indexPath.section)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    ///didEndDisplaying cell
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

//////////////////////////////////////////////
///Collection View Methods
//////////////////////////////////////////////
// How many collection view cells should we have in each row?
// What goes in each collection view cell?
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    ///numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    ///cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundView = UIImageView(image: UIImage(named: "weed_background.png"))
        cell.layer.cornerRadius = 20.0
        cell.layer.shadowOpacity = 0.9
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.layer.backgroundColor = UIColor.gray.cgColor
        
        
        let itemHeight = collectionView.bounds.height
        let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let top = collectionViewFlowLayout?.sectionInset.top ?? 0
        let bottom = collectionViewFlowLayout?.sectionInset.bottom ?? 0
        let label = UILabel(frame: CGRect(x: 10, y: itemHeight - (top + bottom + 34 + 20), width: 80, height: 34))
        let labelText = strains[collectionView.tag][indexPath.row].uppercased()
        label.text = labelText.replacingOccurrences(of: "_", with: " ")
        label.textAlignment = .center
        label.font = UIFont(name: "Arvo-Bold", size: 44)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 0 // = any number of lines
        label.baselineAdjustment = .alignCenters
        cell.contentView.addSubview(label)
    
        return cell
    }
    
    ///didEndDisplaying
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    ///sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Dynamically set the height of a collection view cell based on the height of the table view row and the section insets on the collectionview
        let itemHeight = collectionView.bounds.height
        let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let top = collectionViewFlowLayout?.sectionInset.top ?? 0
        let bottom = collectionViewFlowLayout?.sectionInset.bottom ?? 0
        return CGSize(width: 100, height: itemHeight - (top + bottom))
    }

    func configureCard(_ cell: UICollectionViewCell, _ tag: Int) -> UICollectionViewCell {
        
        var y = 50
        if tag == 0 { y = 100 }
        let label = UILabel(frame: CGRect(x: 0, y: y, width: 100, height: 34))
        label.text = "Hello This is a long label"
        label.textAlignment = .center
        label.font = UIFont(name: "Arvo-Bold", size: 44)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 0 // = any number of lines
        label.baselineAdjustment = .alignCenters
        cell.addSubview(label)
        
        cell.backgroundView = UIImageView(image: UIImage(named: "weed_background.png"))
        cell.layer.cornerRadius = 20.0
        cell.layer.shadowOpacity = 0.9
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.layer.backgroundColor = UIColor.gray.cgColor
        return cell
    }
}

//////////////////////////////////////////
///Navigation Bar Methods
//////////////////////////////////////////
extension ProfileViewController {
    
    // Add the User's profile picture to the navigation bar
    func setUpNavbar(_ image: UIImage) {
        
        // Alter the Navigation Bar
        // Set up/Gain Access to everything we will need
        let navigationBar = navigationController!.navigationBar
        let bannerWidth = navigationBar.frame.size.width
        let bannerHeight = navigationBar.frame.size.height
        let titleView = UIView()
        let profileImageView = UIImageView(image: image)
        
        // Create the View in the Title Bar and add the image
        titleView.frame = CGRect(x: 0, y: 0, width: bannerWidth, height: bannerHeight)
        titleView.addSubview(profileImageView)
        
        // Style & Position Image within the titleView
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Finally set the titleView of the nav bar to our new title view
        navigationItem.titleView = titleView
        SVProgressHUD.dismiss()
    }
}


extension UIColor {
    
    class func randomColor() -> UIColor {

        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
