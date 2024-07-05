import UIKit

class ViewController: UIViewController {
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var dateButton: UIButton?
    var verticalStackView2: UIStackView!
    var contentStackView: UIStackView!
    var mainStackView: UIStackView!
    
    let rooms1 = [
        ("singleRoomImage", "Standard Single Room", "1박 130,300원 ~"),
        ("doubleRoomImage", "Standard Double Room", "1박 130,300원 ~"),
        ("queenRoomImage", "Standard Queen Room", "1박 130,300원 ~"),
    ]
    let rooms2 = [
        ("singleRoomImage", "Deluxe Single Room", "1박 160,300원 ~"),
        ("doubleRoomImage", "Deluxe Double Room", "1박 160,300원 ~"),
        ("queenRoomImage", "Deluxe Queen Room", "1박 160,300원 ~"),
    ]
    let rooms3 = [
        ("singleRoomImage", "Sweet Single Room", "1박 190,300원 ~"),
        ("doubleRoomImage", "Sweet Double Room", "1박 190,300원 ~"),
        ("queenRoomImage", "Sweet Queen Room", "1박 190,300원 ~"),
    ]
    let rooms4 = [
        ("singleRoomImage", "Family Single Room", "1박 240,300원 ~"),
        ("doubleRoomImage", "Family Double Room", "1박 240,300원 ~"),
        ("queenRoomImage", "Family Queen Room", "1박 240,300원 ~"),
    ]
    
    var selectedCategories: [String] = []
    var selectedRoomStackView: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "객실리스트"
        setupStackView()
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: verticalStackView2.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackView.addArrangedSubview(mainStackView)
        
        let detailView = createDetailView()
        contentStackView.addArrangedSubview(detailView)
        
        // 초기 선택된 카테고리 설정
        selectedCategories.append("스탠다드")

