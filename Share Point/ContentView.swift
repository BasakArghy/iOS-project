//
//  ContentView.swift
//  SharePoint
//
//  Created by Dibyo sarkar on 9/1/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
       //MARK: Redirecting User Based  on Log Status
        if logStatus{
            //MainView()
        }else{
           LoginView()
        }
//        CreateNewPost {_ in
//
//        }
    }
}

#Preview {
    ContentView()
}
