//
//  ZYCustomComboBoxViewController.swift
//  ZhiHuiSheQuCA
//
//  Created by 朱勇 on 2017/10/18.
//  Copyright © 2017年 TongBuWeiYe. All rights reserved.
//

import UIKit

@objc public protocol ZYCustomComboBoxDelegate: NSObjectProtocol {
    func customComboBox(_ textField: ZYCustomComboBox, didSelect row: Int)
    func customComboBoxNumberOfRows(_ textField: ZYCustomComboBox) -> Int
    func customComboBoxHeightForRows(_ textField: ZYCustomComboBox) -> CGFloat
    func customComboBox(_ textField: ZYCustomComboBox, viewFor row: Int, reusingView view: UIView?) -> UIView
    func customComboBoxPresentingViewController(_ textField: ZYCustomComboBox) -> UIViewController
    func customComboBoxRectFromWhereToPresent(_ textField: ZYCustomComboBox) -> CGRect
    func customComboBoxFromBarButton(_ textField: ZYCustomComboBox) -> UIBarButtonItem?
    func customComboBoxTintColor(_ textField: ZYCustomComboBox) -> UIColor
    func customComboBoxToolbarColor(_ textField: ZYCustomComboBox) -> UIColor
    func customComboBoxDidTappedCancel(_ textField: ZYCustomComboBox)
    func customComboBoxDidTappedDone(_ textField: ZYCustomComboBox)
}
@objc open class ZYCustomComboBox: UITextField {
    open weak var delegateForComboBox: ZYCustomComboBoxDelegate?
    var customComboBoxViewController: ZYCustomComboBoxViewController?
    open func showOptions() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "MyComboBoxControls", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                self.customComboBoxViewController = ZYCustomComboBoxViewController(nibName: "ZYCustomComboBoxViewController", bundle: bundle)
                self.customComboBoxViewController?.modalPresentationStyle = .popover
                self.customComboBoxViewController?.popoverPresentationController?.delegate = self.customComboBoxViewController
                self.customComboBoxViewController?.customComboBox = self
                if let btn = self.delegateForComboBox?.customComboBoxFromBarButton(self) {
                    self.customComboBoxViewController?.popoverPresentationController?.barButtonItem = btn
                } else {
                    self.customComboBoxViewController?.popoverPresentationController?.sourceView = self.delegateForComboBox?.customComboBoxPresentingViewController(self).view
                    self.customComboBoxViewController?.popoverPresentationController?.sourceRect = self.delegateForComboBox!.customComboBoxRectFromWhereToPresent(self)
                }
                self.delegateForComboBox?.customComboBoxPresentingViewController(self).present(self.customComboBoxViewController!, animated: true, completion: nil)
            } else {
                assertionFailure("Could not load the bundle")
            }
        } else {
            assertionFailure("Could not create a path to the bundle")
        }
    }
}
@objc open class ZYCustomComboBoxViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    weak var customComboBox: ZYCustomComboBox?
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320, height: 260)
        if let clr = self.customComboBox?.delegateForComboBox?.customComboBoxTintColor(self.customComboBox!) {
            self.toolBar.tintColor = clr
        }
        if let clr = self.customComboBox?.delegateForComboBox?.customComboBoxToolbarColor(self.customComboBox!) {
            self.toolBar.backgroundColor = clr
        }
        self.customComboBox!.delegateForComboBox?.customComboBox(self.customComboBox!, didSelect: 0)
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.customComboBox!.delegateForComboBox?.customComboBox(self.customComboBox!, didSelect: row)
    }
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.customComboBox?.delegateForComboBox?.customComboBoxNumberOfRows(self.customComboBox!))!
    }
    open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return (self.customComboBox?.delegateForComboBox?.customComboBoxHeightForRows(self.customComboBox!))!
    }
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return (self.customComboBox!.delegateForComboBox?.customComboBox(self.customComboBox!, viewFor: row, reusingView: view))!
    }
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction open func btnDoneTapped(_ sender: UIBarButtonItem) {
        self.customComboBox?.delegateForComboBox?.customComboBoxDidTappedDone(self.customComboBox!)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction open func btnCancelTapped(_ sender: UIBarButtonItem) {
        self.customComboBox?.delegateForComboBox?.customComboBoxDidTappedCancel(self.customComboBox!)
        self.dismiss(animated: true, completion: nil)
    }
    open func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
