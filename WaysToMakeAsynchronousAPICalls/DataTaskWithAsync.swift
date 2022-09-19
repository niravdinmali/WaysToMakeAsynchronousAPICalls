//
//  DataTask.swift
//  CombineTesting
//
//  Created by Eknath Kadam on 9/19/22.
//

import SwiftUI
 

@MainActor
class DataTaskWithAsyncModel : ObservableObject {
    @Published var users : [User] = []
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
 
     
     //MARK: - using asyncawait
     func setupDataTaskWithAwait() async{
             do {
                 //no error?????
                 let (data, response) = try await URLSession.shared.data(from: url)
                 //note here MainActor is working but in completion handler case it was not and at trun time cannot publish in background was resulting,
                 //so there had to do dispatchmainque aysnc
                 guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
                     print("error ")
                     return
                 }
                 self.users = try JSONDecoder().decode([User].self, from: data)
                 print("users ", users)

             }
             catch {
                 // Error handling in case the data couldn't be loaded
                 // For now, only display the error on the console
                 print("Error loading \(url): \(String(describing: error))")
             }
         
     }

}



struct DataTaskWithAsyncView: View {
    @StateObject var model = DataTaskWithAsyncModel()
    var body: some View {
        List (model.users) { user in
            Text(user.name)
        }
        .task {
            await self.model.setupDataTaskWithAwait()
        }
        .refreshable { //swipe down gesture - update data
            await self.model.setupDataTaskWithAwait()
        }
    }
}

struct DataTaskWithAsyncView_Previews: PreviewProvider {
    static var previews: some View {
        DataTaskWithAsyncView()
    }
}
