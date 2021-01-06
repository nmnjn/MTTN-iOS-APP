import UIKit

class TwitterCell: UICollectionViewCell{
    
    var tweetView: UIView = {
        let view = UIView()
//            view.backgroundColor = UIColor(red: 130, green: 130, blue: 130)
    //        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        return view
    }()
     
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "DarkAppIcon")
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 34, height: 34)
        iv.layer.cornerRadius = 34/2
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
//        iv.backgroundColor = .white
        iv.layer.borderWidth = 0.5
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@manipalthetalk"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
//        label.textColor = .black
        return label
    }()
    
    lazy var mttnLabel: UILabel = {
        let label = UILabel()
        label.text = "MTTN"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
//        label.textColor = .black
        return label
    }()
    
    lazy var tweetlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "blah blahbkahbckah dlkjgkgj khgjgjh gjhbksd jgjhg jhg jhg gjgjhg jhgj jhg jhgj jgjh gjgh jjfjhj jhg jhjh khgjhk kghkhgc khgfkgh khg kgh khgfhghg gf hgf hgfghfhgf fhg fhg hg hg "
        label.numberOfLines = 0
        label.textAlignment = .left
//        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        
        addSubview(tweetView)
        _ = tweetView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0 , heightConstant: 0)
        
        tweetView.addSubview(profileImageView)
        tweetView.addSubview(usernameLabel)
        tweetView.addSubview(mttnLabel)
        
        _ = profileImageView.anchor(top: tweetView.topAnchor, left: tweetView.leftAnchor, bottom: nil, right: nil, topConstant: 6, leftConstant: 8, bottomConstant: 0, rightConstant: 0)
        
        _ = mttnLabel.anchor(top: tweetView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8, heightConstant: 14)
        
        _ = usernameLabel.anchor(top: mttnLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 8, heightConstant: 14)
        
        tweetView.addSubview(tweetlabel)
        
        _ = tweetlabel.anchor(top: profileImageView.bottomAnchor, left: tweetView.leftAnchor, bottom: tweetView.bottomAnchor, right: tweetView.rightAnchor, topConstant: 1, leftConstant: 8, bottomConstant: 2, rightConstant: 8)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    extension TwitterCell: Themed {
        
        func applyTheme(_ theme: AppTheme) {
            tweetView.backgroundColor = theme.cellHighlightColor
            tweetlabel.textColor = theme.titleTextColor
            usernameLabel.textColor = theme.titleTextColor
            mttnLabel.textColor = theme.titleTextColor
        }
    
}
