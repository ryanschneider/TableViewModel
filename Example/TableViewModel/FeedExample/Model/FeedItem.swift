//
// Created by Tunca Bergmen on 11/03/2016.
// Copyright (c) 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class FeedItem {
    var comment: String!
    var user: User!
    var time: String!

    class func initialItems() -> Array<FeedItem> {
        var data = Array<FeedItem>()

        let steve = User()
        steve.name = "Steve Jobs"
        steve.profilePicture = UIImage(named: "steve")

        let tim = User()
        tim.name = "Tim Cook"
        tim.profilePicture = UIImage(named: "tim")

        let item1 = FeedItem()
        item1.user = steve
        item1.comment = "Design is not just what it looks like and feels like. Design is how it works.\n\nBeing the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\nSometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
        item1.time = "4m"
        data.append(item1)

        let item2 = FeedItem()
        item2.user = tim
        item2.comment = "Winning has never been about making the most."
        item2.time = "3h"
        data.append(item2)

        return data
    }

    class func toBeAddedLater() -> FeedItem {
        let jony = User()
        jony.name = "Jony Ive"
        jony.profilePicture = UIImage(named: "jony")


        let item = FeedItem()
        item.user = jony
        item.comment = "If something is not good enough, stop doing it."
        item.time = "9h"

        return item
    }

    class func removableSectionItems() -> Array<FeedItem> {
        var data = Array<FeedItem>()

        let bill = User()
        bill.name = "Bill Gates"
        bill.profilePicture = UIImage(named: "bill")

        let elon = User()
        elon.name = "Elon Musk"
        elon.profilePicture = UIImage(named: "elon")

        let item1 = FeedItem()
        item1.user = bill
        item1.comment = "Success is a lousy teacher. It seduces smart people into thinking they can't lose.\n\nYour most unhappy customers are your greatest source of learning.\n\nAs we look ahead into the next century, leaders will be those who empower others."
        item1.time = "2d"
        data.append(item1)

        let item2 = FeedItem()
        item2.user = elon
        item2.comment = "Some people don't like change, but you need to embrace change if the alternative is disaster."
        item2.time = "3d"
        data.append(item2)

        return data
    }
}