import UIKit

final class HomeQueriesItemCell: UITableViewCell {
    static let height = CGFloat(50)
    static let reuseIdentifier = String(describing: HomeQueriesItemCell.self)

    @IBOutlet private var titleLabel: UILabel!
    
    func fill(with suggestion: HomeQueryListItemViewModel) {
        self.titleLabel.text = suggestion.query
    }
}
