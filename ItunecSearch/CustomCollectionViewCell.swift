import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureSomehow(isSomething: String) {
        label.text = isSomething
    }
    private func setupUI() {
        addSubview(imageView)
        addSubview(label)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
    }
    func configure(with image: UIImage) {
        imageView.image = image
        label.textColor = .red
        label.sizeToFit()
    }
}
