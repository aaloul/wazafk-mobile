import '../../../model/ContactsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ContactsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ContactsResponse> getContacts({int page = 1, int size = 20}) async {
    final response = await _helper.get(
      '${Endpoints.contacts}?page=$page&size=$size',
    );
    return ContactsResponse.fromJson(response);
  }
}
