package flutter.plugins.contactsservice.contactsservice;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.annotation.TargetApi;
import android.content.ContentResolver;
import android.database.Cursor;
import android.os.Build;
import android.provider.ContactsContract;
import android.text.TextUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;

import static android.provider.ContactsContract.CommonDataKinds.Email;
import static android.provider.ContactsContract.CommonDataKinds.Organization;
import static android.provider.ContactsContract.CommonDataKinds.Phone;
import static android.provider.ContactsContract.CommonDataKinds.StructuredName;
import static android.provider.ContactsContract.CommonDataKinds.StructuredPostal;

public class ContactsServicePlugin implements MethodCallHandler {

  ContactsServicePlugin(ContentResolver contentResolver){
    this.contentResolver = contentResolver;
  }

  private final ContentResolver contentResolver;

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "github.com/clovisnicolas/flutter_contacts");
    channel.setMethodCallHandler(new ContactsServicePlugin(registrar.context().getContentResolver()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getContacts")) {
      String query = call.argument("query");
      result.success(this.getContacts(query));
    } else {
      result.notImplemented();
    }
  }

  private static final String[] PROJECTION =
    {
      ContactsContract.Data.CONTACT_ID,
      ContactsContract.Profile.DISPLAY_NAME,
      ContactsContract.Contacts.Data.MIMETYPE,
      StructuredName.DISPLAY_NAME,
      StructuredName.GIVEN_NAME,
      StructuredName.MIDDLE_NAME,
      StructuredName.FAMILY_NAME,
      Phone.NUMBER,
      Phone.TYPE,
      Phone.LABEL,
      Email.DATA,
      Email.ADDRESS,
      Email.TYPE,
      Email.LABEL,
      Organization.COMPANY,
      Organization.TITLE,
      StructuredPostal.FORMATTED_ADDRESS,
      StructuredPostal.TYPE,
      StructuredPostal.LABEL,
      StructuredPostal.STREET,
      StructuredPostal.POBOX,
      StructuredPostal.NEIGHBORHOOD,
      StructuredPostal.CITY,
      StructuredPostal.REGION,
      StructuredPostal.POSTCODE,
      StructuredPostal.COUNTRY,
    };


  @TargetApi(Build.VERSION_CODES.ECLAIR)
  private ArrayList getContacts(String query) {
    ArrayList<Contact> contacts = getContactsFrom(getCursor(query));
    //Transform the list of contacts to a list of Map
    ArrayList<HashMap> contactMaps = new ArrayList<>();
    for(Contact c : contacts){
      contactMaps.add(c.toMap());
    }
    return contactMaps;
  }

  @TargetApi(Build.VERSION_CODES.ECLAIR)
  private Cursor getCursor(String query){
    String selection = ContactsContract.Data.MIMETYPE + "=? OR " + ContactsContract.Data.MIMETYPE + "=? OR " + ContactsContract.Data.MIMETYPE + "=? OR " + ContactsContract.Data.MIMETYPE + "=? OR " + ContactsContract.Data.MIMETYPE + "=?";
    String[] selectionArgs = new String[]{Email.CONTENT_ITEM_TYPE, Phone.CONTENT_ITEM_TYPE, StructuredName.CONTENT_ITEM_TYPE, Organization.CONTENT_ITEM_TYPE, StructuredPostal.CONTENT_ITEM_TYPE};
    if(query != null){
      selectionArgs = new String[]{"%" + query + "%"};
      selection = ContactsContract.Contacts.DISPLAY_NAME_PRIMARY + " LIKE ?";
    }
    return contentResolver.query(ContactsContract.Data.CONTENT_URI, PROJECTION, selection, selectionArgs, null);
  }

  /**
   * Builds the list of contacts from the cursor
   * @param cursor
   * @return the list of contacts
   */
  private ArrayList<Contact> getContactsFrom(Cursor cursor) {
    HashMap<String, Contact> map = new LinkedHashMap<>();

    while (cursor != null && cursor.moveToNext()) {
      int columnIndex = cursor.getColumnIndex(ContactsContract.Data.CONTACT_ID);
      String contactId = cursor.getString(columnIndex);

      if (!map.containsKey(contactId)) {
        map.put(contactId, new Contact(contactId));
      }
      Contact contact = map.get(contactId);

      String mimeType = cursor.getString(cursor.getColumnIndex(ContactsContract.Data.MIMETYPE));
      contact.displayName = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));

      //NAMES
      if (mimeType.equals(StructuredName.CONTENT_ITEM_TYPE)) {
        contact.givenName = cursor.getString(cursor.getColumnIndex(StructuredName.GIVEN_NAME));
        contact.middleName = cursor.getString(cursor.getColumnIndex(StructuredName.MIDDLE_NAME));
        contact.familyName = cursor.getString(cursor.getColumnIndex(StructuredName.FAMILY_NAME));
      }
      //PHONES
      else if (mimeType.equals(Phone.CONTENT_ITEM_TYPE)){
        String phoneNumber = cursor.getString(cursor.getColumnIndex(Phone.NUMBER));
        int type = cursor.getInt(cursor.getColumnIndex(Phone.TYPE));
        if (!TextUtils.isEmpty(phoneNumber)){
          contact.phones.add(new Item(Item.getPhoneLabel(type),phoneNumber));
        }
      }
      //MAILS
      else if (mimeType.equals(Email.CONTENT_ITEM_TYPE)) {
        String email = cursor.getString(cursor.getColumnIndex(Email.ADDRESS));
        int type = cursor.getInt(cursor.getColumnIndex(Email.TYPE));
        if (!TextUtils.isEmpty(email)) {
          contact.emails.add(new Item(Item.getEmailLabel(type, cursor),email));
        }
      }
      //ORG
      else if (mimeType.equals(Organization.CONTENT_ITEM_TYPE)) {
        contact.company = cursor.getString(cursor.getColumnIndex(Organization.COMPANY));
        contact.jobTitle = cursor.getString(cursor.getColumnIndex(Organization.TITLE));
      }
      //ADDRESSES
      else if (mimeType.equals(StructuredPostal.CONTENT_ITEM_TYPE)) {
        contact.postalAddresses.add(new PostalAddress(cursor));
      }
    }
    return new ArrayList<>(map.values());
  }

}