        // "스탠다드" 버튼을 찾아서 배경색을 변경합니다.
        for case let button as UIButton in verticalStackView2.arrangedSubviews[0].subviews {
            if button.title(for: .normal) == "스탠다드" {
                button.backgroundColor = .blue
            }
        }
        // 초기 로드 시 "스탠다드" 방 목록을 로드합니다.
        updateRoomList()
    }
    
    // 카테고리 버튼, 날짜선택, 인원선택
    func setupStackView() {
        let buttonData: [[(String, UIColor)]] = [
            [("스탠다드", .lightGray),("디럭스", .lightGray),("스위트", .lightGray),("패밀리", .lightGray)]
        ]
        
        let stackViews2 = buttonData.map {
            makeHorizontalStackView(buttonInfo: $0)
        }
        self.verticalStackView2 = makeVerticalStackView(stackViews2)
        
        view.addSubview(verticalStackView2)
        
        NSLayoutConstraint.activate([
            verticalStackView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            verticalStackView2.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    func makeVerticalStackView(_ views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeHorizontalStackView(buttonInfo: [(String, UIColor)]) -> UIStackView {
        let buttons = buttonInfo.map {
            makeButton(title: $0.0, backgroundColor: $0.1)
        }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeButton(title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 10)
        button.backgroundColor = backgroundColor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 80)
        ])
        return button
    }
    
    @objc func buttonTapped(sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        if sender.backgroundColor == .lightGray {
            sender.backgroundColor = .blue
            selectedCategories.append(title)
        } else {
            sender.backgroundColor = .lightGray
            if let index = selectedCategories.firstIndex(of: title) {
                selectedCategories.remove(at: index)
            }
        }
        updateRoomList()
    }
    
    func updateRoomList() {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for category in selectedCategories {
            var rooms: [(String, String, String)] = []
            switch category {
            case "스탠다드":
                rooms = rooms1
            case "디럭스":
                rooms = rooms2
            case "스위트":
                rooms = rooms3
            case "패밀리":
                rooms = rooms4
            default:
                break
            }
            
            for room in rooms {
                let roomStackView = createRoomStackView(imageName: room.0, roomName: room.1, price: room.2)
                mainStackView.addArrangedSubview(roomStackView)
            }
        }
    }
    
    func createRoomStackView(imageName: String, roomName: String, price: String) -> UIStackView {
        let roomImageView = UIImageView()
        roomImageView.translatesAutoresizingMaskIntoConstraints = false
        roomImageView.image = UIImage(named: imageName)
        roomImageView.contentMode = .scaleAspectFill
        roomImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            roomImageView.widthAnchor.constraint(equalToConstant: 140),
            roomImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let roomNameLabel = UILabel()
        roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
        roomNameLabel.text = roomName
        roomNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        roomNameLabel.textAlignment = .right
        
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = price
        priceLabel.font = UIFont.systemFont(ofSize: 17)
        priceLabel.textAlignment = .right
        priceLabel.textColor = .gray
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(roomNameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.alignment = .center
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.addArrangedSubview(roomImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(roomTapped))
        horizontalStackView.addGestureRecognizer(tapGesture)
        horizontalStackView.isUserInteractionEnabled = true
        
        return horizontalStackView
    }
    
    @objc func roomTapped(sender: UITapGestureRecognizer) {
        guard let stackView = sender.view as? UIStackView,
              let roomNameLabel = stackView.arrangedSubviews.last?.subviews.first as? UILabel else { return }
        
        // 선택된 객실 강조 표시 및 선택 해제 처리
        if let selectedStackView = selectedRoomStackView {
            selectedStackView.backgroundColor = .clear // 이전 선택 해제
        }
        
        stackView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3) // 현재 선택 강조
        selectedRoomStackView = stackView
        
        let roomName = roomNameLabel.text ?? ""
        updateDetailView(for: roomName)
    }
    
    func updateDetailView(for roomName: String) {
        let detailView = contentStackView.arrangedSubviews.last!
        detailView.subviews.forEach { $0.removeFromSuperview() }
        
        let detailStackView = createDetailStackView(for: roomName)
        detailView.addSubview(detailStackView)
        
        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 20),
            detailStackView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            detailStackView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -20),
            detailStackView.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -20)
        ])
    }
    
    func createDetailStackView(for roomName: String) -> UIStackView {
        let detailStackView = UIStackView()
        detailStackView.axis = .vertical
        detailStackView.spacing = 10
        detailStackView.alignment = .fill
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.spacing = 10
        infoStackView.alignment = .fill
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let roomInfoLabel = UILabel()
        let serviceInfoLabel = UILabel()
        
        switch roomName {
        case "Standard Single Room":
            imageView.image = UIImage(named: "singleRoomImage")
            roomInfoLabel.text = "Standard Single Room\n기준 1인 / 최대 2인\n싱글 침대 1개\n금연객실\n20㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Standard Double Room":
            imageView.image = UIImage(named: "doubleRoomImage")
            roomInfoLabel.text = "Standard Double Room\n기준 2인 / 최대 3인\n더블 침대 1개\n금연객실\n25㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Standard Queen Room":
            imageView.image = UIImage(named: "queenRoomImage")
            roomInfoLabel.text = "Standard Queen Room\n기준 2인 / 최대 3인\n퀸 침대 1개\n금연객실\n30㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Deluxe Single Room":
            imageView.image = UIImage(named: "singleRoomImage")
            roomInfoLabel.text = "Deluxe Single Room\n기준 1인 / 최대 2인\n싱글 침대 1개\n금연객실\n20㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Deluxe Double Room":
            imageView.image = UIImage(named: "doubleRoomImage")
            roomInfoLabel.text = "Deluxe Double Room\n기준 2인 / 최대 3인\n더블 침대 1개\n금연객실\n25㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Deluxe Queen Room":
            imageView.image = UIImage(named: "queenRoomImage")
            roomInfoLabel.text = "Deluxe Queen Room\n기준 2인 / 최대 3인\n퀸 침대 1개\n금연객실\n30㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Sweet Single Room":
            imageView.image = UIImage(named: "singleRoomImage")
            roomInfoLabel.text = "Sweet Single Room\n기준 1인 / 최대 2인\n싱글 침대 1개\n금연객실\n20㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Sweet Double Room":
            imageView.image = UIImage(named: "doubleRoomImage")
            roomInfoLabel.text = "Sweet Double Room\n기준 2인 / 최대 3인\n더블 침대 1개\n금연객실\n25㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Sweet Queen Room":
            imageView.image = UIImage(named: "queenRoomImage")
            roomInfoLabel.text = "Sweet Queen Room\n기준 2인 / 최대 3인\n퀸 침대 1개\n금연객실\n30㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Family Single Room":
            imageView.image = UIImage(named: "singleRoomImage")
            roomInfoLabel.text = "Family Single Room\n기준 1인 / 최대 2인\n싱글 침대 1개\n금연객실\n20㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Family Double Room":
            imageView.image = UIImage(named: "doubleRoomImage")
            roomInfoLabel.text = "Family Double Room\n기준 2인 / 최대 3인\n더블 침대 1개\n금연객실\n25㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        case "Family Queen Room":
            imageView.image = UIImage(named: "queenRoomImage")
            roomInfoLabel.text = "Family Queen Room\n기준 2인 / 최대 3인\n퀸 침대 1개\n금연객실\n30㎡"
            serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        default:
            imageView.image = nil
            roomInfoLabel.text = ""
            serviceInfoLabel.text = ""
        }
        
        roomInfoLabel.numberOfLines = 0
        roomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        serviceInfoLabel.numberOfLines = 0
        serviceInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoStackView.addArrangedSubview(roomInfoLabel)
        infoStackView.addArrangedSubview(serviceInfoLabel)
        
        detailStackView.addArrangedSubview(imageView)
        detailStackView.addArrangedSubview(infoStackView)
        
        // 결제 버튼과 가격을 포함하는 horizontalStackView 추가
        let paymentStackView = UIStackView()
        paymentStackView.axis = .horizontal
        paymentStackView.spacing = 10
        paymentStackView.alignment = .fill
        paymentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        priceLabel.textColor = .black
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        switch roomName {
        case "Standard Single Room":
            priceLabel.text = "1박 130,300원"
        case "Standard Double Room":
            priceLabel.text = "1박 130,300원"
        case "Standard Queen Room":
            priceLabel.text = "1박 130,300원"
        case "Deluxe Single Room":
            priceLabel.text = "1박 160,300원"
        case "Deluxe Double Room":
            priceLabel.text = "1박 160,300원"
        case "Deluxe Queen Room":
            priceLabel.text = "1박 160,300원"
        case "Sweet Single Room":
            priceLabel.text = "1박 190,300원"
        case "Sweet Double Room":
            priceLabel.text = "1박 190,300원"
        case "Sweet Queen Room":
            priceLabel.text = "1박 190,300원"
        case "Family Single Room":
            priceLabel.text = "1박 240,300원"
        case "Family Double Room":
            priceLabel.text = "1박 240,300원"
        case "Family Queen Room":
            priceLabel.text = "1박 240,300원"
        default:
            priceLabel.text = ""
        }
        
        let paymentButton = UIButton(type: .system)
        paymentButton.setTitle("결제하기", for: .normal)
        paymentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        paymentButton.backgroundColor = .white
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
                detailStackView.addArrangedSubview(paymentButton)
        
        paymentStackView.addArrangedSubview(priceLabel)
        paymentStackView.addArrangedSubview(paymentButton)
        
        detailStackView.addArrangedSubview(paymentStackView)
        
        return detailStackView
    }
    
    // 객실 상세
    func createDetailView() -> UIView {
        let detailView = UIView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        return detailView
    }
    
    @objc func paymentButtonTapped() {
          let alert = UIAlertController(title: "결제", message: "결제가 완료되었습니다!", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
        }
}
