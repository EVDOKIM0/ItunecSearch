//
//  AnotherViewController.swift
//  ItunecSearch
//
//  Created by IVAN on 20.03.2025.
//

import UIKit
import SnapKit

class AnotherViewController: UIViewController {

    let label = UILabel()
    var model: ItunesSearchResponseDto?
    let imageView = UIImageView()
    var tableView = UITableView()
    let searchTerm: String

    init(searchTerm: String) {
        self.searchTerm = searchTerm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        fetchData()
    }

    func fetchData() {
        let replacedText = searchTerm.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(replacedText)&entity=song") else { return }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error {
                print(error)
                return
            }
            guard let data else { return }
            do {
                let result = try JSONDecoder().decode(ItunesSearchResponseDto.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    self?.model = result
                    self?.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        .resume()
    }

    func setupView() {
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "BLUE")
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.height.equalTo(200)
        }
        label.text = "TEYMOOOO!"
        label.textColor = .black
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(label.snp.top).offset(20)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

extension AnotherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.results.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let modelResult = model?.results[indexPath.row]
        cell.textLabel?.text = String(modelResult?.collectionName ?? "")

        return cell
    }
}
