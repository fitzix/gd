/*====================
 
 FileName    : CalendarUtils
 Desc        : Utils Function For Calendar 天体运算部分移植自<算法的乐趣 -- 王晓华> 书中示例代码
 Author      : bugcode
 Email       : bugcoding@gmail.com
 CreateDate  : 2016-5-8
 
 ====================*/

import Foundation

open class CalendarUtils{
    
    static let shared = CalendarUtils()
    
    // 每天的时间结构
    struct WZDayTime{
        // 年月日时分秒
        var year:Int = 0
        var month:Int = 0
        var day:Int = 0
        var hour:Int = 0
        var minute:Int = 0
        var second:Double = 0
        
        init(_ y: Int, _ m: Int, _ d: Int) {
            year = y
            month = m
            day = d
        }
        public var description : String {
            return "\(year)-" + "\(month)-" + "\(day)"
        }
    }
    
    // 根据当前日期获取下一个节日
    func getNextHolidayBy(wzTime: WZDayTime) -> (String, Int) {

        let res = wzTime.month * 100 + wzTime.day
        var holidayName = ""
        var days = 0
        for key in CalendarConstant.generalHolidaysArray {
            if res < key {
                let (name, month, day) = CalendarConstant.generalHolidaysDict[key]!
                holidayName = name
                days = CalendarUtils.shared.calcDaysBetweenDate(wzTime.year, monthStart: wzTime.month, dayStart: wzTime.day, yearEnd: wzTime.year, monthEnd: month, dayEnd: day)
                break
            }
        }
        return (holidayName, days)
    }
    
    // 根据农历月与农历日获取农历节日名称，没有返回空字符串
    func getLunarFestivalNameBy(month: Int, day: Int) -> String {
        let combineStr = String(month) + "-" + String(day)
        if let festivalName = CalendarConstant.lunarHolidaysDict[combineStr] {
            return festivalName
        } else {
            return ""
        }
    }
    
    
    // 获取公历假日名称，如果不是假日返回空字符串
    func getHolidayNameBy(month: Int, day: Int) -> String {
        let combineStr = String(month) + "-" + String(day)
        
        if let holidayName = CalendarConstant.georiHolidaysDict[combineStr] {
            //print("name  = \(holidayName)")
            return holidayName
        } else {
            return ""
        }
    }
    
    // 蔡勒公式算公历某天的星期
    func getWeekDayBy(_ year:Int, month m:Int, day d:Int) -> Int {
        var year = year
        var m = m
        if m < 3 {
            year -= 1
            m += 12
        }
        
        // 年份的最后二位. 2003 -> 03 | 1997 -> 97
        let y:Int = year % 100
        // 年份的前二位. 2003 -> 20 | 1997 -> 19
        let c:Int = Int(year / 100)
        
        var week:Int = Int(c / 4) - 2 * c + y + Int(y / 4) + (26 * (m + 1) / 10) + d - 1

        week = (week % 7 + 7) % 7
        
        return week
    }
    
    // 根据当前年月日获取下个节气的序号
    func getNextJieqiNumBy(calendar: LunarCalendarUtils, month: Int, day: Int) -> Int {
        var next = 0
        var count = 0
        
        var year = calendar.getCurrentYear()
        
        var dayCount = day
        var monthCount = month
        
        // 循环到找到下一个节气为止
        while true {
            // 节气一般相差十五天左右，30天为容错，足够找到下一个节气了
            count += 1
            if count > 30 {
                break
            }
            
            // 当前的农历日期
            let mi = calendar.getMonthInfo(month: monthCount)
            let dayInfo = mi.getDayInfo(day: dayCount)
            
            // 当前日期就是节气
            if dayInfo.st != -1 {
                next = dayInfo.st
                break
            }
            // 此月份天数
            let days = getDaysBy(year: year, month: monthCount)
            dayCount += 1
            if dayCount > days {
                dayCount = 1
                monthCount += 1
                if monthCount > 12 {
                    year += 1
                    monthCount = 1
                }
            }
        }
        
        //print("getNextJieqiNum = next = \(next) termName = \(CalendarConstant.nameOfJieQi[next])")
        return next
    }
    
    // 根据当前日期获取当前所属于的节令月
    func getLunarJieqiMonthNameBy(calendar: LunarCalendarUtils, month: Int, day: Int) -> Int {
        var jieqiMonthName = 0
        
        let nextJieqi = getNextJieqiNumBy(calendar: calendar, month: month, day: day)
        
        switch nextJieqi {
        case 22 ... 23:
            jieqiMonthName = 1
        case 0 ... 1:
            jieqiMonthName = 2
        case 2 ... 3:
            jieqiMonthName = 3
        case 4 ... 5:
            jieqiMonthName = 4
        case 6 ... 7:
            jieqiMonthName = 5
        case 8 ... 9:
            jieqiMonthName = 6
        case 10 ... 11:
            jieqiMonthName = 7
        case 12 ... 13:
            jieqiMonthName = 8
        case 14 ... 15:
            jieqiMonthName = 9
        case 16 ... 17:
            jieqiMonthName = 10
        case 18 ... 19:
            jieqiMonthName = 11
        case 20 ... 21:
            jieqiMonthName = 12
        default:
            jieqiMonthName = 0
        }
        
        //print("getLunarJieqiMonthNameBy = \(jieqiMonthName)")
        return jieqiMonthName
    }
    
    
    // 通过2000年有基准获取某一农历年的干支
    func getLunarYearNameBy(_ year:Int) -> (heaven:String, earthy:String, zodiac:String){
        let baseMinus:Int = year - 2000
        
        var heavenly = (7 + baseMinus) % 10
        var earth = (5 + baseMinus) % 12
        
        if heavenly <= 0 {
            heavenly += 10
        }
        if earth <= 0 {
            earth += 12
        }
        
        return (CalendarConstant.HEAVENLY_STEMS_NAME[heavenly - 1], CalendarConstant.EARTHY_BRANCHES_NAME[earth - 1], CalendarConstant.CHINESE_ZODIC_NAME[earth - 1])
    }
    
