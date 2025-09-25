//
// import '../../api_base_helper.dart';
//
// class LoginService {
//   final ApiBaseHelper _helper = ApiBaseHelper();
//
//   Future<LoginResponse> login(
//       {required String email, required String password}) async {
//     var data = {
//       Params.email: email,
//       Params.password: password,
//     };
//
//     final response = await _helper.post(Endpoints.login, data);
//     return LoginResponse.fromJson(response);
//   }
// }
