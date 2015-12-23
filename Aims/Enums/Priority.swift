//
//  Priority.swift
//  Aims
//
//  Created by Yilun Liu on 12/16/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation


enum Priority: Int{
    case Low = 0, Normal, High
    
    func description() -> String{
        switch(self){
        case .Low: return "Low"
        case .Normal: return "Normal"
        case .High: return "High"
        }
    }
}