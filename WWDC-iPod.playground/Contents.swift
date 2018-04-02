//: Playground - noun: a place where people can play
import UIKit
import XCPlayground
import PlaygroundSupport
import AVFoundation


let fontURL = Bundle.main.url(forResource: "ChicagoRegular", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

let playImage = UIImage(named: "play.png")
let rewindImage = UIImage(named: "rewind.png")
let forwardImage = UIImage(named: "forward.png")
let batteryImage = UIImage(named: "battery.png")

struct Song {
    var songURL : URL
    var title : String
    var artist : String
    var album : String
    
    init(songURL : URL, title: String, artist : String, album : String) {
        self.songURL = songURL
        self.title = title
        self.artist = artist
        self.album = album
    }
}

// MARK: - ADD SONGS MP3 FORMAT
let songURL = Bundle.main.url(forResource: "Vida-La-Vida", withExtension: "mp3")
let song = Song(songURL: songURL!, title: "Viva La Vida", artist: "ColdPlay", album: "Viva La Vida")
var player = try? AVAudioPlayer(contentsOf: songURL!)
var isPlaying = false
let playlist = [song]

protocol CircleControlDelegate {
    func menu()
    func back()
    func play()
    func foward()
}

// MARK: - CIRCLE CONTROL
class CircleControl: UIView {
    
    var menu : UIButton!
    var play : UIButton!
    var back : UIButton!
    var forward : UIButton!
    
    var circleControlDelegate : CircleControlDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 150.0, height: 150.0))
        circle.backgroundColor = UIColor.lightGray
        circle.layer.cornerRadius = 75
        self.addSubview(circle)
        
        
        menu = UIButton(frame: CGRect(x: 20, y: 30, width: 50, height: 20))
        menu.backgroundColor = UIColor.clear
        menu.setTitle("Menu", for: .normal)
        menu.titleLabel?.font = UIFont(name: "Chicago", size: 10)
        menu.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
        menu.center = CGPoint(x:circle.bounds.midX,
                              y:10)
        
        play = UIButton(type: .custom)
        play.frame = CGRect(x: 0, y: 0, width: 13, height: 7)
        play.setBackgroundImage(playImage, for: .normal)
        play.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        play.center = CGPoint(x:circle.bounds.midX,
                              y:circle.bounds.maxY - 10)
        
        back = UIButton(type: .custom)
        back.frame = CGRect(x: 0, y: 0, width: 13, height: 7)
    back.setBackgroundImage(rewindImage, for: .normal)
        back.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        back.center = CGPoint(x:circle.bounds.minX + 15,
                              y:circle.bounds.midY)
        
        
        forward = UIButton(type: .custom)
        forward.frame = CGRect(x: 0, y: 0, width: 13, height: 7)
        forward.setBackgroundImage(forwardImage, for: .normal)
        forward.addTarget(self, action: #selector(forwardPressed), for: .touchUpInside)
        forward.center = CGPoint(x:circle.bounds.maxX - 15,
                                 y:circle.bounds.midY)
        circle.addSubview(menu)
        circle.addSubview(play)
        circle.addSubview(back)
        circle.addSubview(forward)
        
        let smallCircle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        smallCircle.center = CGPoint(x:circle.bounds.midX,
                                     y: circle.bounds.midY);
        smallCircle.backgroundColor = UIColor.white
        smallCircle.layer.cornerRadius = 24
        circle.addSubview(smallCircle)
    }
    
    // MARK: - Delegate Functions
    @objc func menuPressed() {
        circleControlDelegate.menu()
    }
    
    @objc func playPressed() {
        circleControlDelegate.play()
    }
    
    @objc func backPressed() {
        circleControlDelegate.back()
    }
    
    @objc func forwardPressed() {
        circleControlDelegate.foward()
    }
}

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
        label.font = UIFont(name: "Chicago", size: 10)
        label.center = CGPoint(x:containerView.bounds.midX,
                               y: containerView.bounds.midY);
        
        let batteryView = UIImageView(image: batteryImage)
        batteryView.frame = CGRect(x: 0, y: 0, width: 17, height: 9)
        batteryView.center = CGPoint(x:containerView.bounds.maxX - 20,
                                     y: containerView.bounds.midY);
        
        containerView.addSubview(label)
        containerView.addSubview(batteryView)
        self.addSubview(containerView)
    }
}



class Screen : UIView, UITableViewDelegate, UITableViewDataSource  {

