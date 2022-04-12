import UIKit

class PerformanceController: UIViewController
{
    var breaksTakenPerHour : String = "0"
    var avgWatchTime : String = "0"
    
    let totalWatchtime = UserPerformance.shared.totalWatchtime/60
    let breaksTaken = UserPerformance.shared.breaksTaken
    let sessionsDone = UserPerformance.shared.sessionsDone
    let timesOvertime = UserPerformance.shared.timesOvertime
    
    @IBOutlet weak var watchText: UILabel!
    @IBOutlet weak var breaksText: UILabel!
    @IBOutlet weak var avgWatchText: UILabel!
    @IBOutlet weak var overtimeText: UILabel!
    
    @IBOutlet weak var lastWeekLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    private func loadData(){
        calculateStats()
        
        watchText.text = "\(roundDouble(x: totalWatchtime)) mins"
        breaksText.text = "\(breaksTakenPerHour) per hour"
        overtimeText.text = "\(roundDouble(x: timesOvertime)) time(s)"
        avgWatchText.text = "\(avgWatchTime) mins"
        
        let lastWeekTime = UserPerformance.shared.getLastWeekStat()
        lastWeekLabel.text = "\(roundDouble(x: lastWeekTime)) minutes"
    }
    
    private func calculateStats(){
        if totalWatchtime != 0{
            avgWatchTime = roundDouble(x:(totalWatchtime / Double(sessionsDone)))
            breaksTakenPerHour = roundDouble(x:(Double(breaksTaken) / (totalWatchtime/3600)))
        }
    }
        
    
    private func roundDouble(x: Double) -> String{
        return x == 0 ? "0" : String(format: "%.2f", x)
    }
}
