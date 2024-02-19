//
//  ViewController.swift
//  POST API
//
//  Created by Nimap on 19/02/24.
//

import UIKit

struct PostRequest: Codable {
    var id: String
    var title : String
    var brand : String
}


class ViewController: UIViewController {
    
    var IdTF : UITextField!
    var TitleTF : UITextField!
    var BrandTF : UITextField!
    var SaveBtn : UIButton!
    
    var response: URLResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
    }
    func UI(){
        IdTF = UITextField()
        IdTF.placeholder = "ID"
        IdTF.borderStyle = .roundedRect
        IdTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(IdTF)
        
        NSLayoutConstraint.activate([
            IdTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            IdTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            IdTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        TitleTF = UITextField()
        TitleTF.placeholder = "Title"
        TitleTF.borderStyle = .roundedRect
        TitleTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(TitleTF)
        
        NSLayoutConstraint.activate([
            TitleTF.topAnchor.constraint(equalTo: IdTF.bottomAnchor, constant: 20),
            TitleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            TitleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        BrandTF = UITextField()
        BrandTF.placeholder = "Brand"
        BrandTF.borderStyle = .roundedRect
        BrandTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(BrandTF)
        
        NSLayoutConstraint.activate([
            BrandTF.topAnchor.constraint(equalTo: TitleTF.bottomAnchor, constant: 20),
            BrandTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            BrandTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        SaveBtn = UIButton(type: .system)
        SaveBtn.setTitle("Save", for: .normal)
        SaveBtn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        SaveBtn.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(SaveBtn)

        NSLayoutConstraint.activate([
            SaveBtn.topAnchor.constraint(equalTo: BrandTF.bottomAnchor, constant: 20),
            SaveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func saveButtonTapped() {
            guard let id = IdTF.text,
                  let title = TitleTF.text,
                  let brand = BrandTF.text else {
                // Handle validation or show an alert if any field is empty
                return
            }

            let requestbody = PostRequest(id: id, title: title, brand: brand)
            API(requestbody: requestbody)
        }
    
    func API(requestbody: PostRequest) {
            guard let url = URL(string: "https://dummyjson.com/products/add") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let requestBodyData = try JSONEncoder().encode(requestbody)
                request.httpBody = requestBodyData
                print("Success in Request Body")
            } catch {
                print("Error in Request Body")
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("StatusCode....\(httpResponse.statusCode)")
                }
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let responseData = try decoder.decode(PostRequest.self, from: data)
                    print("PostRequest \(responseData)")
                } catch {
//                    print("Error decoding response data: \(error)")
                }
            }.resume()
        }
}
