import '../../../../core/view_model/data_response.dart';
import '../models/login_dto.dart';

abstract class ForgotPasswordRepository {
  Future<DataResponse<String>> sendResetOtp(LoginDto credential);
  Future<DataResponse<String>> verifyResetOtp(String otp, String token);
  Future<DataResponse<bool>> resetPassword({
    required String newPassword,
    required String token,
  });
}