    // 根据年，月，获取月干支
    func getLunarMonthNameBy(calendar: LunarCalendarUtils, month: Int, day: Int) -> (heaven: String, earthy: String) {

        var sbMonth:Int = 0, sbDay:Int = 0
        var year = calendar.getCurrentYear()
        // 算出农历年干支，以立春为界
        calendar.getSpringBeginDay(month: &sbMonth, day: &sbDay)
        year = (month >= sbMonth) ? year : year - 1
        

        let baseMinus:Int = year - 2000
        var heavenly = (7 + baseMinus) % 10
        
        let curJieqiMonth = CalendarUtils.shared.getLunarJieqiMonthNameBy(calendar: calendar, month: month, day: day)
        if heavenly <= 0 {
            heavenly += 10
        }
        var monthHeavenly = ((heavenly * 2) + curJieqiMonth) % 10
        if monthHeavenly <= 0 {
            monthHeavenly = 10
        }
        
        return (CalendarConstant.HEAVENLY_STEMS_NAME[monthHeavenly - 1], CalendarConstant.EARTHY_MONTH_NAME[curJieqiMonth - 1])
    }
    
    // 获取日干支
    func getLunarDayNameBy(year: Int, month: Int, day: Int) -> (heaven:String, earthy:String) {
        
        var year = year
        var month = month
        if month == 1 || month == 2 {
            month += 12
            year -= 1
        }
        
        let x = Int(year / 100)
        let y = year % 100
        
        // 日 干 计算
        let res = (5 * (x + y) + Int(x / 4) + Int(y / 4) + (month + 1) * 3 / 5 + day - 3 - x)
        var dayHeavenly = res % 10
        if dayHeavenly == 0 {
            dayHeavenly = 10
        }
        // 日 支 计算
        let i = (month % 2 != 0) ? 0 : 6
        var dayEarthy = (res + 4 * x + 10 + i) % 12
        if dayEarthy == 0 {
            dayEarthy = 12
        }
        
        return (CalendarConstant.HEAVENLY_STEMS_NAME[dayHeavenly - 1], CalendarConstant.EARTHY_BRANCHES_NAME[dayEarthy - 1])
    }
    
    
    // 平，闫年判定
    func getIsLeapBy(_ year:Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
    
    // 指定月份的天数
    func getDaysBy(year:Int, month: Int) -> Int {
        var days = 0
        if getIsLeapBy(year) {
            days = CalendarConstant.DAYS_OF_MONTH_LEAP_YEAR[month]
        }
        else{
            days = CalendarConstant.DAYS_OF_MONTH_NORMAL_YEAR[month]
        }
        return days
    }
    
    // 今天的日期
    func getDateStringOfToday() -> String {
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: nowDate)
        return dateString
    }
    
    // 根据日期字符串 yyyy-mm-dd形式获取(year,month,day)的元组
    func getYMDTuppleBy(_ dateString:String) -> (year:Int, month:Int, day:Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString)
        
        formatter.dateFormat = "yyyy"
        let y = formatter.string(from: date!)
        
        formatter.dateFormat = "MM"
        let m = formatter.string(from: date!)
        
        formatter.dateFormat = "dd"
        let d = formatter.string(from: date!)
        
