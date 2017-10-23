//
//  ZYDateTimeBoxViewController.swift
//  ZhiHuiSheQuCA
//
//  Created by 朱勇 on 2017/10/18.
//  Copyright © 2017年 TongBuWeiYe. All rights reserved.
//

import UIKit

@objc public protocol ZYDateTimeBoxDelegate: NSObjectProtocol {
    func dateTimeBox(_ textField: ZYDateTimeBox, didSelectDate date: Date)
    func dateTimeBoxType(_ textField: ZYDateTimeBox) -> UIDatePickerMode
    func dateTimeBoxMinimumDate(_ textField: ZYDateTimeBox) -> Date?
    func dateTimeBoxMaximumDate(_ textField: ZYDateTimeBox) -> Date?
    func dateTimeBoxPresentingViewController(_ textField: ZYDateTimeBox) -> UIViewController
    func dateTimeBoxRectFromWhereToPresent(_ textField: ZYDateTimeBox) -> CGRect
    func dateTimeBoxFromBarButton(_ textField: ZYDateTimeBox) -> UIBarButtonItem?
    func dateTimeBoxTintColor(_ textField: ZYDateTimeBox) -> UIColor
    func dateTimeBoxToolbarColor(_ textField: ZYDateTimeBox) -> UIColor
    func dateTimeBoxDidTappedCancel(_ textField: ZYDateTimeBox)
    func dateTimeBoxDidTappedDone(_ textField: ZYDateTimeBox)
}
@objc open class ZYDateTimeBox: UITextField {
    open weak var delegateForDateTimeBox: ZYDateTimeBoxDelegate?
    var dateTimeBoxViewController: ZYDateTimeBoxViewController?
    open func showOptions() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "MyComboBoxControls", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                self.dateTimeBoxViewController = ZYDateTimeBoxViewController(nibName: "ZYDateTimeBoxViewController", bundle: bundle)
                self.dateTimeBoxViewController?.modalPresentationStyle = .popover
                self.dateTimeBoxViewController?.popoverPresentationController?.delegate = self.dateTimeBoxViewController
                self.dateTimeBoxViewController?.dateTimeBox = self
                if let btn = self.delegateForDateTimeBox?.dateTimeBoxFromBarButton(self) {
                    self.dateTimeBoxViewController?.popoverPresentationController?.barButtonItem = btn
                }else {
                    self.dateTimeBoxViewController?.popoverPresentationController?.sourceView = self.delegateForDateTimeBox?.dateTimeBoxPresentingViewController(self).view
                    self.dateTimeBoxViewController?.popoverPresentationController?.sourceRect = (self.delegateForDateTimeBox?.dateTimeBoxRectFromWhereToPresent(self))!
                }
                self.delegateForDateTimeBox?.dateTimeBoxPresentingViewController(self).present(self.dateTimeBoxViewController!, animated: true, completion: nil)
            }else {
                assertionFailure("Could not load the bundle")
            }
        }else {
            assertionFailure("Could not create a path to the bundle")
        }
    }
}
class ZYDateTimeBoxViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    weak var dateTimeBox: ZYDateTimeBox?
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320, height: 260)
        if let clr = self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBoxTintColor(self.dateTimeBox!) {
            self.toolBar.tintColor = clr
        }
        if let clr = self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBoxToolbarColor(self.dateTimeBox!) {
            self.toolBar.backgroundColor = clr
        }
        if let max = self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBoxMaximumDate(self.dateTimeBox!) {
            self.pickerView.maximumDate = max
            self.dateTimeBox!.delegateForDateTimeBox?.dateTimeBox(self.dateTimeBox!, didSelectDate: max)
        }
        if let min = self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBoxMinimumDate(self.dateTimeBox!) {
            self.pickerView.minimumDate = min
        }
        self.pickerView.datePickerMode = (self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBoxType(self.dateTimeBox!))!
    }
    @IBAction open func dateChanged(_ sender: UIDatePicker) {
        self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBox(self.dateTimeBox!, didSelectDate: sender.date)
    }
    @IBAction open func btnDoneTapped(_ sender: UIBarButtonItem) {
        self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBoxDidTappedDone(self.dateTimeBox!)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction open func btnCancelTapped(_ sender: UIBarButtonItem) {
        self.dateTimeBox?.delegateForDateTimeBox?.dateTimeBoxDidTappedCancel(self.dateTimeBox!)
        self.dismiss(animated: true, completion: nil)
    }
    open func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
