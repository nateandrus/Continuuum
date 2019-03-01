//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Nathan Andrus on 2/27/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {

    var postLanding: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func commentButtonTapped(_ sender: Any) {
        alertController()
    }
    
    func alertController() {
        let alert = UIAlertController(title: "New Comment", message: "What're you thinking?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Comment here..."
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let commentAction = UIAlertAction(title: "Add Comment", style: .default) { (_) in
            guard let commentText = alert.textFields?.first?.text, !commentText.isEmpty,
                let post = self.postLanding else { return }
            PostController.shared.addComment(text: commentText, post: post, completion: { (comment) in
            })
            
            self.tableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(commentAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func followPostButtonTapped(_ sender: Any) {
    }
    
    func updateViews() {
        guard let post = postLanding else { return }
        photoImageView.image = post.photo
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postLanding?.comments.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let commentToPost = postLanding?.comments[indexPath.row]
        cell.textLabel?.text = commentToPost?.text
        cell.detailTextLabel?.text = commentToPost?.timestamp.stringWith(dateStyle: .medium, timeStyle: .medium)
        return cell
    }
}
