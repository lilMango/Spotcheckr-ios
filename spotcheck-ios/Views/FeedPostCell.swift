import UIKit

class FeedPostCell: UITableViewCell {
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorTaglineLabel: UILabel!
    
    @IBOutlet weak var upvoteBtn: UIImageView!
    @IBOutlet weak var upvoteCounts: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyles()
    }

    private func applyStyles() {
        postLabel.font = ApplicationScheme.instance.containerScheme.typographyScheme.headline6
        postLabel.textColor = ApplicationScheme.instance.containerScheme.colorScheme.onPrimaryColor
        
        authorNameLabel.font = ApplicationScheme.instance.containerScheme.typographyScheme.subtitle2
        authorNameLabel.textColor = ApplicationScheme.instance.containerScheme.colorScheme.onPrimaryColor
        
        upvoteCounts.font = ApplicationScheme.instance.containerScheme.typographyScheme.subtitle1
        upvoteCounts.textColor = ApplicationScheme.instance.containerScheme.colorScheme.onPrimaryColor
        
        answersLabel.font = ApplicationScheme.instance.containerScheme.typographyScheme.subtitle1
        answersLabel.textColor = ApplicationScheme.instance.containerScheme.colorScheme.onPrimaryColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
