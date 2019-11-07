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
    var userEffects = [String]()
    var userEffectsWithRelatedStrains = [[String]]()
    var selectedStrain: String = ""
    
    var randomEffects = [String]()
    var randomEffectsWithRelatedStrains = [[String]]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure the user is signed in
        if Switcher.getUserDefaultsIsSignIn() {
           modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
        }
        
        // Connect to Realtime Database
        ref = Database.database().reference()
                
        // Get random Cannabis effects and strains with those effects if the
        // user doesn't have any data
        for (key, value) in Constants.StrainEffects.effectsDict {
            randomEffects.append(key)
            randomEffectsWithRelatedStrains.append(value)
        }

        // Register our custom cell to our table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        // Get User's Strain Data
        // Save data to populate table view and collection View
        Network.getUserStrainData(userID: modelController.person.id) { (userInfo) in
            
            var info = userInfo
            
            // First look for the Favorites
            for (category, strains) in userInfo {
                if (category == "favorite") {
                    self.userEffects.append(category + "s")
                    self.userEffectsWithRelatedStrains.append(strains)
                    info.removeValue(forKey: "favorite")
                }
            }
            
            // Then add the rest
            for (category, strains) in info {
                self.userEffects.append(category)
                self.userEffectsWithRelatedStrains.append(strains)
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
        UIView.transition(from: self.view, to: tabBarController!.viewControllers![1].view, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
         tabBarController!.selectedIndex = 1
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
        
        // if the section matches usereffects.count, then display the message
        if indexPath.section == userEffects.count {
            tableView.backgroundColor = .white
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
            noDataLabel.text          = "You haven't recorded any smoking experiences yet"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center

            //let noDataButton: UIButton = UIButton(frame: CGRect(x: 0, y: 26, width: tableView.bounds.size.width, height: 20))
            let noDataButton: UIButton = UIButton()
            noDataButton.setTitle("Add an Activity", for: .normal)
            noDataButton.sizeToFit()
            noDataButton.center = CGPoint(x: tableView.bounds.size.width / 2, y: Constants.TableView.noDataHeight / 2)
            noDataButton.setTitleColor(.black, for: .normal)
            noDataButton.layer.borderColor = UIColor.red.cgColor
            noDataButton.layer.borderWidth = 1.0
            noDataButton.addTarget(self, action: #selector(noDataButtonAction), for: .touchUpInside)

            let suggestionLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: Constants.TableView.noDataHeight - (Constants.TableView.noDataHeight / 4), width: tableView.bounds.size.width, height: 20))
            suggestionLabel.text          = "Here are some Strains that help with certain issues"
            suggestionLabel.textColor     = UIColor.black
            suggestionLabel.textAlignment = .center
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            cell.addSubview(noDataLabel)
            cell.addSubview(noDataButton)
            cell.addSubview(suggestionLabel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewRow", for: indexPath)
            return cell
        }
        
    }
    ///heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // If we are showing the message that there is no more user recorded activity to show...
        if indexPath.section == userEffects.count {
            return Constants.TableView.noDataHeight
        }
        // Else if there is either user activity or random activity,
        else if (indexPath.section == 0) {
            return Constants.TableView.favoritesHeight
        }
        // Else we are on any other row
        else {
            return Constants.TableView.rowHeight
        }
    }
    ///numberOfSectionsInTableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    ///viewForHeaderInSection
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        
        // If we are showing the message that there is no more user recorded activity to show...
        if section == userEffects.count {
            return view
        }
        // Else show a custom header
        else {
            let label = UILabel(frame: CGRect(x: 16, y: 10, width: tableView.bounds.width, height: 30))
            if (section >= userEffects.count) {
                label.text = randomEffects[section]
            } else {
                label.text = userEffects[section].uppercased()
            }
            label.font = UIFont(name: "Arvo-Italic", size: 17)
            label.textColor = .black
            
            view.addSubview(label)
            return view
        }
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
    ///didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//////////////////////////////////////////////
///Collection View Methods
//////////////////////////////////////////////
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    ///numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        // If the user hasn't recorded any activity, show cells with random strains
        if collectionView.tag >= userEffectsWithRelatedStrains.count {
            return randomEffectsWithRelatedStrains[collectionView.tag].count
        }
        // If the user has recorded activity, show all the activity, plus one more cell to give an option of adding more
        else {
            return userEffectsWithRelatedStrains[collectionView.tag].count + 1
        }
        
    }
    ///cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // If the user has recorded activity, but we are currently have no more to show,
        // use a different background to show this
        if (collectionView.tag < userEffectsWithRelatedStrains.count && indexPath.row >= userEffectsWithRelatedStrains[collectionView.tag].count) {
            cell.backgroundView = nil
            cell.layer.backgroundColor = UIColor.gray.cgColor
        }
        // Else show a picture as the background
        else {
            cell.backgroundView = UIImageView(image: UIImage(named: "weed_background.png"))
        }
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 20.0
        cell.layer.shadowOpacity = 0.9
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        return cell
    }
    ///didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // If we are at the last cell in the row, it has a prompt to add more activity, so we transition to that tab
        if (collectionView.tag < userEffectsWithRelatedStrains.count) && (indexPath.row >= userEffectsWithRelatedStrains[collectionView.tag].count) {
            UIView.transition(from: self.view, to: tabBarController!.viewControllers![1].view, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
            tabBarController!.selectedIndex = 1
        }
        // Else if we are at the user's data, segue to the strain details VC with that strain
        else if userEffectsWithRelatedStrains.count > 0 && collectionView.tag < userEffectsWithRelatedStrains.count {
            // Using random strains instead of the user's data
            selectedStrain = userEffectsWithRelatedStrains[collectionView.tag][indexPath.row].uppercased().replacingOccurrences(of: "_", with: " ")
            self.performSegue(withIdentifier: "goToStrainDetails", sender: self)
        }
        // Else we should send data from our random effets to the strain details VC
        else {
            selectedStrain = randomEffectsWithRelatedStrains[collectionView.tag][indexPath.row].uppercased().replacingOccurrences(of: "_", with: " ")
            selectedStrain = selectedStrain.replacingOccurrences(of: ".", with: " ")
            selectedStrain = selectedStrain.replacingOccurrences(of: "#", with: " ")
            selectedStrain = selectedStrain.replacingOccurrences(of: "$", with: " ")
            selectedStrain = selectedStrain.replacingOccurrences(of: "[", with: " ")
            selectedStrain = selectedStrain.replacingOccurrences(of: "]", with: " ")
            self.performSegue(withIdentifier: "goToStrainDetails", sender: self)
        }
        
    }
    ///willDisplayCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let itemHeight = collectionView.bounds.height
        //let itemWidth = collectionView.bounds.width
        let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let top = collectionViewFlowLayout?.sectionInset.top ?? 0
        let bottom = collectionViewFlowLayout?.sectionInset.bottom ?? 0
        var label = UILabel(frame: CGRect(x: 10, y: itemHeight - (top + bottom + 50 + 20), width: 130, height: 50))
        var labelText = ""
        
        label.font = UIFont(name: "Arvo-Bold", size: 13)
        label.adjustsFontSizeToFitWidth = true
        
        
        // If the user has recorded activity and we are currently at a row where they have activity stored
        if (userEffectsWithRelatedStrains.count > 0 && collectionView.tag <= userEffectsWithRelatedStrains.count - 1) {
            // And we are at a column where they have activity stored, Then use their activity for the Label Text
            if (indexPath.row < userEffectsWithRelatedStrains[collectionView.tag].count) {
                labelText = userEffectsWithRelatedStrains[collectionView.tag][indexPath.row].uppercased()
            }
            // Else if they have recorded activity but we have already shown all strains for that effect,
            // Show a different message to indicate this
            else if (indexPath.row >= userEffectsWithRelatedStrains[collectionView.tag].count) {
                label = UILabel(frame: CGRect(x: 10, y: 10, width: 130, height: itemHeight-20))
                label.font = UIFont(name: "Arvo-Bold", size: 50)
                label.minimumScaleFactor = 1
                labelText = "+"
            }
        }
        // Else Show data from random effects
        else {
            labelText = randomEffectsWithRelatedStrains[collectionView.tag][indexPath.row]
        }
        
        label.text = labelText.replacingOccurrences(of: "_", with: " ")
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
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
