//
//  ZYComboBoxViewController.swift
//  ZhiHuiSheQuCA
//
//  Created by 朱勇 on 2017/10/18.
//  Copyright © 2017年 TongBuWeiYe. All rights reserved.
//

import UIKit

@objc public protocol ZYComboBoxDelegate: NSObjectProtocol {
    func comboBox(_ textField: ZYComboBox, didSelectRow row: Int)
    func comboBoxNumberOfRows(_ textField: ZYComboBox) -> Int
    func comboBox(_ textField: ZYComboBox, textForRow row: Int) -> String
    func comboBoxPresentingViewController(_ textField: ZYComboBox) -> UIViewController
    func comboBoxRectFromWhereToPresent(_ textField: ZYComboBox) -> CGRect
    func comboBoxFromBarButton(_ textField: ZYComboBox) -> UIBarButtonItem?
    func comboBoxTintColor(_ textField: ZYComboBox) -> UIColor
    func comboBoxToolbarColor(_ textField: ZYComboBox) -> UIColor
    func comboBoxDidTappedCancel(_ textField: ZYComboBox)
    func comboBoxDidTappedDone(_ textField: ZYComboBox)
}
@objc open class ZYComboBox: UITextField {
    open weak var delegateForComboBox: ZYComboBoxDelegate?
    var comboBoxViewController: ZYComboBoxViewController?
    open func showOptions() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "MyComboBoxControls", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                self.comboBoxViewController = ZYComboBoxViewController(nibName: "ZYComboBoxViewController", bundle: bundle)
                self.comboBoxViewController?.modalPresentationStyle = .popover
                self.comboBoxViewController?.popoverPresentationController?.delegate = self.comboBoxViewController
                self.comboBoxViewController?.comboBox = self
                if let btn = self.delegateForComboBox?.comboBoxFromBarButton(self) {
                    self.comboBoxViewController?.popoverPresentationController?.barButtonItem = btn
                }else {
                    self.comboBoxViewController?.popoverPresentationController?.sourceView = self.delegateForComboBox?.comboBoxPresentingViewController(self).view
                    self.comboBoxViewController?.popoverPresentationController?.sourceRect = self.delegateForComboBox!.comboBoxRectFromWhereToPresent(self)
                }
                self.delegateForComboBox?.comboBoxPresentingViewController(self).present(self.comboBoxViewController!, animated: true, completion: nil)
            }else {
                assertionFailure("Could not load the bundle")
            }
        }else {
            assertionFailure("Could not create a path to the bundle")
        }
    }
}
@objc open class ZYComboBoxViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    weak var comboBox: ZYComboBox?
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320, height: 260)
        if let clr = self.comboBox?.delegateForComboBox?.comboBoxTintColor(self.comboBox!) {
            self.toolBar.tintColor = clr
        }
        if let clr = self.comboBox?.delegateForComboBox?.comboBoxToolbarColor(self.comboBox!) {
            self.toolBar.backgroundColor = clr
        }
        self.comboBox!.delegateForComboBox?.comboBox(self.comboBox!, didSelectRow: 0)
    }
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.comboBox!.delegateForComboBox?.comboBox(self.comboBox!, didSelectRow: row)
    }
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.comboBox?.delegateForComboBox?.comboBoxNumberOfRows(self.comboBox!))!
    }
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.comboBox?.delegateForComboBox?.comboBox(self.comboBox!, textForRow: row)
    }
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction open func btnDoneTapped(_ sender: UIBarButtonItem) {
        self.comboBox?.delegateForComboBox?.comboBoxDidTappedDone(self.comboBox!)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction open func btnCancelTapped(_ sender: UIBarButtonItem) {
        self.comboBox?.delegateForComboBox?.comboBoxDidTappedCancel(self.comboBox!)
        self.dismiss(animated: true, completion: nil)
    }
    open func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
