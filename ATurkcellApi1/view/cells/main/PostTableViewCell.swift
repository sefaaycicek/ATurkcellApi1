//
//  PostTableViewCell.swift
//  ATurkcellApi1
//
//  Created by Sefa Aycicek on 2.10.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var txtPostTitle: UILabel!
    @IBOutlet weak var txtPostBody: UILabel!
    
    func configure(with post: PostListUIModel) {
        txtPostTitle.text = post.title
        txtPostBody.text = post.body
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
