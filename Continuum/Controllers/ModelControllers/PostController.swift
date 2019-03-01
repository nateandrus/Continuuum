//
//  PostController.swift
//  Continuum
//
//  Created by Nathan Andrus on 2/27/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        let record = CKRecord(comment: comment)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error saving comment to cloud: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let record = record else { completion(nil); return }
            let comment = Comment(record: record, post: post)
            completion(comment)
        }
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let newPost = Post(photo: image, caption: caption)
        posts.append(newPost)
        let record = CKRecord(post: newPost)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("error creating post in the public data base: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let record = record,
                let post = Post(record: record) else { completion(nil); return}
                completion(post)
        }
    }
    
    func fetchPost(completion: @escaping ([Post]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Post.typeKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            let posts = records.compactMap({ Post(record: $0 )})
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping ([Comment]?) -> Void) {
        let postReference = post.recordID
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [Comment.postReferenceKey, postReference])
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: Comment.typeKey, predicate: compoundPredicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            let comments = records.compactMap({ Comment(record: $0, post: post)})
            completion(comments)
        }
    }
    
}
