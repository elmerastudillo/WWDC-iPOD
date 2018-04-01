//: Playground - noun: a place where people can play
import UIKit
import XCPlayground
import PlaygroundSupport

let fontURL = Bundle.main.url(forResource: "ChicagoRegular", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

class ScreenHeader : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        containerView.center = CGPoint(x:self.bounds.midX,
                                       y: self.bounds.midY);
        let label = UILabel(frame:CGRect(x: 0, y: 0, width: 150, height: 20))
        label.text = "iPod"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.center = CGPoint(x:containerView.bounds.midX,
                               y: containerView.bounds.midY);
        containerView.addSubview(label)
        
        self.addSubview(containerView)
    }
}

class Screen : UIView, UITableViewDelegate, UITableViewDataSource {
    
    var items : [Any]?
    var mainMenu = ["Music", "Extras", "Settings", "Shuffle Songs", "Backlight"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
        tableView.bounces = false
        tableView.backgroundColor = .white
        tableView.isPagingEnabled = true
        tableView.separatorStyle = .none
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = mainMenu[indexPath.row]

        cell.textLabel?.font = UIFont(name: "Chicago", size: 10)
        cell.textLabel?.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ScreenHeader(frame: CGRect(x: 0, y: 0, width: 150, height: 15))
        return header
    }
}

let background = UIView(frame: CGRect(x: 0.0, y: 0, width: 220.0, height: 350.0))
background.backgroundColor = UIColor.white
background.layer.cornerRadius = 10
background.layer.masksToBounds = false
background.clipsToBounds = true
PlaygroundPage.current.liveView = background
PlaygroundPage.current.needsIndefiniteExecution = true

let circle = UIView(frame: CGRect(x: 0, y: 0, width: 150.0, height: 150.0))
circle.center = CGPoint(x:background.bounds.midX,
                                y: background.bounds.midY + 65);
circle.backgroundColor = UIColor.lightGray
circle.layer.cornerRadius = 75
background.addSubview(circle)

let smallCircle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
smallCircle.center = CGPoint(x:circle.bounds.midX,
                        y: circle.bounds.midY);
smallCircle.backgroundColor = UIColor.white
smallCircle.layer.cornerRadius = 24
circle.addSubview(smallCircle)

let screenView = Screen(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
screenView.center = CGPoint(x: background.bounds.midX, y: background.bounds.midY - 100)

background.addSubview(screenView)


//let screenView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
//screenView.center = CGPoint(x: background.bounds.midX, y: background.bounds.midY - 100)
//screenView.backgroundColor = UIColor.blue
//screenView.layer.cornerRadius = 10
//background.addSubview(screenView)





//let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
//PlaygroundPage.current.liveView = containerView
//PlaygroundPage.current.needsIndefiniteExecution = true
//
//let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
//circle.center = containerView.center
//circle.layer.cornerRadius = 25.0
//
//let startingColor = UIColor(red: (253.0/255.0), green: (159.0/255.0), blue: (47.0/255.0), alpha: 1.0)
//circle.backgroundColor = startingColor
//
//containerView.addSubview(circle);
//
//let rectangle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
//rectangle.center = containerView.center
//rectangle.layer.cornerRadius = 5.0
//
//rectangle.backgroundColor = UIColor.white
//
//containerView.addSubview(rectangle)
//
//UIView.animate(withDuration: 3.0, animations: { () -> Void in
//    let endingColor = UIColor(red: (255.0/255.0), green: (61.0/255.0), blue: (24.0/255.0), alpha: 1.0)
//    circle.backgroundColor = endingColor
//
//    let scaleTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)
//
//    circle.transform = scaleTransform
//
//    let rotationTransform = CGAffineTransform(rotationAngle: 3.14)
//
//    rectangle.transform = rotationTransform
//})
//
