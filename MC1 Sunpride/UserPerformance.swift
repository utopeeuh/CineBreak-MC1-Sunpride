//
//  UserPerformance.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 07/04/22.
//

import Foundation

// Call by UserPerformance.shared.att
class UserPerformance{
    
    private let defaults = UserDefaults.standard
    
    private let TOTAL_WATCHTIME_KEY = "TOTAL_WATCHTIME_KEY"
    private let BREAKS_TAKEN_KEY = "BREAKS_TAKEN_KEY"
    private let SESSIONS_DONE_KEY = "SESSIONS_DONE_KEY"
    private let TIMES_OVERTIME_KEY = "TIMES_OVERTIME_KEY"
    
    // function to update last session data to current userdefaults, ran once per post-session
    func updateStatsAfterSession(){
        initStats()
        update(s: getSessions().last!)
    }
    
    //retrieve sessions, update userdefaults data from 6 days ago to today, ran everytime app is opened
    func updateWeeklyStats(){
        if initStats(){
            return
        }
        else{
            let sessions = getSessions()
            for s in sessions {
                // validate if session is in the past 7 days inc. today
                let currentDate = Date()
                var dateComponent = DateComponents()
                dateComponent.day = -6
                let sixDaysAgo = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
                
                if(s.date >= sixDaysAgo){
                    update(s: s)
                }
            }
        }
        
    }
    
    private func update(s: Session){
        totalWatchtime += s.watchTime
        breaksTaken += s.breaksTaken
        sessionsDone += 1
        if s.isOvertime {  timesOvertime += 1  }
    }
    
    private func initStats() -> Bool{
        if getSessions().isEmpty{
            totalWatchtime = 0
            breaksTaken = 0
            sessionsDone = 0
            timesOvertime = 0
            
            return true
        }
        return false
    }
    
    var totalWatchtime : Double {
        set {
            defaults.setValue(newValue, forKey: TOTAL_WATCHTIME_KEY)
        }
        get {
            return defaults.double(forKey: TOTAL_WATCHTIME_KEY)
        }
    }
    
    var breaksTaken : Int {
        set {
            defaults.setValue(newValue, forKey: BREAKS_TAKEN_KEY)
        }
        get {
            return defaults.integer(forKey: BREAKS_TAKEN_KEY)
        }
    }
    
    var sessionsDone : Int {
        set {
            defaults.setValue(newValue, forKey: SESSIONS_DONE_KEY)
        }
        get {
            return defaults.integer(forKey: BREAKS_TAKEN_KEY)
        }
    }
    
    var timesOvertime : Int {
        set {
            defaults.setValue(newValue, forKey: TIMES_OVERTIME_KEY)
        }
        get {
            return defaults.integer(forKey: TIMES_OVERTIME_KEY)
        }
    }
    
    class var shared: UserPerformance {
        struct Static {
            static let instance = UserPerformance()
        }
      
        return Static.instance
    }
    
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
   
}


