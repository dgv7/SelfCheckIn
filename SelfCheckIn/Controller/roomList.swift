//import UIKit
//
//class ViewController: UIViewController {
//    
//    let rooms = [
//        ("singleRoomImage", "Classic Single Room", "1박 130,300원 ~"),
//        ("doubleRoomImage", "Deluxe Double Room", "1박 130,300원 ~"),
//        ("queenRoomImage", "Noblesse Queen Room", "1박 130,300원 ~")
//    ]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        
//        let mainStackView = UIStackView()
//        mainStackView.axis = .vertical
//        mainStackView.spacing = 10
//        mainStackView.alignment = .fill
//        mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(mainStackView)
//        
//        NSLayoutConstraint.activate([
//            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
//            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
//        ])
//        
//        for room in rooms {
//            let roomStackView = createRoomStackView(imageName: room.0, roomName: room.1, price: room.2)
//            mainStackView.addArrangedSubview(roomStackView)
//        }
//    }
//    
//    func createRoomStackView(imageName: String, roomName: String, price: String) -> UIStackView {
//        let roomImageView = UIImageView()
//        roomImageView.translatesAutoresizingMaskIntoConstraints = false
//        roomImageView.image = UIImage(named: imageName)
//        roomImageView.contentMode = .scaleAspectFill
//        roomImageView.clipsToBounds = true
////        roomImageViewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside )
//        
//        NSLayoutConstraint.activate([
//        roomImageView.widthAnchor.constraint(equalToConstant: 140),
//        roomImageView.heightAnchor.constraint(equalToConstant: 80)
//        ])
//        
//        let roomNameLabel = UILabel()
//        roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        roomNameLabel.text = roomName
//        roomNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        roomNameLabel.textAlignment = .right
//        
////        NSLayoutConstraint.activate([
////            roomNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
////            roomNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
////        ])
//        
////        roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
////        roomNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
////        roomNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        
//        let priceLabel = UILabel()
//        priceLabel.translatesAutoresizingMaskIntoConstraints = false
//        priceLabel.text = price
//        priceLabel.font = UIFont.systemFont(ofSize: 17)
//        priceLabel.textAlignment = .right
//        priceLabel.textColor = .gray
//        
////        NSLayoutConstraint.activate([
////            priceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
////            priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
////        ])
//        
//        
//        let verticalStackView = UIStackView()
//        verticalStackView.axis = .vertical
//        verticalStackView.spacing = 5
//        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
//        verticalStackView.addArrangedSubview(roomNameLabel)
//        verticalStackView.addArrangedSubview(priceLabel)
//        
//        let horizontalStackView = UIStackView()
//        horizontalStackView.axis = .horizontal
//        horizontalStackView.spacing = 10
//        horizontalStackView.alignment = .center
//        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
//        horizontalStackView.addArrangedSubview(roomImageView)
//        horizontalStackView.addArrangedSubview(verticalStackView)
//        
//        return horizontalStackView
//    }
//}
//
////@objc func buttonTapped(sender: UIButton) {
////        let alertController = UIAlertController(title: "Room Details", message: "You tapped on \(sender.title(for: .normal) ?? "a button")", preferredStyle: .alert)
////        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////        present(alertController, animated: true, completion: nil)
////    }
