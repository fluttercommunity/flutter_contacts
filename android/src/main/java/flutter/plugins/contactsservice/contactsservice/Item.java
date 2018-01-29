package flutter.plugins.contactsservice.contactsservice;

import android.database.Cursor;
import android.provider.ContactsContract;

import java.util.HashMap;

/***
 * Represents an object which has a label and a value
 * such as an email or a phone
 ***/
public class Item{

    public String label, value;

    public Item(String label, String value) {
        this.label = label;
        this.value = value;
    }

    HashMap<String, String> toMap(){
        HashMap<String,String> result = new HashMap<>();
        result.put("label",label);
        result.put("value",value);
        return result;
    }

    public static String getPhoneLabel(int type){
        switch (type) {
            case ContactsContract.CommonDataKinds.Phone.TYPE_HOME:
                return "home";
            case ContactsContract.CommonDataKinds.Phone.TYPE_WORK:
                return "work";
            case ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE:
                return "mobile";
            default:
                return "other";
        }
    }

    public static String getEmailLabel(int type, Cursor cursor) {
        switch (type) {
            case ContactsContract.CommonDataKinds.Email.TYPE_HOME:
                return "home";
            case ContactsContract.CommonDataKinds.Email.TYPE_WORK:
                return "work";
            case ContactsContract.CommonDataKinds.Email.TYPE_MOBILE:
                return "mobile";
            case ContactsContract.CommonDataKinds.Email.TYPE_CUSTOM:
                if (cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.LABEL)) != null) {
                    return cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.LABEL)).toLowerCase();
                } else return "";
            default:
                return "other";
        }
    }
}
