//
//  View+Extensions.swift
//  SharePoint
//
//  Created by Dibyo sarkar on 13/12/24.
//

import SwiftUI

//struct View_Extensions: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    View_Extensions()
//}


// MARK: View Extension For UI Building
extension View{
    //Closing All Active KeyBoards
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    //MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool)->some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alignment: Alignment)-> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    func vAlign(_ alignment: Alignment) -> some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
        
    }
    
//MARK: Custom Border View With Padding
    func border(_ width: CGFloat,_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5,style: .continuous)
                    .stroke (color,lineWidth: width )
            }
    }
    
    
    func fillView(_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5,style: .continuous)
                    .fill(color)
            }
    }
    
    
    
}
