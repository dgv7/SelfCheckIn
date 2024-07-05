import UIKit

class ViewController: UIViewController {
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var dateButton: UIButton?
    var verticalStackView2: UIStackView!
    let rooms = [
        ("singleRoomImage", "Classic Single Room", "1박 130,300원 ~"),
        ("doubleRoomImage", "Deluxe Double Room", "1박 130,300원 ~"),
        ("queenRoomImage", "Noblesse Queen Room", "1박 130,300원 ~")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "객실리스트"
        setupStackView()
        view.backgroundColor = .white
        
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: verticalStackView2.bottomAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackView.addArrangedSubview(mainStackView)
        
        for room in rooms {
            let roomStackView = createRoomStackView(imageName: room.0, roomName: room.1, price: room.2)
            mainStackView.addArrangedSubview(roomStackView)
        }
        
        let detailView = createDetailView()
        contentStackView.addArrangedSubview(detailView)
    }
    
    // 카테고리 버튼, 날짜선택, 인원선택
    func setupStackView(){
        let datePerson: [[(String, UIColor)]] = [
            [("기간선택", .lightGray),("0명", .lightGray)]
        ]
        
        let buttonData: [[(String, UIColor)]] = [
            [("스탠다드", .lightGray),("디럭스", .lightGray),("스위트", .lightGray),("패밀리", .lightGray)]
        ]
        let stackViews1 = datePerson.map{
            makeHorizontalStackView(buttonInfo: $0)
        }
        let stackViews2 = buttonData.map{
            makeHorizontalStackView(buttonInfo: $0)
        }
        let verticalStackView1 = makeVerticalStackView(stackViews1)
        self.verticalStackView2 = makeVerticalStackView(stackViews2)
        
        view.addSubview(verticalStackView1)
        view.addSubview(verticalStackView2)
        NSLayoutConstraint.activate([
            verticalStackView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            verticalStackView1.widthAnchor.constraint(equalToConstant: 350)
        ])
        NSLayoutConstraint.activate([
            verticalStackView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView2.topAnchor.constraint(equalTo: verticalStackView1.bottomAnchor, constant: 10),
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
        let buttons = buttonInfo.map{
            makeButton(title: $0.0, backgroundColor: $0.1)
        }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeButton(title: String, backgroundColor: UIColor) -> UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 10)
        button.backgroundColor = backgroundColor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        
        if title == "기간선택" {
            dateButton = button
        }
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 80)
        ])
        return button
    }
    
    @objc func buttonTapped(sender: UIButton){
        guard let buttonText = sender.currentTitle else {return}
        if buttonText == "기간선택"{
            showDatePicker()
        }
    }
    
    func showDatePicker() {
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .automatic
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .automatic
        
        let alert = UIAlertController(title: "기간을 선택하세요", message: nil, preferredStyle: .actionSheet)
        let stackView = UIStackView(arrangedSubviews: [startDatePicker, endDatePicker])
        stackView.axis = .vertical
        stackView.spacing = 10
        alert.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -150)
        ])
        let selectAction = UIAlertAction(title: "날짜선택", style: .default) { _ in
            let startDate = self.startDatePicker.date
            let endDate = self.endDatePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateStyle = .medium
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            let dateRangeString = "\(startDateString) ~ \(endDateString)"
            print("Selected date range: \(dateRangeString)")
            self.dateButton?.setTitle(dateRangeString, for: .normal)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 객실 리스트
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
        
        return horizontalStackView
    }
    
    
    
    // 객실 상세
    func createDetailView() -> UIView {
        
        
        let detailView = UIView()
        
        let detailStackView = UIStackView()
        detailStackView.axis = .vertical
        detailStackView.spacing = 10
        detailStackView.alignment = .fill
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.isHidden = false
        
        detailView.addSubview(detailStackView)
        
                
        // Image View
        let imageView = UIImageView()
        imageView.image = UIImage(named: "doubleRoomImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.addSubview(imageView)
        
        // Room Info Label
        let roomInfoLabel = UILabel()
        roomInfoLabel.text = "객실명\n기준 2인 / 최대 4인\n더블 침대 1개\n금연객실\n40㎡\n스파르타 전망"
        roomInfoLabel.numberOfLines = 0
        roomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.addSubview(roomInfoLabel)
        
        // Service Info Label
        let serviceInfoLabel = UILabel()
        serviceInfoLabel.text = "주요 서비스 및 편의시설\n무료 와이파이"
        serviceInfoLabel.numberOfLines = 0
        serviceInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.addSubview(serviceInfoLabel)
        
        // Price Label
        let priceLabel = UILabel()
        priceLabel.text = "34% 726,000원\n472,200원"
        priceLabel.numberOfLines = 0
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.addSubview(priceLabel)
        
        // Payment Button
        let paymentButton = UIButton(type: .system)
        paymentButton.setTitle("결제하기", for: .normal)
        paymentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        paymentButton.backgroundColor = .lightGray
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.addSubview(paymentButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            roomInfoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            roomInfoLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            roomInfoLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -20),
            
            serviceInfoLabel.topAnchor.constraint(equalTo: roomInfoLabel.bottomAnchor, constant: 20),
            serviceInfoLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            serviceInfoLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: serviceInfoLabel.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -20),
            
            paymentButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            paymentButton.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            paymentButton.widthAnchor.constraint(equalToConstant: 100),
            paymentButton.heightAnchor.constraint(equalToConstant: 50),
            paymentButton.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -20)
        ])
        
        return detailView
    }
}
