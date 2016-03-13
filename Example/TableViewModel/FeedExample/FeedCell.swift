//
// Created by Tunca Bergmen on 11/03/2016.
// Copyright (c) 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    var cellHeight: Float = 0
    var onLike: ((FeedItem) -> ())?
    var onShare: ((FeedItem) -> ())?

    override func awakeFromNib() {
        profileImageView.layer.cornerRadius = 4
    }

    @IBAction func likeAction() {
        onLike?(feedItem)
    }

    @IBAction func shareAction() {
        onShare?(feedItem)
    }

    var feedItem: FeedItem! {
        didSet {
            nameLabel.text = feedItem.user.name
            profileImageView.image = feedItem.user.profilePicture
            timeLabel.text = feedItem.time
            commentTextView.text = feedItem.comment
            calculateCellHeight()
        }
    }

    func calculateCellHeight() {
        if let feedItem = self.feedItem {
            let baseHeight: Float = 70
            let commentViewHeight = textViewHeight(feedItem.comment, width: 256, font: UIFont.systemFontOfSize(13))
            cellHeight = baseHeight + commentViewHeight
        }
    }

    func textViewHeight(text: String, width: Float, font: UIFont) -> Float {
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        let textViewMargin: Float = 10
        let size = attributedText.boundingRectWithSize(CGSizeMake(CGFloat(width - textViewMargin), CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                context: nil)
        return Float(size.height)
    }

}
