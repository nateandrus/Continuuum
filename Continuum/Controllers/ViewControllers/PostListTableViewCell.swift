//
//  PostListTableViewCell.swift
//  Continuum
//
//  Created by Nathan Andrus on 2/27/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var postLanding: Post? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let newPost = postLanding else { return }
        postImage.image = newPost.photo
        captionLabel.text = newPost.caption
        commentCountLabel.text = "Comments: \(postLanding?.comments.count ?? 0)"
    }
    
    
    
    
    
    
}
