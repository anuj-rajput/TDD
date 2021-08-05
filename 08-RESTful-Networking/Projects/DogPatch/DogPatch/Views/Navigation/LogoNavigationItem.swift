import UIKit

class LogoNavigationItem: UINavigationItem {

  override init(title: String) {
    super.init(title: title)
    setupTitleView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupTitleView()
  }
  
  private func setupTitleView() {
    let image = UIImage(named: "logo_dog_patch")
    let imageView = UIImageView(image: image)
    titleView = imageView
  }
}
