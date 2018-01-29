package flutter.plugins.contactsservice.contactsservice;

import android.database.Cursor;
import android.text.TextUtils;

import static android.provider.ContactsContract.CommonDataKinds.StructuredPostal;

import java.util.HashMap;

public class PostalAddress {

    HashMap<String,String> map = new HashMap<>();

    PostalAddress(Cursor cursor){
        map.put("label", getLabel(cursor));
        map.put("street", cursor.getString(cursor.getColumnIndex(StructuredPostal.STREET)));
        map.put("city", cursor.getString(cursor.getColumnIndex(StructuredPostal.CITY)));
        map.put("postcode", cursor.getString(cursor.getColumnIndex(StructuredPostal.POSTCODE)));
        map.put("region", cursor.getString(cursor.getColumnIndex(StructuredPostal.REGION)));
        map.put("country", cursor.getString(cursor.getColumnIndex(StructuredPostal.COUNTRY)));
    }

    String getLabel(Cursor cursor) {
        switch (cursor.getInt(cursor.getColumnIndex(StructuredPostal.TYPE))) {
            case StructuredPostal.TYPE_HOME:
                return "home";
            case StructuredPostal.TYPE_WORK:
                return "work";
            case StructuredPostal.TYPE_CUSTOM:
                final String label = cursor.getString(cursor.getColumnIndex(StructuredPostal.LABEL));
                return label != null ? label : "";
        }
        return "other";
    }

}
