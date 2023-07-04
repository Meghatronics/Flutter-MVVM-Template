import '../../../common/data/app_repository.dart';
import '../../../services/restful_api_service/api_request.dart';
import '../domain/models/login_dto.dart';
import '../domain/models/signup_dto.dart';
import '../domain/models/successful_login_model.dart';
import '../domain/models/user_model.dart';
import '../domain/repository_contracts/authentication_repository.dart';

class AuthenticationRepoImpl extends AppRepository
    implements AuthenticationRepository {
  AuthenticationRepoImpl();

  @override
  Future<DataResponse<SuccessfulLoginModel>> login({
    required LoginDto login,
  }) async {
    const endpoint = '/auth/*****';
    final body = {
      'password': login.password,
      if (login.email != null) 'email': login.email!.trim().toLowerCase(),
      if (login.phone != null) 'phone_number': login.phone,
      if (login.country != null) 'phone_code': login.country!.phoneCode,
    };
    final request = ApiRequest.post(endpoint, body, useToken: false);
    final response = await runJsonRequest(
      request,
      (data) => SuccessfulLoginModel.fromMap(data['data']),
    );
    return response;
  }

  @override
  Future<DataResponse<SuccessfulLoginModel>> signup(
    SignupDto signup,
    UserType type,
  ) async {
    const endpoint = '/**/*****';
    final body = {
      'email': signup.email,
      'phone_number': signup.phone,
      'phone_code': signup.phoneCountry.phoneCode,
      'password': signup.password,
      'confirm_password': signup.confirmPassword,
      'firstName': signup.firstName,
      'lastName': signup.lastName,
      'account_type': type.serverCode,
      if (signup.inviteToken != null) 'invite_link_token': signup.inviteToken,
    };
    final request = ApiRequest.post(endpoint, body, useToken: false);
    final response = await runJsonRequest(
      request,
      (data) => SuccessfulLoginModel.fromMap(data['data']),
    );
    return response;
  }

  @override
  Future<DataResponse<SuccessfulLoginModel>> refreshLogin(
      {required String refreshToken}) async {
    const endpoint = '/***/**-))';
    final body = {'refresh_token': refreshToken};
    final request = ApiRequest.post(endpoint, body, useToken: false);
    final response = await runJsonRequest(
      request,
      (data) => SuccessfulLoginModel.fromMap(data['data']),
    );
    return response;
  }

  @override
  Future<DataResponse<bool>> sendVerificationOtp(
      CountryModel country, String phone) async {
    const endpoint = '/****/resend-otp-token';
    final body = {
      'phone_number': phone,
      'phone_code': country.phoneCode,
    };
    final request = ApiRequest.post(endpoint, body);

    final response = await runJsonRequest(request, (data) => true);
    return response;
  }

  @override
  Future<DataResponse<bool>> confirmVerificationOtp({
    required String otp,
    required CountryModel country,
    required String phone,
  }) async {
    const endpoint = '/****/verify-otp-****';
    final body = {
      'phone_number': phone,
      'phone_code': country.phoneCode,
      'otp': otp,
    };
    final request = ApiRequest.post(endpoint, body);

    final response = await runJsonRequest(request, (data) => true);
    return response;
  }
}
