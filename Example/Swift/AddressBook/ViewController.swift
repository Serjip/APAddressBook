//
//  ViewController.swift
//  AddressBook
//
//  Created by Alexey Belkevich on 7/31/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

import UIKit

class ViewController: DTTableViewController, APAddressBookDelegate {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    let addressBook = APAddressBook()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCellClass(TableViewCell.self, forModelClass: APContact.self)
        
        self.addressBook.fieldsMask = [APContactField.Default, APContactField.Thumbnail]
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),
            NSSortDescriptor(key: "lastName", ascending: true)]
        self.addressBook.delegate = self
        
        self.addressBook.loadContacts()
    }
    
    
    func addressBook(addressBook: APAddressBook!, didFailLoadContacts error: NSError!) {
        
        let alert = UIAlertView(title: "Error", message: error.localizedDescription,
            delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
        self.activity.stopAnimating()
    }
    
    func addressBook(addressBook: APAddressBook!, didLoadContacts contacts: [APContact]!) {
        
        if (contacts != nil) {
            self.memoryStorage().addItems(contacts)
        }
    }
    
    func addressBook(addressBook: APAddressBook!, shouldAddContact contact: APContact!) -> Bool {
        return contact.phones.count > 0
    }
    
    func addressBookDidChnage(addressBook: APAddressBook!) {
        self.addressBook.loadContacts()
    }
}

