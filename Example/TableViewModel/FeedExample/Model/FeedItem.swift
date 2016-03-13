/*

Copyright (c) 2016 Tunca Bergmen <tunca@bergmen.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

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