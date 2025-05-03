//
//  ViewController.swift
//  ItunecSearch
//
//  Created by IVAN on 17.02.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var collectionView: UICollectionView!
    let Image = UIImage(named: "POPSMOKE")!
    var model: ItunesSearchResponseDto?
    var filteredData: [String] = []
    var items: Result<ItunesSearchResponseDto,Error>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }

    func fetchData(for searchTerm: String) {
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
                    self?.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        .resume()
    }

    func setupUI() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for artists, songs, albums..."
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = .white

        navigationItem.searchController = searchController

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.results.count ?? 0
        }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCollectionViewCell else {
               return UICollectionViewCell()
        }
           let modelResult = model?.results[indexPath.row]
           cell.configure(with: Image)
           cell.configureSomehow(isSomething: modelResult?.collectionName ?? "")
           return cell
       }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat = 10
           let collectionViewWidth = collectionView.frame.width - (padding * 3)
           let cellWidth = collectionViewWidth / 2
           return CGSize(width: cellWidth, height: cellWidth)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            model = nil
            self.collectionView.reloadData()
            return
        }
        fetchData(for: text)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albumName = model?.results[indexPath.item].collectionName else { return }
        let FirstVC = AnotherViewController(searchTerm: albumName)
        navigationController?.pushViewController(FirstVC, animated: true)
    }
}
