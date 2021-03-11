//
//  ExtensionUIimageView.swift
//  Recipes
//
//  Created by Antoine Antoniol on 24/02/2021.
//  Copyright © 2021 Antoine Antoniol. All rights reserved.
//
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

//  MARK: - Extension UIImageView

extension UIImageView {
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
