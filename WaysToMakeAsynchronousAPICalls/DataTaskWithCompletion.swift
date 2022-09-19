//
//  DataTask.swift
//  CombineTesting
//
//  Created by Eknath Kadam on 9/19/22.
//

import SwiftUI


class DataTaskWithCompletionModel : ObservableObject {
    @Published var users : [User] = []
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
    
    init() {
        setupDataTask { result in
            switch result {
            case .success(let users):
                print("users ", users)

                DispatchQueue.main.async {
                    self.users = users
                }
            case .failure(let e):
                print("error ",e)
            }
        }
    }
    
    //MARK: - using completion handler
    func setupDataTask(withCompletion: @escaping (Result<[User], Error>) -> Void) {
        let req = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if let e = error   {
                withCompletion(Result.failure(e))
            } else {
                guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
                    withCompletion(Result.failure(URLError(.badServerResponse)))
                    return
                }
                if let dt = data {
                    do {
                        let users = try JSONDecoder().decode([User].self, from: dt)
                        withCompletion(Result.success(users))
                    } catch let err {
                        withCompletion(Result.failure(err))
                    }
                }
                else {
                    withCompletion(Result.failure(URLError(.badServerResponse)))
                }
            }
        }
        task.resume()
    }
    
    
}



struct DataTaskWithCompletionView: View {
    @StateObject var model = DataTaskWithCompletionModel()
    var body: some View {
        List (model.users) { user in
            Text(user.name)
        } 
    }
}

struct DataTaskWithCompletion_Previews: PreviewProvider {
    static var previews: some View {
        DataTaskWithCompletionView()
    }
}
