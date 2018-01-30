package flutter.plugins.contactsservice.contactsservice;

import java.util.ArrayList;
import java.util.HashMap;

public class Contact {

    Contact(String id){
        this.id = id;
    }
    private Contact(){}

    String id;
    String displayName, givenName, middleName, familyName, prefix, suffix, company, jobTitle;
    ArrayList<Item> emails = new ArrayList<>();
    ArrayList<Item> phones = new ArrayList<>();
    ArrayList<PostalAddress> postalAddresses = new ArrayList<>();

    HashMap<String,Object> toMap(){
        HashMap<String,Object> contactMap = new HashMap<>();
        contactMap.put("displayName",displayName);
        contactMap.put("givenName",givenName);
        contactMap.put("middleName",middleName);
        contactMap.put("familyName",familyName);
        contactMap.put("prefix", prefix);
        contactMap.put("suffix", suffix);
        contactMap.put("company",company);
        contactMap.put("jobTitle",jobTitle);

        ArrayList<HashMap<String,String>> emailsMap = new ArrayList<>();
        for(Item email : emails){
            emailsMap.add(email.toMap());
        }
        contactMap.put("emails",emailsMap);

        ArrayList<HashMap<String,String>> phonesMap = new ArrayList<>();
        for(Item phone : phones){
            phonesMap.add(phone.toMap());
        }
        contactMap.put("phones",phonesMap);

        ArrayList<HashMap<String,String>> addressesMap = new ArrayList<>();
        for(PostalAddress address : postalAddresses){
            addressesMap.add(address.map);
        }
        contactMap.put("postalAddresses",addressesMap);

        return contactMap;
    }

    static Contact fromMap(HashMap map){
        Contact contact = new Contact();
        contact.givenName = (String)map.get("givenName");
        contact.middleName = (String)map.get("middleName");
        contact.familyName = (String)map.get("familyName");
        contact.prefix = (String)map.get("prefix");
        contact.suffix = (String)map.get("suffix");
        contact.company = (String)map.get("company");
        contact.jobTitle = (String)map.get("jobTitle");

        ArrayList<HashMap> emails = (ArrayList<HashMap>) map.get("emails");
        for(HashMap email : emails){
            contact.emails.add(Item.fromMap(email));
        }
        ArrayList<HashMap> phones = (ArrayList<HashMap>) map.get("phones");
        for(HashMap phone : phones){
            contact.emails.add(Item.fromMap(phone));
        }
        ArrayList<HashMap> postalAddresses = (ArrayList<HashMap>) map.get("postalAddresses");
        for(HashMap postalAddress : postalAddresses){
            contact.postalAddresses.add(PostalAddress.fromMap(postalAddress));
        }
        return contact;
    }
}
