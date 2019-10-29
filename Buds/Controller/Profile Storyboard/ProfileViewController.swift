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
    
    //var tabBarController: UITabBarController?
    var modelController: ModelController!
    var username: String?
    var ref: DatabaseReference!
    var user: User?
    var storedOffsets = [Int: CGFloat]()
    var categories = [String]()
    var strains = [[String]]()
    var selectedStrain: String = ""
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Switcher.getUserDefaultsIsSignIn() {
           modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
        }
        
        // Connect to Realtime Database
        ref = Database.database().reference()
        
        // Get User's Strain Data
        // Save data to populate table view and collection View
        Network.getUserStrainData(userID: modelController.person.id) { (userInfo) in
            
            var info = userInfo
            
            // First look for the Favorites
            for (category, strains) in userInfo {
                if (category == "favorite") {
                    self.categories.append(category + "s")
                    self.strains.append(strains)
                    info.removeValue(forKey: "favorite")
                }
            }
            
            // Then add the rest
            for (category, strains) in info {
                self.categories.append(category)
                self.strains.append(strains)
            }
            self.tableView.reloadData()
        }
        
        // Add the User's Profile Picture to the nav bar
        if modelController.person.profilePicture != nil {
            setUpNavbar(modelController.person.profilePicture!)
        } else {
            // Make a network call to find the profile picture
            Network.getProfilePicture(userID: modelController.person.id) { (profilePicture) in
                self.setUpNavbar(profilePicture)
            }
        }
    }
    
    // Check for User's Logged In State
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    ///prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StrainDetailsViewController {
            vc.strainLabelText = selectedStrain
            vc.modelController = modelController
        }
        if let vc = segue.destination as? NewActivityViewController {
            vc.modelController = modelController
        }
    }
    
    @objc func noDataButtonAction(sender: UIButton!) {
        UIView.transition(from: self.view, to: tabBarController!.viewControllers![2].view, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
         tabBarController!.selectedIndex = 2
    }
    
    func addGenericStrainData() {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewRow", for: indexPath)
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
        if categories.count == 0 {
            tableView.backgroundColor = .white
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
            noDataLabel.text          = "You haven't recorded any smoking experiences yet"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            
            let noDataButton: UIButton = UIButton(frame: CGRect(x: 0, y: 26, width: tableView.bounds.size.width, height: 20))
            noDataButton.setTitle("Add an Activity", for: .normal)
            noDataButton.setTitleColor(.black, for: .normal)
            noDataButton.addTarget(self, action: #selector(noDataButtonAction), for: .touchUpInside)

            tableView.addSubview(noDataLabel)
            tableView.addSubview(noDataButton)
            addGenericStrainData()
        }
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
    ///heightForHeaderInSection
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    ///willDisplay cell forRowAt
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
        
        return cell
    }
    ///didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedStrain = strains[collectionView.tag][indexPath.row].uppercased().replacingOccurrences(of: "_", with: " ")
        self.performSegue(withIdentifier: "goToStrainDetails", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let itemHeight = collectionView.bounds.height
        let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let top = collectionViewFlowLayout?.sectionInset.top ?? 0
        let bottom = collectionViewFlowLayout?.sectionInset.bottom ?? 0
        let label = UILabel(frame: CGRect(x: 10, y: itemHeight - (top + bottom + 50 + 20), width: 130, height: 50))
        let labelText = strains[collectionView.tag][indexPath.row].uppercased()
        label.text = labelText.replacingOccurrences(of: "_", with: " ")
        label.textAlignment = .center
        label.font = UIFont(name: "Arvo-Bold", size: 13)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.numberOfLines = 0 // = any number of lines
        label.baselineAdjustment = .alignCenters
        label.lineBreakMode = .byWordWrapping
        cell.contentView.addSubview(label)
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
        return CGSize(width: 150, height: itemHeight - (top + bottom))
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
