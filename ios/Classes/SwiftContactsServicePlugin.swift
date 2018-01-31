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
            result(getContacts(query: (call.arguments as! String?)))
        case "addContact":
            if(addContact(dictionary: (call.arguments as! [String : Any]))){
                result(nil)
            }
            else{
                result(FlutterError(code: "", message: "Failed to add contact", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func getContacts(query : String?) -> [[String:Any]]{
        var contacts : [CNContact] = []
        //Create the store, keys & fetch request
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
                    CNContactJobTitleKey] as [Any]
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
    
    func addContact(dictionary : [String:Any]) -> Bool {
        let contact = dictionaryToContact(dictionary: dictionary)
        let store = CNContactStore()
        do{
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            try store.execute(saveRequest)
        }
        catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    func dictionaryToContact(dictionary : [String:Any]) -> CNMutableContact{
        let contact = CNMutableContact()
        
        //Simple fields
        if let givenName = dictionary["givenName"] as? String{
            contact.givenName = givenName
        }
        if let familyName = dictionary["familyName"] as? String{
            contact.familyName = familyName
        }
        if let middleName = dictionary["middleName"] as? String{
            contact.middleName = middleName
        }
        if let prefix = dictionary["prefix"] as? String{
            contact.namePrefix = prefix
        }
        if let suffix = dictionary["suffix"] as? String{
            contact.nameSuffix = suffix
        }
        if let company = dictionary["company"] as? String{
            contact.organizationName = company
        }
        if let jobTitle = dictionary["jobTitle"] as? String{
            contact.jobTitle = jobTitle
        }
        
        //Phone numbers
        if let phoneNumbers = dictionary["phones"] as? [[String:String]]{
            for phone in phoneNumbers {
                if let number = phone["value"]{
                    contact.phoneNumbers.append(CNLabeledValue(label:getPhoneLabel(label:phone["label"]),value:CNPhoneNumber(stringValue:number)))
                }
            }
        }
        
        //Emails
        if let emails = dictionary["emails"] as? [[String:String]]{
            for email in emails {
                if let address = email["value"]{
                    let emailLabel = email["label"] ?? ""
                    contact.emailAddresses.append(CNLabeledValue(label:emailLabel, value:address as NSString))
                }
            }
        }
        
        //Postal addresses
        if let postalAddresses = dictionary["postalAddresses"] as? [[String:String]]{
            for postalAddress in postalAddresses{
                let newAddress = CNMutablePostalAddress()
                if let street = postalAddress["street"]{
                    newAddress.street = street
                }
                if let city = postalAddress["city"]{
                    newAddress.city = city
                }
                if let postcode = postalAddress["postcode"]{
                    newAddress.postalCode = postcode
                }
                if let country = postalAddress["country"]{
                    newAddress.country = country
                }
                if let region = postalAddress["region"]{
                    newAddress.state = region
                }
                let label = postalAddress["label"] ?? ""
                contact.postalAddresses.append(CNLabeledValue(label:label, value:newAddress))
            }
        }
        
        return contact
    }
    
    func contactToDictionary(contact: CNContact) -> [String:Any]{
        
        var result = [String:Any]()
        
        //Simple fields
        result["displayName"] = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName)
        result["givenName"] = contact.givenName
        result["familyName"] = contact.familyName
        result["middleName"] = contact.middleName
        result["prefix"] = contact.namePrefix
        result["suffix"] = contact.nameSuffix
        result["company"] = contact.organizationName
        result["jobTitle"] = contact.jobTitle
        
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
        if let label = label{
            switch(label){
            case "main": return CNLabelPhoneNumberMain
            case "mobile": return CNLabelPhoneNumberMobile
            case "iPhone": return CNLabelPhoneNumberiPhone
            default: return label
            }
        }
        return ""
    }
    
}
