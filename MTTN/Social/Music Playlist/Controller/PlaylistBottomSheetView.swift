import UIKit
import FittedSheets
import ShimmerSwift
import SDWebImage
import SafariServices

class playlistViewC: UIViewController {

    let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    
    var s:String = ""
    var a:String = ""
    var y:String = ""

    let uiview = UIView()

    var header : UILabel = {
        let label = UILabel()
        label.text = "Choose the platform to play from"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
   
    lazy var spotifybutton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "Spotify"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.sizeToFit()
        button.addTarget(self, action: #selector(spotifyButtonPressed), for: .touchUpInside)
        return button
    }()
   
//    lazy var applemusicbutton : UIButton = {
//        let button = UIButton()
//        button.clipsToBounds = true
//        button.setImage(UIImage(named: "AppleMusic"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFill
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.sizeToFit()
//        button.addTarget(self, action: #selector(appleButtonPressed), for: .touchUpInside)
//        return button
//    }()
   
    lazy var youtubemusicbutton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "YoutubeMusic"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.sizeToFit()
        button.addTarget(self, action: #selector(youtubeButtonPressed), for: .touchUpInside)
        return button
    }()
    

 override func viewDidLoad() {
        super.viewDidLoad()
    
    view.backgroundColor = .black
    view.addSubview(uiview)
    uiview.backgroundColor = .clear
    view.bringSubviewToFront(uiview)
    self.view.addSubview(shimmerView)

    let name : UILabel = {
        let name = UILabel(frame: shimmerView.frame)
        name.text = "Playlist Portal"
        name.textColor = .white
        name.font = .boldSystemFont(ofSize: 25)
        name.textAlignment = .center
        name.translatesAutoresizingMaskIntoConstraints = false
        shimmerView.contentView = name
        shimmerView.isShimmering = true
        shimmerView.shimmerSpeed = 410
        shimmerView.shimmerPauseDuration = 0.2
        return name
    }()
    

    _ = uiview.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: view.frame.height/3)
    
    uiview.addSubview(name)
    _ = name.anchor(top: uiview.topAnchor, left: uiview.leftAnchor, bottom: nil, right: uiview.rightAnchor, topConstant: 45, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

    view.addSubview(header)
    _ = header.anchor(top: name.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)

    view.addSubview(spotifybutton)
    _ = spotifybutton.anchor(top: header.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/2-20, heightConstant: view.frame.height/12)

//    view.addSubview(applemusicbutton)
//    _ = applemusicbutton.anchor(top: header.bottomAnchor, left: spotifybutton.rightAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/3-20, heightConstant: view.frame.height/12)

    view.addSubview(youtubemusicbutton)
    _ = youtubemusicbutton.anchor(top: header.bottomAnchor, left: spotifybutton.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 16, widthConstant: view.frame.width/2-20, heightConstant: view.frame.height/12)

    }
    
    @objc func spotifyButtonPressed(){
        let url = s
        let webURL = NSURL(string: url)!
        let application = UIApplication.shared
        application.open(webURL as URL)
    }
    
    @objc func appleButtonPressed(){
        let url = a
        let webURL = NSURL(string: url)!
        let application = UIApplication.shared
        application.open(webURL as URL)
    }
    
    @objc func youtubeButtonPressed(){
        let url = y
        let webURL = NSURL(string: url)!
        let application = UIApplication.shared
        application.open(webURL as URL)
    }
    
}
    extension playlistViewC: Themed{
        
        func applyTheme(_ theme: AppTheme) {
            uiview.backgroundColor = theme.backgroundColor
        }
    }


