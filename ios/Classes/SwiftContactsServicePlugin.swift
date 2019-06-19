import Flutter
import UIKit
import Contacts

@available(iOS 9.0, *)
public class SwiftContactsServicePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "github.com/clovisnicolas/flutter_contacts", binaryMessenger: registrar.messenger())
        let instance = SwiftContactsServicePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getContacts":
            let arguments = call.arguments as! [String:Any]
            result(getContacts(query: (arguments["query"] as? String), withThumbnails: arguments["withThumbnails"] as! Bool,
                               photoHighResolution: arguments["photoHighResolution"] as! Bool, phoneQuery:  false))
        case "getContactsForPhone":
            let arguments = call.arguments as! [String:Any]
            result(getContacts(query: (arguments["phone"] as? String), withThumbnails: arguments["withThumbnails"] as! Bool,
                               photoHighResolution: arguments["photoHighResolution"] as! Bool, phoneQuery:  true))
        case "addContact":
            let contact = dictionaryToContact(dictionary: call.arguments as! [String : Any])

            let addResult = addContact(contact: contact)
            if (addResult == "") {
                result(nil)
            }
            else {
                result(FlutterError(code: "", message: addResult, details: nil))
            }
        case "deleteContact":
            if(deleteContact(dictionary: call.arguments as! [String : Any])){
                result(nil)
            }
            else{
                result(FlutterError(code: "", message: "Failed to delete contact, make sure it has a valid identifier", details: nil))
            }
        case "updateContact":
            if(updateContact(dictionary: call.arguments as! [String: Any])) {
                result(nil)
            }
            else {
                result(FlutterError(code: "", message: "Failed to update contact, make sure it has a valid identifier", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
//    func searchForContactUsingPhoneNumber(phoneNumber: String) {
//
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), { () -> Void in
//            self.requestForAccess { (accessGranted) -> Void in
//                if accessGranted {
//                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactPhoneNumbersKey]
//                    var contacts = [CNContact]()
//                    var message: String!
//
//                    let contactsStore = CNContactStore()
//                    do {
//                        try contactsStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) {
//                            (contact, cursor) -> Void in
//                            if (!contact.phoneNumbers.isEmpty) {
//                                let phoneNumberToCompareAgainst = phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
//                                for phoneNumber in contact.phoneNumbers {
//                                    if let phoneNumberStruct = phoneNumber.value as? CNPhoneNumber {
//                                        let phoneNumberString = phoneNumberStruct.stringValue
//                                        let phoneNumberToCompare = phoneNumberString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
//                                        if phoneNumberToCompare == phoneNumberToCompareAgainst {
//                                            contacts.append(contact)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//                        if contacts.count == 0 {
//                            message = "No contacts were found matching the given phone number."
//                        }
//                    }
//                    catch {
//                        message = "Unable to fetch contacts."
//                    }
//
//                    if message != nil {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            self.showMessage(message)
//                        })
//                    }
//                    else {
//                        // Success
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            // Do someting with the contacts in the main queue, for example
//                            /*
//                             self.delegate.didFetchContacts(contacts) <= which extracts the required info and puts it in a tableview
//                             */
//                            print(contacts) // Will print all contact info for each contact (multiple line is, for example, there are multiple phone numbers or email addresses)
//                            let contact = contacts[0] // For just the first contact (if two contacts had the same phone number)
//                            print(contact.givenName) // Print the "first" name
//                            print(contact.familyName) // Print the "last" name
//                            if contact.isKeyAvailable(CNContactImageDataKey) {
//                                if let contactImageData = contact.imageData {
//                                    print(UIImage(data: contactImageData)) // Print the image set on the contact
//                                }
//                            } else {
//                                // No Image available
//
//                            }
//                        })
//                    }
//                }
//            }
//        })
//    }

    func getContacts(query : String?, withThumbnails: Bool, photoHighResolution: Bool, phoneQuery: Bool) -> [[String:Any]]{
        var contacts : [CNContact] = []
        //Create the store, keys & fetch request
        let store = CNContactStore()
        var keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey,
                    CNContactFamilyNameKey,
                    CNContactGivenNameKey,
                    CNContactMiddleNameKey,
                    CNContactNamePrefixKey,
                    CNContactNameSuffixKey,
                    CNContactPostalAddressesKey,
                    CNContactOrganizationNameKey,
                    CNContactNoteKey,
                    CNContactJobTitleKey] as [Any]
        
        if(withThumbnails){
            if(photoHighResolution){
                keys.append(CNContactImageDataKey)
            } else {
                keys.append(CNContactThumbnailImageDataKey)
            }
        }
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        // Set the predicate if there is a query
        if let query = query{
            fetchRequest.predicate = CNContact.predicateForContacts(matchingName: query)
            
        }
        // Fetch contacts
        do{
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                contacts.append(contact)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
        // Transform the CNContacts into dictionaries
        var result = [[String:Any]]()
        for contact : CNContact in contacts{
            result.append(contactToDictionary(contact: contact))
        }
        return result
    }

    func addContact(contact : CNMutableContact) -> String {
        let store = CNContactStore()
        do {
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            try store.execute(saveRequest)
        }
        catch {
            return error.localizedDescription
        }
        return ""
    }

    func deleteContact(dictionary : [String:Any]) -> Bool{
        guard let identifier = dictionary["identifier"] as? String else{
            return false;
        }
        let store = CNContactStore()
        let keys = [CNContactIdentifierKey as NSString]
        do{
            if let contact = try store.unifiedContact(withIdentifier: identifier, keysToFetch: keys).mutableCopy() as? CNMutableContact{
                let request = CNSaveRequest()
                request.delete(contact)
                try store.execute(request)
            }
        }
        catch{
            print(error.localizedDescription)
            return false;
        }
        return true;
    }

    func updateContact(dictionary : [String:Any]) -> Bool{

        // Check to make sure dictionary has an identifier
        guard let identifier = dictionary["identifier"] as? String else{
            return false;
        }

        let store = CNContactStore()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey,
                    CNContactFamilyNameKey,
                    CNContactGivenNameKey,
                    CNContactMiddleNameKey,
                    CNContactNamePrefixKey,
                    CNContactNameSuffixKey,
                    CNContactPostalAddressesKey,
                    CNContactOrganizationNameKey,
                    CNContactNoteKey,
                    CNContactJobTitleKey] as [Any]
        do {
            // Check if the contact exists
            if let contact = try store.unifiedContact(withIdentifier: identifier, keysToFetch: keys as! [CNKeyDescriptor]).mutableCopy() as? CNMutableContact{

                /// Update the contact that was retrieved from the store
                //Simple fields
                contact.givenName = dictionary["givenName"] as? String ?? ""
                contact.familyName = dictionary["familyName"] as? String ?? ""
                contact.middleName = dictionary["middleName"] as? String ?? ""
                contact.namePrefix = dictionary["prefix"] as? String ?? ""
                contact.nameSuffix = dictionary["suffix"] as? String ?? ""
                contact.organizationName = dictionary["company"] as? String ?? ""
                contact.jobTitle = dictionary["jobTitle"] as? String ?? ""
                contact.note = dictionary["note"] as? String ?? ""
                contact.imageData = (dictionary["avatar"] as? FlutterStandardTypedData)?.data

                //Phone numbers
                if let phoneNumbers = dictionary["phones"] as? [[String:String]]{
                    var updatedPhoneNumbers = [CNLabeledValue<CNPhoneNumber>]()
                    for phone in phoneNumbers where phone["value"] != nil {
                        updatedPhoneNumbers.append(CNLabeledValue(label:getPhoneLabel(label: phone["label"]),value:CNPhoneNumber(stringValue: phone["value"]!)))
                    }
                    contact.phoneNumbers = updatedPhoneNumbers
                }

                //Emails
                if let emails = dictionary["emails"] as? [[String:String]]{
                    var updatedEmails = [CNLabeledValue<NSString>]()
                    for email in emails where nil != email["value"] {
                        let emailLabel = email["label"] ?? ""
                        updatedEmails.append(CNLabeledValue(label: emailLabel, value: email["value"]! as NSString))
                    }
                    contact.emailAddresses = updatedEmails
                }

                //Postal addresses
                if let postalAddresses = dictionary["postalAddresses"] as? [[String:String]]{
                    var updatedPostalAddresses = [CNLabeledValue<CNPostalAddress>]()
                    for postalAddress in postalAddresses{
                        let newAddress = CNMutablePostalAddress()
                        newAddress.street = postalAddress["street"] ?? ""
                        newAddress.city = postalAddress["city"] ?? ""
                        newAddress.postalCode = postalAddress["postcode"] ?? ""
                        newAddress.country = postalAddress["country"] ?? ""
                        newAddress.state = postalAddress["region"] ?? ""
                        let label = postalAddress["label"] ?? ""
                        updatedPostalAddresses.append(CNLabeledValue(label: label, value: newAddress))
                    }
                    contact.postalAddresses = updatedPostalAddresses
                }

                // Attempt to update the contact
                let request = CNSaveRequest()
                request.update(contact)
                try store.execute(request)
            }
        }
        catch {
            print(error.localizedDescription)
            return false;
        }
        return true;
    }

    func dictionaryToContact(dictionary : [String:Any]) -> CNMutableContact{
        let contact = CNMutableContact()

        //Simple fields
        contact.givenName = dictionary["givenName"] as? String ?? ""
        contact.familyName = dictionary["familyName"] as? String ?? ""
        contact.middleName = dictionary["middleName"] as? String ?? ""
        contact.namePrefix = dictionary["prefix"] as? String ?? ""
        contact.nameSuffix = dictionary["suffix"] as? String ?? ""
        contact.organizationName = dictionary["company"] as? String ?? ""
        contact.jobTitle = dictionary["jobTitle"] as? String ?? ""
        contact.note = dictionary["note"] as? String ?? ""
        if let avatarData = (dictionary["avatar"] as? FlutterStandardTypedData)?.data {
            contact.imageData = avatarData
        }

        //Phone numbers
        if let phoneNumbers = dictionary["phones"] as? [[String:String]]{
            for phone in phoneNumbers where phone["value"] != nil {
                contact.phoneNumbers.append(CNLabeledValue(label:getPhoneLabel(label:phone["label"]),value:CNPhoneNumber(stringValue:phone["value"]!)))
            }
        }

        //Emails
        if let emails = dictionary["emails"] as? [[String:String]]{
            for email in emails where nil != email["value"] {
                let emailLabel = email["label"] ?? ""
                contact.emailAddresses.append(CNLabeledValue(label:emailLabel, value:email["value"]! as NSString))
            }
        }

        //Postal addresses
        if let postalAddresses = dictionary["postalAddresses"] as? [[String:String]]{
            for postalAddress in postalAddresses{
                let newAddress = CNMutablePostalAddress()
                newAddress.street = postalAddress["street"] ?? ""
                newAddress.city = postalAddress["city"] ?? ""
                newAddress.postalCode = postalAddress["postcode"] ?? ""
                newAddress.country = postalAddress["country"] ?? ""
                newAddress.state = postalAddress["region"] ?? ""
                let label = postalAddress["label"] ?? ""
                contact.postalAddresses.append(CNLabeledValue(label:label, value:newAddress))
            }
        }

        return contact
    }

    func contactToDictionary(contact: CNContact) -> [String:Any]{

        var result = [String:Any]()

        //Simple fields
        result["identifier"] = contact.identifier
        result["displayName"] = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName)
        result["givenName"] = contact.givenName
        result["familyName"] = contact.familyName
        result["middleName"] = contact.middleName
        result["prefix"] = contact.namePrefix
        result["suffix"] = contact.nameSuffix
        result["company"] = contact.organizationName
        result["jobTitle"] = contact.jobTitle
        result["note"] = contact.note
        if contact.isKeyAvailable(CNContactThumbnailImageDataKey) {
            if let avatarData = contact.thumbnailImageData {
                result["avatar"] = FlutterStandardTypedData(bytes: avatarData)
            }
        }
        if contact.isKeyAvailable(CNContactImageDataKey) {
            if let avatarData = contact.imageData {
                result["avatar"] = FlutterStandardTypedData(bytes: avatarData)
            }
        }

        //Phone numbers
        var phoneNumbers = [[String:String]]()
        for phone in contact.phoneNumbers{
            var phoneDictionary = [String:String]()
            phoneDictionary["value"] = phone.value.stringValue
            phoneDictionary["label"] = "other"
            if let label = phone.label{
                phoneDictionary["label"] = CNLabeledValue<NSString>.localizedString(forLabel: label)
            }
            phoneNumbers.append(phoneDictionary)
        }
        result["phones"] = phoneNumbers

        //Emails
        var emailAddresses = [[String:String]]()
        for email in contact.emailAddresses{
            var emailDictionary = [String:String]()
            emailDictionary["value"] = String(email.value)
            emailDictionary["label"] = "other"
            if let label = email.label{
                emailDictionary["label"] = CNLabeledValue<NSString>.localizedString(forLabel: label)
            }
            emailAddresses.append(emailDictionary)
        }
        result["emails"] = emailAddresses

        //Postal addresses
        var postalAddresses = [[String:String]]()
        for address in contact.postalAddresses{
            var addressDictionary = [String:String]()
            addressDictionary["label"] = ""
            if let label = address.label{
                addressDictionary["label"] = CNLabeledValue<NSString>.localizedString(forLabel: label)
            }
            addressDictionary["street"] = address.value.street
            addressDictionary["city"] = address.value.city
            addressDictionary["postcode"] = address.value.postalCode
            addressDictionary["region"] = address.value.state
            addressDictionary["country"] = address.value.country

            postalAddresses.append(addressDictionary)
        }
        result["postalAddresses"] = postalAddresses

        return result
    }

    func getPhoneLabel(label: String?) -> String{
        let labelValue = label ?? ""
        switch(labelValue){
        case "main": return CNLabelPhoneNumberMain
        case "mobile": return CNLabelPhoneNumberMobile
        case "iPhone": return CNLabelPhoneNumberiPhone
        default: return labelValue
        }
    }

}