        return (Int(y)!, Int(m)!, Int(d)!)
    }
    
    // 手动切分日期字符串
    func manualSplitDate(_ dateString: String) -> (year:Int, month:Int, day:Int) {
        let strArr = dateString.components(separatedBy: "-")
        let year = strArr[0]
        let month = strArr[1]
        let day = strArr[2]
        
        return (Int(year)!, Int(month)!, Int(day)!)
    }
    
    // 根据传入日期字符串获取下月
    func getMonthDateStringBy(year: Int, month: Int, step:Int) -> (year: Int, month: Int) {
        
        var year = year
        var curMonth = month
        curMonth = curMonth + step
        if curMonth > 12 && step > 0 {
            curMonth = 1
            year = year + 1
        }
        else if curMonth < 1 && step < 0{
            curMonth = 12
            year = year - 1
        }
        return (year, curMonth)
    }
    
    // 月份增减的时候保证天数不超出当月的最大天数
    func fixMonthDays(year: Int, month: Int, day: Int) -> Int {
        var retDay = day
        let days = getDaysOfMonthBy(year, month: month)
        if day > days {
            retDay = days
        }
        
        return retDay
    }
    
    // 获取某月某天是周几
    func getWeekBy(year: Int, month: Int, andFirstDay:Int) -> Int {
        let weekDay = getWeekDayBy(year, month: month, day: andFirstDay)
        
        return weekDay
    }
    
    // 获取一个月有几天
    func getDaysOfMonthBy(_ year:Int, month:Int) -> Int {
        if month < 1 || month > 12 {
            return 0
        }
        
        if getIsLeapBy(year) {
            return CalendarConstant.DAYS_OF_MONTH_LEAP_YEAR[month]
        }
        
        return CalendarConstant.DAYS_OF_MONTH_NORMAL_YEAR[month]
    }
    
    // 计算一年中过去的天数，含指定的这天
    func calcYearPassDays(_ year:Int, month:Int, day:Int) -> Int {
        var passedDays = 0
        for i in 0 ..< month - 1 {
            if getIsLeapBy(year) {
                passedDays += CalendarConstant.DAYS_OF_MONTH_LEAP_YEAR[i]
            }else{
                passedDays += CalendarConstant.DAYS_OF_MONTH_NORMAL_YEAR[i]
            }
        }
        
        passedDays += day
        
        return passedDays
    }
    
    // 计算一年剩下的天数，不含指定的这天
    func calcYearRestDays(_ year:Int, month:Int, day:Int) -> Int{
        var leftDays = 0
        if getIsLeapBy(year) {
            leftDays = CalendarConstant.DAYS_OF_MONTH_LEAP_YEAR[month] - day
        }else{
            leftDays = CalendarConstant.DAYS_OF_MONTH_NORMAL_YEAR[month] - day
        }
        
        for i in month ..< CalendarConstant.MONTHES_FOR_YEAR {
            if getIsLeapBy(year) {
                leftDays += CalendarConstant.DAYS_OF_MONTH_LEAP_YEAR[i]
            }else{
                leftDays += CalendarConstant.DAYS_OF_MONTH_NORMAL_YEAR[i]
            }
        }
        
        return leftDays
    }
    
    // 计算二个年份之间的天数 前面包含元旦，后面不包含
    func calcYearsDays(_ yearStart:Int, yearEnd:Int) -> Int {
        var days = 0
        for i in yearStart ..< yearEnd {
            if getIsLeapBy(i) {
                days += CalendarConstant.DAYS_OF_LEAP_YEAR
            }else{
                days += CalendarConstant.DAYS_OF_NORMAL_YEAR
            }
        }
        
        return days
    }
    
    // 计算二个指定日期之间的天数
    func calcDaysBetweenDate(_ yearStart:Int, monthStart:Int, dayStart:Int, yearEnd:Int, monthEnd:Int, dayEnd:Int) -> Int {
        var days = calcYearRestDays(yearStart, month: monthStart, day: dayStart)
        
        if yearStart != yearEnd {
            if yearEnd - yearStart >= 2 {
                days += calcYearsDays(yearStart + 1, yearEnd: yearEnd)
            }
            days += calcYearPassDays(yearEnd, month: monthEnd, day: dayEnd)
        }else{
            days -= calcYearRestDays(yearEnd, month: monthEnd, day: dayEnd)
        }
        
        return days
    }
    
    // 判定日期是否使用了格里历
    func isGregorianDays(_ year:Int, month:Int, day:Int) -> Bool {
        if year < CalendarConstant.GREGORIAN_CALENDAR_OPEN_YEAR {
            return false
        }
        if year == CalendarConstant.GREGORIAN_CALENDAR_OPEN_YEAR {
            if (month < CalendarConstant.GREGORIAN_CALENDAR_OPEN_MONTH)
                || (month == CalendarConstant.GREGORIAN_CALENDAR_OPEN_MONTH && day < CalendarConstant.GREGORIAN_CALENDAR_OPEN_DAY){
                return false
            }
        }
        
        return true
    }
    
    
    // 计算儒略日
    func calcJulianDay(_ year:Int, month:Int, day:Int, hour:Int, min:Int, second:Double) -> Double {
        var year = year
        var month = month
        
        if month <= 2 {
            month += 12
            year -= 1
        }
        var B = -2
        
        if isGregorianDays(year, month: month, day: day) {
            B = year / 400 - year / 100
        }
        let a = 365.25 * Double(year)
        let b = 30.6001 * Double(month + 1)
        
        let sec:Double =  Double(hour) / 24.0 + Double(min) / 1440.0 + Double(second) / 86400.0
        let param:Double = Double(Int(a)) + Double(Int(b)) + Double(B) + Double(day)
        let res = param + sec + 1720996.5
        
        return res
    }
    
    // 儒略日获得日期
    func getDayTimeFromJulianDay(_ jd:Double, dt:inout WZDayTime){
        var cna:Int, cnd:Int
        var cnf:Double
        
        let jdf:Double = jd + 0.5
        cna = Int(jdf)
        cnf = jdf - Double(cna)
        if cna > 2299161 {
            cnd = Int((Double(cna) - 1867216.25) / 36524.25)
            cna = cna + 1 + cnd - Int(cnd / 4)
        }
        cna = cna + 1524
        var year = Int((Double(cna) - 122.1) / 365.25)
        cnd = cna - Int(Double(year) * 365.25)
        var month = Int(Double(cnd) / 30.6001)
        let day = cnd - Int(Double(month) * 30.6001)
        year -= 4716
        month = month - 1
        if month > 12 {
            month -= 12
        }
        if month <= 2 {
            year += 1
        }
        if year < 1 {
            year -= 1
        }
        cnf = cnf * 24.0
        dt.hour = Int(cnf)
        cnf = cnf - Double(dt.hour)
        cnf *= 60.0
        dt.minute = Int(cnf)
        cnf = cnf - Double(dt.minute)
        dt.second = cnf * 60.0
        dt.year = year
        dt.month = month
        dt.day = day
    }
    
    
    
    // 360度转换
    func mod360Degree(_ degrees:Double) -> Double {
        
        var dbValue:Double = degrees
    
        while dbValue < 0.0{
            dbValue += 360.0
        }
        
        while dbValue > 360.0{
            dbValue -= 360.0
        }
    
        return dbValue
    }
    
    // 角度转弧度
    func degree2Radian(_ degree:Double) -> Double {
        return degree * CalendarConstant.PI / 180.0
    }
    // 弧度转角度
    func radian2Degree(_ radian:Double) -> Double {
        return radian * 180.0 / CalendarConstant.PI
    }
   
    
    func getEarthNutationParameter(dt:Double, D:inout Double, M:inout Double, Mp:inout Double, F:inout Double, Omega:inout Double) {
        // T是从J2000起算的儒略世纪数
        let T = dt * 10
        let T2 = T * T
        let T3 = T2 * T
    
        // 平距角（如月对地心的角距离）
        D = 297.85036 + 445267.111480 * T - 0.0019142 * T2 + T3 / 189474.0
        
        // 太阳（地球）平近点角
        M = 357.52772 + 35999.050340 * T - 0.0001603 * T2 - T3 / 300000.0
        
        // 月亮平近点角
        Mp = 134.96298 + 477198.867398 * T + 0.0086972 * T2 + T3 / 56250.0
        
        // 月亮纬度参数
        F = 93.27191 + 483202.017538 * T - 0.0036825 * T2 + T3 / 327270.0
        
        // 黄道与月亮平轨道升交点黄经
        Omega = 125.04452 - 1934.136261 * T + 0.0020708 * T2 + T3 / 450000.0
    }

    // 计算某时刻的黄经章动干扰量，dt是儒略千年数，返回值单位是度
    func calcEarthLongitudeNutation(dt:Double) -> Double {
        let T = dt * 10
        var D:Double = 0.0, M:Double = 0.0, Mp:Double = 0.0, F:Double = 0.0, Omega:Double = 0.0
        
        getEarthNutationParameter(dt: dt, D: &D, M: &M, Mp: &Mp, F: &F, Omega: &Omega)
        
        var resulte = 0.0 
        for i in 0 ..< CalendarConstant.nutation.count {
            
            var sita = CalendarConstant.nutation[i].D * D + CalendarConstant.nutation[i].M * M + CalendarConstant.nutation[i].Mp * Mp + CalendarConstant.nutation[i].F * F + CalendarConstant.nutation[i].omega * Omega
            sita = degree2Radian(sita)
            
            resulte += (CalendarConstant.nutation[i].sine1 + CalendarConstant.nutation[i].sine2 * T ) * sin(sita)
        }
        
        /*先乘以章动表的系数 0.0001，然后换算成度的单位*/
        return resulte * 0.0001 / 3600.0
    }
    
    
    /*计算某时刻的黄赤交角章动干扰量，dt是儒略千年数，返回值单位是度*/
    func calcEarthObliquityNutation(dt:Double) -> Double {
        // T是从J2000起算的儒略世纪数
        let T = dt * 10
        var D = 0.0, M = 0.0, Mp = 0.0, F = 0.0, Omega = 0.0
    
        getEarthNutationParameter(dt:dt, D: &D, M: &M, Mp: &Mp, F: &F, Omega: &Omega)
    
        var resulte = 0.0 
        for i in 0 ..< CalendarConstant.nutation.count {
            var sita = CalendarConstant.nutation[i].D * D + CalendarConstant.nutation[i].M * M + CalendarConstant.nutation[i].Mp * Mp + CalendarConstant.nutation[i].F * F + CalendarConstant.nutation[i].omega * Omega
            sita = degree2Radian(sita)
            
            resulte += (CalendarConstant.nutation[i].cosine1 + CalendarConstant.nutation[i].cosine2 * T ) * cos(sita)
        }
    
        // 先乘以章动表的系数 0.001，然后换算成度的单位
        return resulte * 0.0001 / 3600.0
    }
    
    // 利用已知节气推算其它节气的函数，st的值以小寒节气为0，大寒为1，其它节气类推
    func calculateSolarTermsByExp(year:Int, st:Int) -> Double {
        if st < 0 || st > 24 {
            return 0.0
        }
    
        let stJd = 365.24219878 * Double(year - 1900) + CalendarConstant.stAccInfo[st] / 86400.0
    
        return CalendarConstant.base1900SlightColdJD + stJd
    }
    
    /*
     moved from <算法的乐趣 - 王晓华> 示例代码
     计算节气和朔日的经验公式
     
     当天到1900年1月0日（星期日）的差称为积日，那么第y年（1900算0年）第x个节气的积日是：
     F = 365.242 * y + 6.2 + 15.22 *x - 1.9 * sin(0.262 * x)
     
     从1900年开始的第m个朔日的公式是：
     M = 1.6 + 29.5306 * m + 0.4 * sin(1 - 0.45058 * m)
     */
    func calculateSolarTermsByFm(year:Int, st:Int) -> Double {
        let baseJD = calcJulianDay(1900, month: 1, day: 1, hour: 0, min: 0, second: 0.0) - 1
        let y = year - 1900
        
        let tmp = 15.22 * Double(st) - 1.0 * sin(0.262 * Double(st))
        let accDay = 365.2422 * Double(y) + 6.2 + tmp
        
        return baseJD + accDay
    }
    
    func calculateNewMoonByFm(m:Int) -> Double {
        
        let baseJD = calcJulianDay(1900, month: 1, day: 1, hour: 0, min: 0, second: 0.0) - 1
        let accDay = 1.6 + 29.5306 * Double(m) + 0.4 * sin(1 - 0.45058 * Double(m))
        return baseJD + accDay
    }
    
    func calcPeriodicTerm(coff:[PlanetData.VSOP87_COEFFICIENT], count:Int, dt:Double) -> Double {
        var val = 0.0
    
        for i in 0 ..< count {
            val += (coff[i].A * cos((coff[i].B + coff[i].C * dt)))
        }
        return val
    }
    
    // 计算太阳的地心黄经(度)，dt是儒略千年数
    
    func calcSunEclipticLongitudeEC(dt:Double) -> Double {
    
        let L0 = calcPeriodicTerm(coff: PlanetData.Earth_L0, count: PlanetData.Earth_L0.count, dt: dt)
        let L1 = calcPeriodicTerm(coff: PlanetData.Earth_L1, count: PlanetData.Earth_L1.count, dt: dt)
        let L2 = calcPeriodicTerm(coff: PlanetData.Earth_L2, count: PlanetData.Earth_L2.count, dt: dt)
        let L3 = calcPeriodicTerm(coff: PlanetData.Earth_L3, count: PlanetData.Earth_L3.count, dt: dt)
        let L4 = calcPeriodicTerm(coff: PlanetData.Earth_L4, count: PlanetData.Earth_L4.count, dt: dt)
        let L5 = calcPeriodicTerm(coff: PlanetData.Earth_L5, count: PlanetData.Earth_L5.count, dt: dt)
    
        let L = (((((L5 * dt + L4) * dt + L3) * dt + L2) * dt + L1) * dt + L0) / 100000000.0
    
        // 地心黄经 = 日心黄经 + 180度
        return (mod360Degree(mod360Degree(L / CalendarConstant.RADIAN_PER_ANGLE) + 180.0))
    }
    
    func calcSunEclipticLatitudeEC(dt:Double) -> Double {
        
        let B0 = calcPeriodicTerm(coff: PlanetData.Earth_B0, count: PlanetData.Earth_B0.count, dt: dt)
        let B1 = calcPeriodicTerm(coff: PlanetData.Earth_B1, count: PlanetData.Earth_B1.count, dt: dt)
        let B2 = calcPeriodicTerm(coff: PlanetData.Earth_B2, count: PlanetData.Earth_B2.count, dt: dt)
        let B3 = calcPeriodicTerm(coff: PlanetData.Earth_B3, count: PlanetData.Earth_B3.count, dt: dt)
        let B4 = calcPeriodicTerm(coff: PlanetData.Earth_B4, count: PlanetData.Earth_B4.count, dt: dt)
    
        let B = (((((B4 * dt) + B3) * dt + B2) * dt + B1) * dt + B0) / 100000000.0
    
        // 地心黄纬 = －日心黄纬
        return -(B / CalendarConstant.RADIAN_PER_ANGLE)
    }
    
    /*修正太阳的地心黄经，longitude, latitude 是修正前的太阳地心黄经和地心黄纬(度)，dt是儒略千年数，返回值单位度*/
    func adjustSunEclipticLongitudeEC(dt:Double, longitude:Double, latitude:Double) -> Double {
        //T是儒略世纪数
        let T = dt * 10
        var dbLdash = longitude - 1.397 * T - 0.00031 * T * T
    
        // 转换为弧度
        dbLdash *= Double(CalendarConstant.RADIAN_PER_ANGLE)
    
        return (-0.09033 + 0.03916 * (cos(dbLdash) + sin(dbLdash)) * tan(latitude * CalendarConstant.RADIAN_PER_ANGLE)) / 3600.0
    }
    
    /*修正太阳的地心黄纬，longitude是修正前的太阳地心黄经(度)，dt是儒略千年数，返回值单位度*/
    func adjustSunEclipticLatitudeEC(dt:Double, longitude:Double) -> Double {
        //T是儒略世纪数
        let T = dt * 10
        
        var dLdash = longitude - 1.397 * T - 0.00031 * T * T
    
        // 转换为弧度
        dLdash  *= CalendarConstant.RADIAN_PER_ANGLE
    
        return (0.03916 * (cos(dLdash) - sin(dLdash))) / 3600.0
    }
    
    func calcSunEarthRadius(dt:Double) -> Double {
        
        let R0 = calcPeriodicTerm(coff: PlanetData.Earth_R0, count: PlanetData.Earth_R0.count, dt: dt)
        let R1 = calcPeriodicTerm(coff: PlanetData.Earth_R1, count: PlanetData.Earth_R1.count, dt: dt)
        let R2 = calcPeriodicTerm(coff: PlanetData.Earth_R2, count: PlanetData.Earth_R2.count, dt: dt)
        let R3 = calcPeriodicTerm(coff: PlanetData.Earth_R3, count: PlanetData.Earth_R3.count, dt: dt)
        let R4 = calcPeriodicTerm(coff: PlanetData.Earth_R4, count: PlanetData.Earth_R4.count, dt: dt)
    
        let R = (((((R4 * dt) + R3) * dt + R2) * dt + R1) * dt + R0) / 100000000.0
    
        return R
    }
    
    // 得到某个儒略日的太阳地心黄经(视黄经)，单位度
    func getSunEclipticLongitudeEC(jde:Double) -> Double {
        // 儒略千年数
        let dt = (jde - CalendarConstant.JD2000) / 365250.0
    
        // 计算太阳的地心黄经
        var longitude = calcSunEclipticLongitudeEC(dt: dt)
    
        // 计算太阳的地心黄纬
        let latitude = calcSunEclipticLatitudeEC(dt: dt) * 3600.0
    
        // 修正精度
        longitude += adjustSunEclipticLongitudeEC(dt: dt, longitude: longitude, latitude: latitude)
    
        // 修正天体章动
        longitude += calcEarthLongitudeNutation(dt: dt)
    
        // 修正光行差
        /*太阳地心黄经光行差修正项是: -20".4898/R*/
        longitude -= (20.4898 / calcSunEarthRadius(dt: dt)) / 3600.0
    
        return longitude
    }
    
    
    // 得到某个儒略日的太阳地心黄纬(视黄纬)，单位度
    func getSunEclipticLatitudeEC(jde:Double) -> Double {
        // 儒略千年数
        let dt = (jde - CalendarConstant.JD2000) / 365250.0
    
        // 计算太阳的地心黄经
        let longitude = calcSunEclipticLongitudeEC(dt: dt)
        // 计算太阳的地心黄纬
        var latitude = calcSunEclipticLatitudeEC(dt: dt) * 3600.0
    
        // 修正精度
        let delta = adjustSunEclipticLatitudeEC(dt: dt, longitude: longitude)
        latitude += delta * 3600.0
    
        return latitude
    }
    
    func getMoonEclipticParameter(dt:Double,  Lp:inout Double, D: inout Double, M: inout Double, Mp:inout Double, F: inout Double, E: inout Double) {
        
        // T是从J2000起算的儒略世纪数
        let T = dt
        let T2 = T * T
        let T3 = T2 * T
        let T4 = T3 * T
    
        // 月球平黄经
        Lp = 218.3164591 + 481267.88134236 * T - 0.0013268 * T2 + T3/538841.0 - T4 / 65194000.0
        Lp = mod360Degree(Lp)
    
        // 月日距角
        D = 297.8502042 + 445267.1115168 * T - 0.0016300 * T2 + T3 / 545868.0 - T4 / 113065000.0
        D = mod360Degree(D)
    
        // 太阳平近点角
        M = 357.5291092 + 35999.0502909 * T - 0.0001536 * T2 + T3 / 24490000.0
        M = mod360Degree(M)
    
        // 月亮平近点角
        Mp = 134.9634114 + 477198.8676313 * T + 0.0089970 * T2 + T3 / 69699.0 - T4 / 14712000.0
        Mp = mod360Degree(Mp)
    
        // 月球经度参数(到升交点的平角距离)
        F = 93.2720993 + 483202.0175273 * T - 0.0034029 * T2 - T3 / 3526000.0 + T4 / 863310000.0
        F = mod360Degree(F)
    
        E = 1 - 0.002516 * T - 0.0000074 * T2
    }

    // 计算月球地心黄经周期项的和
    func calcMoonECLongitudePeriodic(D: Double, M: Double, Mp: Double, F: Double, E: Double) -> Double {
        var EI = 0.0
    
        for i in 0 ..< PlanetData.Moon_longitude.count {
            var sita = PlanetData.Moon_longitude[i].D * D + PlanetData.Moon_longitude[i].M * M + PlanetData.Moon_longitude[i].Mp * Mp + PlanetData.Moon_longitude[i].F * F
            sita = degree2Radian(sita)
            EI += (PlanetData.Moon_longitude[i].eiA * sin(sita) * pow(E, fabs(PlanetData.Moon_longitude[i].M)))
        }
        return EI
    }
    
    // 计算月球地心黄纬周期项的和
    func calcMoonECLatitudePeriodicTbl(D: Double, M: Double, Mp: Double, F: Double, E: Double) -> Double {
        var EB = 0.0
    
        for i in 0 ..< PlanetData.moon_Latitude.count {
            var sita = PlanetData.moon_Latitude[i].D * D + PlanetData.moon_Latitude[i].M * M + PlanetData.moon_Latitude[i].Mp * Mp + PlanetData.moon_Latitude[i].F * F
            sita = degree2Radian(sita)
            EB += (PlanetData.moon_Latitude[i].eiA * sin(sita) * pow(E, fabs(PlanetData.Moon_longitude[i].M)))
        }
    
        return EB
    }
    
    // 计算月球地心距离周期项的和
    func calcMoonECDistancePeriodicTbl(D: Double, M: Double, Mp: Double, F: Double, E: Double) -> Double {
        var ER = 0.0
    
        for i in 0 ..< PlanetData.Moon_longitude.count {
            var sita = PlanetData.Moon_longitude[i].D * D + PlanetData.Moon_longitude[i].M * M + PlanetData.Moon_longitude[i].Mp * Mp + PlanetData.Moon_longitude[i].F * F
            sita = degree2Radian(sita)
            ER += (PlanetData.Moon_longitude[i].erA * cos(sita) * pow(E, fabs(PlanetData.Moon_longitude[i].M)))
        }
    
        return ER
    }
    
    // 计算金星摄动,木星摄动以及地球扁率摄动对月球地心黄经的影响,dt 是儒略世纪数，Lp和F单位是度
    func calcMoonLongitudePerturbation(dt: Double, Lp: Double, F: Double) -> Double {
        // T是从J2000起算的儒略世纪数
        let T = dt
        var A1 = 119.75 + 131.849 * T
        var A2 = 53.09 + 479264.290 * T
    
        A1 = mod360Degree(A1)
        A2 = mod360Degree(A2)
    
        var result = 3958.0 * sin(degree2Radian(A1))
        result += (1962.0 * sin(degree2Radian(Lp - F)))
        result += (318.0 * sin(degree2Radian(A2)))
    
        return result
    }
    
    // 计算金星摄动,木星摄动以及地球扁率摄动对月球地心黄纬的影响,dt 是儒略世纪数，Lp、Mp和F单位是度
    func calcMoonLatitudePerturbation(dt: Double, Lp: Double, F: Double, Mp: Double) -> Double {
        // T是从J2000起算的儒略世纪数
        let T = dt
        var A1 = 119.75 + 131.849 * T
        var A3 = 313.45 + 481266.484 * T
    
        A1 = mod360Degree(A1)
        A3 = mod360Degree(A3)
    
        var result = -2235.0 * sin(degree2Radian(Lp))
        result += (382.0 * sin(degree2Radian(A3)))
        result += (175.0 * sin(degree2Radian(A1 - F)))
        result += (175.0 * sin(degree2Radian(A1 + F)))
        result += (127.0 * sin(degree2Radian(Lp - Mp)))
        result += (115.0 * sin(degree2Radian(Lp + Mp)))
    
        return result
    }
    
    func getMoonEclipticLongitudeEC(dbJD: Double) -> Double {
    
        var Lp:Double = 0.0, D:Double = 0.0, M:Double = 0.0, Mp:Double = 0.0, F:Double = 0.0, E:Double = 0.0
        // 儒略世纪数
        let dt = (dbJD - CalendarConstant.JD2000) / 36525.0
    
        getMoonEclipticParameter(dt: dt, Lp: &Lp, D: &D, M: &M, Mp: &Mp, F: &F, E: &E)
    
        // 计算月球地心黄经周期项
        var EI = calcMoonECLongitudePeriodic(D: D, M: M, Mp: Mp, F: F, E: E)
    
        // 修正金星,木星以及地球扁率摄动
        EI += calcMoonLongitudePerturbation(dt: dt, Lp: Lp, F: F)
    
        // 计算月球地心黄经
        var longitude = Lp + EI / 1000000.0
    
        // 计算天体章动干扰
        longitude += calcEarthLongitudeNutation(dt: dt / 10.0)
        // 映射到0-360范围内
        longitude = mod360Degree(longitude)
        return longitude
    }
    
    func getMoonEclipticLatitudeEC(dbJD: Double) -> Double {
        // 儒略世纪数
        let dt = (dbJD - CalendarConstant.JD2000) / 36525.0
    
        var Lp = 0.0, D = 0.0, M = 0.0, Mp = 0.0, F = 0.0, E = 0.0
        getMoonEclipticParameter(dt: dt, Lp: &Lp, D: &D, M: &M, Mp: &Mp, F: &F, E: &E)
    
        // 计算月球地心黄纬周期项
        var EB = calcMoonECLatitudePeriodicTbl(D: D, M: M, Mp: Mp, F: F, E: E)
    
        // 修正金星,木星以及地球扁率摄动
        EB += calcMoonLatitudePerturbation(dt: dt, Lp: Lp, F: F, Mp: Mp)
    
        // 计算月球地心黄纬*/
        let latitude = EB / 1000000.0
    
        return latitude
    }
    
    func getMoonEarthDistance(dbJD: Double) -> Double {
        // 儒略世纪数
        let dt = (dbJD - CalendarConstant.JD2000) / 36525.0
    
        var Lp = 0.0, D = 0.0, M = 0.0, Mp = 0.0, F = 0.0, E = 0.0
        getMoonEclipticParameter(dt: dt, Lp: &Lp, D: &D, M: &M, Mp: &Mp, F: &F, E: &E)
    
        // 计算月球地心距离周期项
        let ER = calcMoonECDistancePeriodicTbl(D: D, M: M, Mp: Mp, F: F, E: E)
    
        // 计算月球地心黄纬
        let distance = 385000.56 + ER / 1000.0
    
        return distance
    }

    
    
    func getInitialEstimateSolarTerms(year: Int, angle: Int) -> Double {
        var STMonth = Int(ceil(Double((Double(angle) + 90.0) / 30.0)))
        STMonth = STMonth > 12 ? STMonth - 12 : STMonth
    
        // 每月第一个节气发生日期基本都4-9日之间，第二个节气的发生日期都在16－24日之间
        if (angle % 15 == 0) && (angle % 30 != 0) {
            return calcJulianDay(year, month: STMonth, day: 6, hour: 12, min: 0, second: 0.0)
        }else{
            return calcJulianDay(year, month: STMonth, day: 20, hour: 12, min: 0, second: 0.0)
        }
    }
    
    // 计算指定年份的任意节气，angle是节气在黄道上的读数
    // 返回指定节气的儒略日时间(力学时)
    func calculateSolarTerms(year: Int, angle: Int) -> Double {
        var JD0:Double, JD1:Double, stDegree:Double, stDegreep:Double
    
        JD1 = getInitialEstimateSolarTerms(year: year, angle: angle)
        repeat
        {
            JD0 = JD1
            stDegree = getSunEclipticLongitudeEC(jde: JD0)
            /*
             对黄经0度迭代逼近时，由于角度360度圆周性，估算黄经值可能在(345,360]和[0,15)两个区间，
             如果值落入前一个区间，需要进行修正
             */
            stDegree = ((angle == 0) && (stDegree > 345.0)) ? stDegree - 360.0 : stDegree
            stDegreep = (getSunEclipticLongitudeEC(jde: Double(JD0) + 0.000005) - getSunEclipticLongitudeEC(jde: Double(JD0) - 0.000005)) / 0.00001
            JD1 = JD0 - (stDegree - Double(angle)) / stDegreep
            
            //print("getInitialEstimateSolarTerms JD1-JD0 = \(JD1 - JD0)")
        }while((fabs(JD1 - JD0) > 0.0000001))
    
        return JD1
    }
    
    /*
     得到给定的时间后面第一个日月合朔的时间，平均误差小于3秒
     输入参数是指定时间的力学时儒略日数
     返回值是日月合朔的力学时儒略日数
     */
    func calculateMoonShuoJD(tdJD: Double) -> Double {
        var JD0:Double, JD1:Double, stDegree:Double, stDegreep:Double
        
        
        var count = 0
        JD1 = tdJD
        repeat
        {
            JD0 = JD1
            var moonLongitude = getMoonEclipticLongitudeEC(dbJD: JD0)
            var sunLongitude = getSunEclipticLongitudeEC(jde: JD0)
            if (moonLongitude > 330.0) && (sunLongitude < 30.0) {
                sunLongitude = 360.0 + sunLongitude
            }
            if (sunLongitude > 330.0) && (moonLongitude < 30.0) {
                moonLongitude = 60.0 + moonLongitude
            }
    
            stDegree = moonLongitude - sunLongitude
            if(stDegree >= 360.0){
                stDegree -= 360.0
            }
            
            if(stDegree < -360.0) {
                stDegree += 360.0
            }
            
            stDegreep = (getMoonEclipticLongitudeEC(dbJD: JD0 + 0.000005) - getSunEclipticLongitudeEC(jde: JD0 + 0.000005) - getMoonEclipticLongitudeEC(dbJD: JD0 - 0.000005) + getSunEclipticLongitudeEC(jde: JD0 - 0.000005)) / 0.00001
            JD1 = JD0 - stDegree / stDegreep
            
            count += 1
            if count > 500 {
                break
            }
            
            //print("calculateMoonShuoJD JD1 - JD0 = \(JD1 - JD0)")
        }while((fabs(JD1 - JD0) > 0.00000001))
        
        return JD1
    }
    
    
    func calculateStemsBranches(year: Int, stems: inout Int, branches: inout Int) {
        let sc = year - 2000
        stems = (7 + sc) % 10
        branches = (5 + sc) % 12
    
        if stems < 0 {
            stems += 10
        }
        if branches < 0 {
            branches += 12
        }
    }
    
    
    
    
    
    private struct TD_UTC_DELTA
    {
        var year: Int
        var d1:Double, d2: Double, d3: Double, d4: Double
        
        init(_ year: Int, _ d1: Double, _ d2: Double, _ d3: Double, _ d4: Double) {
            self.year = year
            self.d1 = d1
            self.d2 = d2
            self.d3 = d3
            self.d4 = d4
        }
    }
    
    
    // TD - UT1 计算表
    private static let deltaTbl:[TD_UTC_DELTA] = [
        TD_UTC_DELTA( -4000, 108371.7,-13036.80,392.000, 0.0000 ),
        TD_UTC_DELTA( -500, 17201.0,  -627.82, 16.170,-0.3413  ),
        TD_UTC_DELTA( -150, 12200.6,  -346.41,  5.403,-0.1593 ),
        TD_UTC_DELTA( 150,  9113.8,  -328.13, -1.647, 0.0377  ),
        TD_UTC_DELTA( 500,  5707.5,  -391.41,  0.915, 0.3145  ),
        TD_UTC_DELTA( 900,  2203.4,  -283.45, 13.034,-0.1778   ),
        TD_UTC_DELTA( 1300,   490.1,   -57.35,  2.085,-0.0072  ),
        TD_UTC_DELTA( 1600,   120.0,    -9.81, -1.532, 0.1403  ),
        TD_UTC_DELTA( 1700,    10.2,    -0.91,  0.510,-0.0370  ),
        TD_UTC_DELTA( 1800,    13.4,    -0.72,  0.202,-0.0193  ),
        TD_UTC_DELTA( 1830,     7.8,    -1.81,  0.416,-0.0247  ),
        TD_UTC_DELTA( 1860,     8.3,    -0.13, -0.406, 0.0292  ),
        TD_UTC_DELTA( 1880,    -5.4,     0.32, -0.183, 0.0173  ),
        TD_UTC_DELTA( 1900,    -2.3,     2.06,  0.169,-0.0135  ),
        TD_UTC_DELTA( 1920,    21.2,     1.69, -0.304, 0.0167  ),
        TD_UTC_DELTA( 1940,    24.2,     1.22, -0.064, 0.0031  ),
        TD_UTC_DELTA( 1960,    33.2,     0.51,  0.231,-0.0109  ),
        TD_UTC_DELTA( 1980,    51.0,     1.29, -0.026, 0.0032  ),
        TD_UTC_DELTA( 2000,    63.87,    0.1,   0.0,     0.0   ),
        TD_UTC_DELTA( 2005,    0.0,      0.0,   0.0,   0.0     )
    ]
    
    
    func deltaExt(y: Double, jsd: Int) -> Double {
        let dy = (y - 1820.0) / 100.0
        return -20.0 + Double(jsd) * dy * dy
    }

    func tdUtcDeltaT(y: Double) -> Double {
        if y >= 2005 {
            
            let y1: Int = 2014
            let sd = 0.4
            let jsd: Int = 31
            
            if y <= Double(y1) {
                return 64.7 + (y - 2005) * sd
            }
            var v = deltaExt(y: y, jsd: jsd)
            let dv = deltaExt(y: Double(y1), jsd: jsd) - (64.7 + Double(y1 - 2005) * sd)
            
            if y < Double(y1) + 100 {
                v -= dv * (Double(y1) + 100 - y) / 100
            }
            
            return v
        } else {
            
            var i = 0
            for flag in 0 ..< CalendarUtils.deltaTbl.count {
                i = flag
                if y < Double(CalendarUtils.deltaTbl[i + 1].year) {
                    break
                }
            }
            
            let t1 = Double(y - Double(CalendarUtils.deltaTbl[i].year)) / Double(CalendarUtils.deltaTbl[i + 1].year - CalendarUtils.deltaTbl[i].year) * 10.0
            let t2 = t1 * t1
            let t3 = t2 * t1
            
            return CalendarUtils.deltaTbl[i].d1 + CalendarUtils.deltaTbl[i].d2 * t1 + CalendarUtils.deltaTbl[i].d3 * t2 + CalendarUtils.deltaTbl[i].d4 * t3
        }
    }
    
    func tdUtcDeltaT2(jd2k: Double) -> Double {
        
        return tdUtcDeltaT(y: jd2k / 365.2425 + 2000) / 86400.0
    }

    
    // 本地时间转utc
    func jdLocalTimetoUTC(localJD: Double) -> Double {
        let tz = NSTimeZone.default
        let secs = -tz.secondsFromGMT()
        
        return localJD + Double(secs) / 86400.0
    }
    
    // utc转本地时间
    func jdUTCToLocalTime(utcJD: Double) -> Double {
        let tz = NSTimeZone.default
        let secs = -tz.secondsFromGMT()
        return utcJD - Double(secs) / 86400.0
    }
    
    func jdTDtoUTC(tdJD: Double) -> Double {
        var _tdJD = tdJD
        let jd2k = tdJD - CalendarConstant.JD2000
        let tian = tdUtcDeltaT2(jd2k: jd2k)
        _tdJD -= tian
        
        return _tdJD
    }
    
    func jdTDtoLocalTime(tdJD: Double) -> Double {
        let tmp = jdTDtoUTC(tdJD: tdJD)
        return jdUTCToLocalTime(utcJD: tmp)
    }
    
    func jdUTCtoTD(utcJD: Double) -> Double {
        var _utcJD = utcJD
        let jd2k = utcJD - CalendarConstant.JD2000
        let tian = tdUtcDeltaT2(jd2k: jd2k)
        
        _utcJD += tian
        
        return _utcJD
    }
    
    func jdLocalTimetoTD(localJD: Double) -> Double {
        let tmp = jdLocalTimetoUTC(localJD: localJD)
        return jdUTCtoTD(utcJD: tmp)
    }
    
    
    
}
