//
//  Post.swift
//  Continuum
//
//  Created by Nathan Andrus on 2/27/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    
    static let typeKey = "Post"
    fileprivate static let captionKey = "caption"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let commentsKey = "comments"
    fileprivate static let photoKey = "photo"
    fileprivate static let commentCountKey = "commentCount"


    var photoData: Data?
    let timestamp: Date
    var caption: String
    var comments: [Comment]
    let recordID: CKRecord.ID
    var commentCount: Int
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(photo: UIImage, timestamp: Date = Date(), caption: String, comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int = 0) {
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
        self.recordID = recordID
        self.commentCount = commentCount
        self.photo = photo
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init?(record: CKRecord) {
        do {
            guard let caption = record[Post.captionKey] as? String,
                let timestamp = record[Post.timestampKey] as? Date,
                let photoAsset = record[Post.photoKey] as? CKAsset,
                let commentCount = record[Post.commentCountKey] as? Int
                else { return nil }
            let photoData = try Data(contentsOf: photoAsset.fileURL)
            self.caption = caption
            self.timestamp = timestamp
            self.photoData = photoData
            self.recordID = record.recordID
            self.commentCount = commentCount
            self.comments = []
        } catch {
            print("Negative Ghostrider: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.contains(searchTerm) {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm) {
                    return true
                }
            }
        }
        return false
    }
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: Post.typeKey, recordID: post.recordID)
        self.setValue(post.caption, forKey: Post.captionKey)
        self.setValue(post.imageAsset, forKey: Post.photoKey)
        self.setValue(post.timestamp, forKey: Post.timestampKey)
        self.setValue(post.commentCount, forKey: Post.commentCountKey)
    }
}
