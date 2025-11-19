import '../../model/ContactsResponse.dart';
import '../../networking/services/communication/contacts_service.dart';

class ContactsRepository {
  final _provider = ContactsService();

  Future<ContactsResponse> getContacts({int page = 1, int size = 20}) async {
    return _provider.getContacts(page: page, size: size);
  }
}
