//
//  extensions.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/01/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

// MARK: - UIImageView

let ImageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    func LoadImageUsingCache(ImageRef: String?, ImageLoadCompletion: @escaping (_ isFound: Bool) -> Void) {
        
        //If there is no image reference, return defualt
        if ImageRef == nil {
            ImageLoadCompletion(false)
            return
        }
        
        let ImageRef = ImageRef!
        
        //fixes some potential image loading problems
        let imageReference = ImageRef
        
        //First check to see if image in cache
        if let cachedImage = ImageCache.object(forKey: ImageRef as NSString) {
            self.image = cachedImage
            ImageLoadCompletion(true)
            return
        }

        //If not retrieve image
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let fileRef = storageRef.child(ImageRef)

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        fileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if error != nil {
            print("Could not find: ", fileRef)
            ImageLoadCompletion(false)
          } else {
            
            // Data for "ImageRef" is returned
            if let downloadedImage = UIImage(data: data!) {
                
                //If we still have the right image, set it
                if imageReference == ImageRef {
                    self.image = downloadedImage
                }
                
                //save to cache
                ImageCache.setObject(downloadedImage, forKey: ImageRef as NSString)
                ImageLoadCompletion(true)
            }
          }
        }
    }
}
