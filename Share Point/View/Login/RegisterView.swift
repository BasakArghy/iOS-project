//
//  RegisterView.swift
//  SharePoint
//
//  Created by Dibyo sarkar on 13/12/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

//MARK: Register View
struct RegisterView: View {
    //Mark: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    //MARK: view Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //mark : userdefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View{
        
        VStack(spacing:10){
            Text("Let's Register Account")
                .font(.largeTitle.bold())
            
            Text("Hello user,have a wonderful journey!")
                .font(.title3)
                .hAlign(.leading)
            
            //mark :for smaller size optimization
            ViewThatFits {
                ScrollView(.vertical,showsIndicators: false){
                    HelperView()
                }
                HelperView()
            }
            
           
            //MARK: REGISTRATION BUTTON
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("Login Now"){
                   dismiss()
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
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem){ newValue in
            //Mark : Extracting UIImage From PhotoItem
            if let newValue {
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type:
                                                                                    Data.self) else{return}
                        await MainActor.run (body: {
                            userProfilePicData = imageData
                        })
                    }catch{}
                }
            }
            
        }
        
        //MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView()->some View {
        VStack(spacing: 12)
        {
            ZStack{
                if let userProfilePicData,let image = UIImage(data: userProfilePicData){
                    Image (uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                else{
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85,height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top,25)
            
            TextField("User Name", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top,25)
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top,25)
            
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top,25)
            TextField("About you", text: $userBio)
                .frame(minHeight: 100 ,alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top,25)
            TextField("BioLink(optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top,25)
            Button("Reset Password?", action: {} )
                .font(.callout)
                .fontWeight(.medium)
                .tint(.black)
                .hAlign(.trailing)
            Button (action: registerUser){
                //MARK: Login Button
                Text("Sign Up")
                    .foregroundColor(.white)
                    .fillView(.black)
                
            }
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil )
            .padding(.top,10)
        }
    }
 
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                //Step 1: Creating firebase Account
                 try await Auth.auth().createUser(withEmail: emailID, password: password)
                //Step 2: Uploading Profile Photo Into Firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                guard let imageData = userProfilePicData else{return}
                let storageRef = Storage.storage().reference().child("Profile_Images")
                    .child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                    //Step 3: Downloading Photo URL
                let downloadingURL = try await storageRef.downloadURL()
                let downloadURL = downloadingURL.absoluteString
                //Step 4: Creating a User Firestore Object
                let user = User(username: userName,
                                userBio: userBio,
                                userBioLink: userBioLink,
                                userUID: userUID,
                                userEmail: emailID,
                                userProfileURL: downloadURL)
                //step 5: Saving User Doc into Firebase Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                    error in
                    if error == nil{
                        //MARK: print Saved successfully
                        print("Saved Successfully")
                        userNameStored = userName
                        self.userUID = userUID
                        profileURL = downloadingURL
                        logStatus = true
                    }
                })
            }catch{
                //mark :deleting created account in case of failure
                try await Auth.auth().currentUser?.delete()
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
            isLoading =  false
        })
    }
    
}
struct RegisterView_PreViews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
