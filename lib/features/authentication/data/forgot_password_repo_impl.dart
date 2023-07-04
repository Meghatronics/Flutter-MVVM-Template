import '../../../core/data/api_repository.dart';
import '../../../core/view_model/data_response.dart';
import '../../../services/restful_api_service/api_request.dart';
import '../domain/models/login_dto.dart';
import '../domain/repository_contracts/forgot_password_repository.dart';

class ForgotPasswordRepoImpl extends ApiRepository
    implements ForgotPasswordRepository {
  ForgotPasswordRepoImpl(super.apiService);

  @override
  Future<DataResponse<String>> sendResetOtp(LoginDto credential) async {
    const endpoint = '/users/forgot-password';
    final body = {
      if (credential.email != null)
        'email': credential.email!.trim().toLowerCase(),
      if (credential.phone != null) 'phone_number': credential.phone,
      if (credential.country != null)
        'phone_code': credential.country!.phoneCode,
    };
    final request = ApiRequest.patch(endpoint, body, useToken: false);
    final response = await runJsonRequest(
      request,
      (data) => data['data']['token'].toString(),
    );
    return response;
  }

  @override
  Future<DataResponse<String>> verifyResetOtp(String otp, String token) async {
    const endpoint = '/users/confirm-forgot-password-otp';
    final body = {
      'otp': otp,
      'token': token,
    };
    final request = ApiRequest.patch(endpoint, body);

    final response = await runJsonRequest(
      request,
      (data) => data['data']['token'].toString(),
    );
    return response;
  }

  @override
  Future<DataResponse<bool>> resetPassword({
    required String newPassword,
    required String token,
  }) async {
    const endpoint = '/users/change-forgot-password';
    final body = {
      'new_pwd': newPassword,
      'token': token,
    };
    final request = ApiRequest.patch(endpoint, body);

    final response = await runJsonRequest(request, (data) => true);
    return response;
  }
}
