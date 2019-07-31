//
//  ViewController.swift
//  HomeWork1
//
//  Created by Tzu-Yin Hong on 2019/7/29.
//  Copyright © 2019年 Tzu-Yin Hong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var result: [MyRepo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchGithub()
    }
    
    struct MyRepo: Codable {
        let name: String?
        let description: String?
        let url: String?
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(result.count)
        return result.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = result[indexPath.row].name
        return cell
    }

    func fetchGithub() {
        guard let gitUrl = URL(string: "https://api.github.com/users/lili668668/repos") else { return }
        URLSession.shared.dataTask(with: gitUrl) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decodeer = JSONDecoder()
                let gitData = try decodeer.decode([MyRepo].self, from: data)
                self.result = gitData
                DispatchQueue.main.async {
                    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

