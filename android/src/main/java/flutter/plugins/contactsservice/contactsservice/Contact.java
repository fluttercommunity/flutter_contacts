package flutter.plugins.contactsservice.contactsservice;

import java.util.ArrayList;
import java.util.HashMap;

public class Contact {

    Contact(String id){
        this.id = id;
    }

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
}
