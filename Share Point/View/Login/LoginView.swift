//
//  LoginView.swift
//  SharePoint
//
//  Created by Dibyo sarkar on 13/12/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    //MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //MARK: User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: String?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing:10){
            Text("Let's Sign you in")
                .font(.largeTitle.bold())
            
            Text("Welcome Back ,\nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            
            
            VStack(spacing: 12)
            {
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                Button("Reset Password?", action: resetPassword )
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                Button (action: loginUser){
                    //MARK: Login Button
                    Text("Sign in")
                        .foregroundColor(.white)
                        .fillView(.black)
                    
                }
                .padding(.top,10)
            }
            HStack{
                Text("Don;t have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
            
        }
       
        
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        //MARK: Register View VIA Sheets
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
        }
        //MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
        
        
    }
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                //With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().signIn(withEmail: emailID,password: password)
                print("User Found")
                try await fetchUser()
            }catch{
                await setError(error)
            }
        }
    }
    
    //MARK: IF User if Found then Fetching User Data From FireStore
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let user = try await Firestore.firestore().collection("users").document(userID).getDocument(as: User.self)
        
        //MARK: UI Updating Must be Run On Main Thread
        await MainActor.run {
            //Setting UserDefaults data and Changing App's Auth Status
            self.userUID = userID  // Make sure to use 'self' here to modify the @AppStorage value
            self.userNameStored = user.username
            self.profileURL = user.userProfileURL
            self.logStatus = true
        }
    }

    
    func resetPassword(){
        Task{
            do{
                //With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            }catch{
                await setError(error)
            }
        }
    }
    
    //MARK: Displaying Errors VIA Alert
    func setError(_ error: Error)async{
        //MARK: UI Must be Updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

