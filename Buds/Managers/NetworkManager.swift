//
//  NetworkManager.swift
//  Buds
//
//  Created by Collin Browse on 5/4/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit
import MapKit

class NetworkManager {
    
    static let shared = NetworkManager()
    let imageCache = NSCache<NSString, UIImage>()
    let placemarkCache = NSCache<NSString, CLPlacemark>()
    
    
    func downloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        if let image = imageCache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            self.imageCache.setObject(image, forKey: cacheKey)
            
            completed(image)
        }
        task.resume()
    }
    
    
    
    func getReverseGeocodeLocation(fromLocation loc: CLLocation, completed: @escaping(Result<CLPlacemark, BudsError>) -> Void) {
        
        let locationString = loc.coordinate.latitude.description + loc.coordinate.longitude.description
        let cacheKey = NSString(string: locationString)
        
        if let placemark = placemarkCache.object(forKey: cacheKey) {
            completed(.success(placemark))
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(loc) { [weak self] (placemark, error) in
            
            guard let mark = placemark?.first, error == nil, let self = self else {
                completed(.failure(.noLocationStored))
                return
            }
            
            self.placemarkCache.setObject(mark, forKey: cacheKey)
            completed(.success(mark))
        }
    }
    
}
