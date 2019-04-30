package flutter.plugins.contactsservice.contactsservice;

import android.database.Cursor;
import android.provider.ContactsContract;

import static android.provider.ContactsContract.CommonDataKinds;

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

    public static Item fromMap(HashMap<String,String> map){
        return new Item(map.get("label"), map.get("value"));
    }

    public static String getPhoneLabel(int type){
        switch (type) {
            case CommonDataKinds.Phone.TYPE_HOME:
                return "home";
            case CommonDataKinds.Phone.TYPE_WORK:
                return "work";
            case CommonDataKinds.Phone.TYPE_MOBILE:
                return "mobile";
            case CommonDataKinds.Phone.TYPE_FAX_WORK:
                return "fax work";
            case CommonDataKinds.Phone.TYPE_FAX_HOME:
                return "fax home";
            case CommonDataKinds.Phone.TYPE_MAIN:
                return "main";
            case CommonDataKinds.Phone.TYPE_COMPANY_MAIN:
                return "company";
            case CommonDataKinds.Phone.TYPE_PAGER:
                return "pager";
            default:
                return "other";
        }
    }

    public static String getEventLabel(int type, Cursor cursor) {
        switch (type) {
            case CommonDataKinds.Event.TYPE_ANNIVERSARY:
                return "anniversary";
            case CommonDataKinds.Event.TYPE_BIRTHDAY:
                return "birthday";
            case CommonDataKinds.Event.TYPE_OTHER:
                if (cursor.getString(cursor.getColumnIndex(CommonDataKinds.Event.LABEL)) != null) {
                    return cursor.getString(cursor.getColumnIndex(CommonDataKinds.Event.LABEL)).toLowerCase();
                } else return "";
            default:
                return "other";
        }
    }

    public static String getEmailLabel(int type, Cursor cursor) {
        switch (type) {
            case CommonDataKinds.Email.TYPE_HOME:
                return "home";
            case CommonDataKinds.Email.TYPE_WORK:
                return "work";
            case CommonDataKinds.Email.TYPE_MOBILE:
                return "mobile";
            case CommonDataKinds.Email.TYPE_CUSTOM:
                if (cursor.getString(cursor.getColumnIndex(CommonDataKinds.Email.LABEL)) != null) {
                    return cursor.getString(cursor.getColumnIndex(CommonDataKinds.Email.LABEL)).toLowerCase();
                } else return "";
            default:
                return "other";
        }
    }


    public static String getWebLabel(int type, Cursor cursor) {
        switch (type) {
            case CommonDataKinds.Website.TYPE_HOMEPAGE:
                return "homepage";
            case CommonDataKinds.Website.TYPE_BLOG:
                return "blog";
            case CommonDataKinds.Website.TYPE_PROFILE:
                return "profile";
            case CommonDataKinds.Website.TYPE_HOME:
                return "home";
            case CommonDataKinds.Website.TYPE_WORK:
                return "work";
            case CommonDataKinds.Website.TYPE_FTP:
                return "ftp";
            case CommonDataKinds.Website.TYPE_OTHER:
                if (cursor.getString(cursor.getColumnIndex(CommonDataKinds.Website.LABEL)) != null) {
                    return cursor.getString(cursor.getColumnIndex(CommonDataKinds.Website.LABEL)).toLowerCase();
                } else return "";
            default:
                return "other";
        }
    }

    public static int stringToPhoneType(String label) {
        if (label != null) {
            switch (label) {
                case "home":
                    return CommonDataKinds.Phone.TYPE_HOME;
                case "work":
                    return CommonDataKinds.Phone.TYPE_WORK;
                case "mobile":
                    return CommonDataKinds.Phone.TYPE_MOBILE;
                case "fax work":
                    return CommonDataKinds.Phone.TYPE_FAX_WORK;
                case "fax home":
                    return CommonDataKinds.Phone.TYPE_FAX_HOME;
                case "main":
                    return CommonDataKinds.Phone.TYPE_MAIN;
                case "company":
                    return CommonDataKinds.Phone.TYPE_COMPANY_MAIN;
                case "pager":
                    return CommonDataKinds.Phone.TYPE_PAGER;
                default:
                    return CommonDataKinds.Phone.TYPE_OTHER;
            }
        }
        return CommonDataKinds.Phone.TYPE_OTHER;
    }

    public static int stringToEmailType(String label) {
        if (label != null) {
            switch (label) {
                case "home":
                    return CommonDataKinds.Email.TYPE_HOME;
                case "work":
                    return CommonDataKinds.Email.TYPE_WORK;
                case "mobile":
                    return CommonDataKinds.Email.TYPE_MOBILE;
                default:
                    return CommonDataKinds.Email.TYPE_OTHER;
            }
        }
        return CommonDataKinds.Email.TYPE_OTHER;
    }

}
