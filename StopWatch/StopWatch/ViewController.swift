//
//  ViewController.swift
//  StopWatch
//
//  Created by Shubham Vinod Kamdi on 21/09/19.
//  Copyright © 2019 Shubham Vinod Kamdi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lapTableView: UITableView!
    @IBOutlet weak var hrsLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    var sec: Int = 0
    var pauseSec: Int = 0
    
    var time: Timer!
    var lap: Array <lapDS>!
    var fromPause: Bool = false
    var fromLap: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        time = Timer()
        lap = []
        self.hrsLabel.text = "0"
        self.minLabel.text = "0"
        self.secLabel.text = "0"
        
        self.lapTableView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startTimer(_ sender: UIButton!){
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(run)), userInfo: false, repeats: true)
    }

    @IBAction func stopTimer(_ sender: UIButton!){
        fromPause = false
        self.time.invalidate()
        sec = 0
        self.hrsLabel.text = "0"
        self.minLabel.text = "0"
        self.secLabel.text = "0"
    }
    
    @IBAction func pauseTimer(_ sender: UIButton){
        pauseSec = self.sec
        self.time.invalidate()
        fromPause = true
    }
    
    @IBAction func lapTimer(_ sender: UIButton){
        
        fromLap = true
        formattingTime(seconds: self.sec)
        
        
    }
    
    @objc func run(){
        
        if fromPause{
            
            sec = pauseSec
            sec += 1
            fromPause = false
            
        }else{
            
            self.sec += 1
            
        }
        
        formattingTime(seconds: sec)
        
    }
    
    func formattingTime(seconds: Int){
        
        let hrs = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        let sec = Int(seconds) % 60

        
        if fromLap{
            
            self.lap.append(lapDS(time: String(format:"%02i:%02i:%02i", hrs, minutes, sec)))
            lapTableView.delegate = self
            lapTableView.dataSource = self
            lapTableView.reloadData()
            fromLap = false
            
        }else{
           
            self.hrsLabel.text = "\(hrs)"
            self.minLabel.text = "\(minutes)"
            self.secLabel.text = "\(sec)"
            
        }
        
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapCell") as! LapCell
        cell.timerLabel.text = "\(indexPath.row + 1)." + "  " + lap[indexPath.row].time
        return cell
        
    }
    
    
}

class LapCell: UITableViewCell{
    @IBOutlet weak var timerLabel: UILabel!
}

struct lapDS{
    var time: String!
    
    init(time: String!){
        self.time = time
    }

}
