//
//  DataTask.swift
//  CombineTesting
//
//  Created by Eknath Kadam on 9/19/22.
//

import SwiftUI
import Combine

@MainActor
class DataTaskWithCombineModel : ObservableObject {
    @Published var users : [User] = []
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data,response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
             .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let e) : print("error - ",e)
                case .finished : print("success ")
                }
            }, receiveValue: { users in
                self.users = users
            })
     }
}


struct DataTaskWithCombineView: View {
    @StateObject var model = DataTaskWithCombineModel()
    var body: some View {
        List (model.users) { user in
            Text(user.name)
        }
    }
}

struct DataTaskWithCombineView_Previews: PreviewProvider {
    static var previews: some View {
        DataTaskWithCombineView()
    }
}
