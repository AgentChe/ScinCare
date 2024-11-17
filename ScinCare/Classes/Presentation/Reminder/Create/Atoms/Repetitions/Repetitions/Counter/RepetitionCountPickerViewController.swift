//
//  RepetitionCountPickerViewController.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 14.11.2024.
//

import UIKit

class RepetitionCountPickerViewController: UIViewController {
    private lazy var mainView = RepetitionCountPickerView()
    private let type: RepetitionCountType
    private var action: ((Int) -> Void)?
    
    init(type: RepetitionCountType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.pickerView.dataSource = self
        mainView.pickerView.delegate = self
        mainView.setup(type: type)
        
        mainView.confirmButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    }
}

extension RepetitionCountPickerViewController {
    static func make(type: RepetitionCountType, didTapSave: @escaping (Int) -> Void) -> RepetitionCountPickerViewController {
        let vc = RepetitionCountPickerViewController(type: type)
        vc.action = didTapSave
        return vc
    }
}

extension RepetitionCountPickerViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        type.dataSource.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
}

extension RepetitionCountPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        "\(type.dataSource[row])".attributed(with: .picker)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        57.scale
    }
}

private extension RepetitionCountPickerViewController {
    @objc func saveAction() {
        let selectedRow = mainView.pickerView.selectedRow(inComponent: 0)
        action?(type.dataSource[selectedRow])
    }
}

private extension TextAttributes {
    static let picker = TextAttributes()
        .font(Fonts.Roboto.medium(size: 18.scale))
        .textColor(Appearance.mono200)
}