    var mainMenu = ["Music", "Extras", "Settings", "Shuffle Songs", "Backlight"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        self.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
        tableView.bounces = false
        tableView.layer.cornerRadius = 10
        tableView.isPagingEnabled = true
        tableView.separatorStyle = .none
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let musicScreen = MusicScreen(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
            tableView.removeFromSuperview()
            self.insertSubview(musicScreen, at: 0)
        case 1:
            print("Select 1")
        case 2:
            print("Select 2")
        case 3:
            print("Select 3")
        case 4:
            print("Select 4")
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        let title = mainMenu[indexPath.row]

        cell.textLabel?.font = UIFont(name: "Chicago", size: 10)
        cell.textLabel?.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ScreenHeader(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        return header
    }
}

protocol MusicScreenDelegate {
    func getCurrentSong(song: Song)
}
class MusicScreen : UIView, UITableViewDelegate, UITableViewDataSource {
    
    var musicScreenDelegate : MusicScreenDelegate!
    
    var currentSong: Song?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        self.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
        tableView.bounces = false
        tableView.layer.cornerRadius = 10
        tableView.isPagingEnabled = true
        tableView.separatorStyle = .none
        tableView.bounces = false
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicScreen = SongScreen(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
        playSong(song: song.songURL)
        tableView.removeFromSuperview()
        self.insertSubview(musicScreen, at: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        let title = playlist[0].title
        cell.textLabel?.font = UIFont(name: "Chicago", size: 10)
        cell.textLabel?.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ScreenHeader(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        return header
    }
    
    // MARK: - HELPERS
    func playSong(song:URL){
        player = try? AVAudioPlayer(contentsOf: song)
        player?.prepareToPlay()
        isPlaying = true
        player?.play()
    }
}

class SongScreen : UIView {
    
    var songName : UILabel!
    var artistName : UILabel!
    var albumName : UILabel!
    var songZeroLength : UILabel!
    var songLength : UILabel!
    var currentSong: Song?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentSong = song
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
        containerView.center = CGPoint(x:self.bounds.midX,
                                       y: self.bounds.midY);
        containerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        containerView.layer.cornerRadius = 10
        
        let header = ScreenHeader(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        header.center = CGPoint(x:containerView.bounds.midX,
                                       y: containerView.bounds.minY + 10);
        containerView.addSubview(header)
        
        songName = UILabel(frame:CGRect(x: 0, y: 0, width: 150, height: 20))
        songName.text = song.title
        songName.textAlignment = .center
        songName.font = UIFont(name: "Chicago", size: 10)
        songName.center = CGPoint(x:containerView.bounds.midX,
                               y: containerView.bounds.midY - 15);
        containerView.addSubview(songName)
        
        artistName = UILabel(frame:CGRect(x: 0, y: 0, width: 150, height: 20))
        artistName.text = song.artist
        artistName.textAlignment = .center
        artistName.font = UIFont(name: "Chicago", size: 10)
        artistName.center = CGPoint(x:containerView.bounds.midX,
                                  y: containerView.bounds.midY);
        containerView.addSubview(artistName)
        
        albumName = UILabel(frame:CGRect(x: 0, y: 0, width: 150, height: 20))
        albumName.text = song.album
        albumName.textAlignment = .center
        albumName.font = UIFont(name: "Chicago", size: 10)
        albumName.center = CGPoint(x:containerView.bounds.midX,
                                    y: containerView.bounds.midY + 15);
        containerView.addSubview(albumName)
        
        self.addSubview(containerView)
    }
}

class iPOD : UIView, CircleControlDelegate {
    
// MARK: - iPOD SETUP
    
    var background : UIView!
    var screenView : Screen!
    var circleControl : CircleControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        background = UIView(frame: CGRect(x: 0.0, y: 0, width: 220.0, height: 350.0))
        background.backgroundColor = UIColor.white
        background.layer.cornerRadius = 10
        background.layer.masksToBounds = false
        background.clipsToBounds = true
    
        screenView = Screen(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
        screenView.center = CGPoint(x: background.bounds.midX, y: background.bounds.midY - 100)
        
        circleControl = CircleControl(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        circleControl.center = CGPoint(x:background.bounds.midX,
                                       y: background.bounds.midY + 65);
        circleControl.circleControlDelegate = self
        
        background.addSubview(screenView)
        background.addSubview(circleControl)
        self.addSubview(background)
    }
    
    func menu() {
        let arrOfSub = self.screenView.subviews
        print("Number of Subviews: \(arrOfSub.count)")
        for item in arrOfSub {
            if item.isKind(of: MusicScreen.self) {
                item.removeFromSuperview()
                screenView = Screen(frame: CGRect(x: 0, y: 0, width: 150, height: 125))
                screenView.center = CGPoint(x: background.bounds.midX, y: background.bounds.midY - 100)
                background.addSubview(screenView)
            }
        }
    }
    
    func back() {
        
    }
    
    func play() {
        if isPlaying == false {
            player?.play()
            isPlaying = true
        } else {
            player?.stop()
            isPlaying = false
        }
    }
    
    func foward() {
        
    }
}


let ipod = iPOD(frame: CGRect(x: 0, y: 0, width: 220.0, height: 350.0))

//UIView.animate(withDuration: 3.0, animations: { () -> Void in
//
//        let scaleTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)
//
//        ipod.transform = scaleTransform
//
//        let rotationTransform = CGAffineTransform(rotationAngle: 3.14)
//
//        ipod.transform = rotationTransform
//    })

UIView.animate(withDuration: 1.5) { () -> Void in
    let scaleTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)

    ipod.transform = scaleTransform
    ipod.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
}

UIView.animate(withDuration: 1.5, delay: 0.20, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
    ipod.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
}, completion: nil)


PlaygroundPage.current.liveView = ipod
PlaygroundPage.current.needsIndefiniteExecution = true
