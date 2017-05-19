//
//  FightBossViewController.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 18/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

class FightBossViewController: UIViewController {
  
  @IBOutlet weak var timerProgressView: UIProgressView!
  
  @IBOutlet weak var timerTextView: UILabel!
  
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var hpTextView: UILabel!
  
  @IBOutlet weak var monsterNameTextView: UILabel!
  
  @IBOutlet weak var monsterView: UIImageView!
  
  @IBOutlet weak var arrowView: UIImageView!
  
  var count = 0
  var readyTimeCount = 3
  var gameTimeCount = 30
  
  var monster : Monster?
  
  var player: Player?
  
  var tbvc: ParentTBViewController?
  
  var timer: Timer?
  
  var move: Int = 0
  
  let oldImage = UIImage(named: "arrow")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tbvc = self.tabBarController as? ParentTBViewController
  }
  
  override func viewWillAppear(_ animated: Bool) {
    timer?.invalidate()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    //De register
    timer?.invalidate()
    self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    self.view.isHidden = true
    
    tbvc?.monster = db.generateMonster()
    
    var monsterDetail = ""
    if let name = tbvc?.monster?.name,
      let level = tbvc?.player.level,
      let hp = tbvc?.monster?.hp{
      
      monsterDetail = "\(name)\n(lv\(level))\nhp: \(hp)\n"
    }
    
    
    initAlert("Are you ready?", monsterDetail, (tbvc?.monster?.icon)!)
  }

  func initGame(){
    self.view.isHidden = false
    //register
    self.count = 0
    self.readyTimeCount = 3
    self.gameTimeCount = 30
    
    guard let monster = tbvc?.monster else { return }
    
    move = getNextMove()
    arrowView.image = rotate(oldImage: oldImage!, deg: CGFloat(move * 90))
    
    monsterView.image = monster.icon
    
    monsterNameTextView.text = monster.name
    
    hpTextView.text = "\(monster.hp) / \(monster.hp)"
    
    progressView.setProgress(1.0, animated: false)
    
    timerProgressView.setProgress(1.0, animated: false)
    
    timer = Timer.scheduledTimer(timeInterval: 1,
                                 target: self, selector: #selector(ready), userInfo: nil, repeats: true)
    timer?.fire()
    
    updateTimer(self.readyTimeCount, 3)

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateTimer(_ remaining: Int, _ total: Int){
    let progress = Float(remaining) / Float(total)
    timerProgressView.setProgress(progress, animated: true)
    timerTextView.text = "\(remaining)s";
  }
  
  @objc func ready(){
    self.readyTimeCount -= 1
    //Update UI
    updateTimer(self.readyTimeCount, 3)
    if(self.readyTimeCount == 0){
      timer?.invalidate()
      
      timerTextView.text = "Go!";
      
      timerProgressView.setProgress(1.0, animated: false)
      
      timer = Timer.scheduledTimer(timeInterval: 1,
                                   target: self, selector: #selector(go), userInfo: nil, repeats: true)
      timer?.fire()
      
      registerGesture()
    }
  }
  
  @objc func go(){
    self.gameTimeCount -= 1
    //Update UI
    updateTimer(self.gameTimeCount, 30)
    if(self.gameTimeCount == 0){
      timer?.invalidate()
      timer = nil
      //Force end game
      alert("Time's Up!", "Please find a better weapon.", UIImage(named: "egg")!)
    }
  }

  func getNextMove() -> Int {
    return db.getRandomInt(4)
  }
  
  func registerGesture(){
    // Swipe Motion
    let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
    for direction in directions {
      let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
      gesture.direction = direction
      self.view.addGestureRecognizer(gesture)
    }
  }
  
  func rotate(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
    //Calculate the size of the rotated view's containing box for our drawing space
    let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
    let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
    rotatedViewBox.transform = t
    let rotatedSize: CGSize = rotatedViewBox.frame.size
    //Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize)
    let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    //Rotate the image context
    bitmap.rotate(by: (degrees * CGFloat.pi / 180))
    //Now, draw the rotated/scaled image into the context
    bitmap.scaleBy(x: 1.0, y: -1.0)
    bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    var swiped = 4
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.up:
        print("Swiped up")
        swiped = 0
      case UISwipeGestureRecognizerDirection.right:
        print("Swiped right")
        swiped = 1
      case UISwipeGestureRecognizerDirection.down:
        print("Swiped down")
        swiped = 2
      case UISwipeGestureRecognizerDirection.left:
        print("Swiped left")
        swiped = 3
      
      default:
        break
      }
    }
    
    if(swiped == move){
      self.count = self.count + 1
      //print ("shaking \(self.count)")
      
      let hp = Float((self.tbvc?.monster?.hp)!)
      
      let remaining = (hp - Float(self.count * (self.tbvc?.player.dmg)!)) / hp
      
      self.hpTextView.text = "\((hp - Float(self.count * (self.tbvc?.player.dmg)!))) / \(hp)"
      
      self.progressView.setProgress(remaining, animated: true)
      
      if(remaining <= 0){
        self.playerWon()
        return
      }

      //Next Move
      move = getNextMove()
      arrowView.image = rotate(oldImage: oldImage!, deg: CGFloat(move * 90))
    }
  }
  
  func playerWon() {
    self.tbvc?.player.levelUp()
    
    self.alert("Congrats", "Your level is lv\(String(describing: self.tbvc?.player.level))", UIImage(named: "success")!)
    
  }
  
  func alert(_ title: String, _ message: String, _ image: UIImage){
    let detailAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let imageView = UIImageView(frame: CGRect(x: 2, y: 2, width: 20, height: 20))
    imageView.image = image
    detailAlert.view.addSubview(imageView)
    
    detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      (alert: UIAlertAction!) in
      //Back to Main Page
      self.tbvc?.selectedIndex = 0
    }))
    self.present(detailAlert, animated: true, completion: nil)
  }
  
  func initAlert(_ title: String, _ message: String, _ image: UIImage){
    let detailAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    
    
    detailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
      (alert: UIAlertAction!) in
      //Back to Main Page
      self.tbvc?.selectedIndex = 0
    }))
    
    detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      (alert: UIAlertAction!) in
      //Back to Main Page
      self.initGame()
    }))
    
    self.present(detailAlert, animated: true, completion: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
