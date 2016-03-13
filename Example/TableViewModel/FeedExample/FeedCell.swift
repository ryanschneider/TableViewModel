/*

Created by Tunca Bergmen on 11/03/2016.

The MIT License (MIT)

Copyright (c) 2016 Tunca Bergmen

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

*/

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
