import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
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
            contentView.addSubview(imageView)
            contentView.addSubview(label)

            imageView.snp.makeConstraints {
                $0.height.equalTo(120.0)
                $0.top.horizontalEdges.equalToSuperview()
            }

            label.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(8.0)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        }
    func configure(with image: UIImage) {
        imageView.image = image
        label.textColor = .white
        label.sizeToFit()
    }
}
