import 'package:flutter/material.dart';

import '../../../../core/views/app_view_builder.dart';
import '../../../../dependencies/app_dependencies.dart';
import '../../../../utilities/theming/app_colors.dart';
import '../../../../utilities/theming/app_styles.dart';
import '../../../shared/components/app_button_widget.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../domain/view_models/phone_verification_view_model.dart';
import '../widgets/countdown_timer_display_widget.dart';
import '../widgets/otp_text_field.dart';
import '../widgets/white_title_bar.dart';

class PhoneVerificationView extends StatelessWidget {
  const PhoneVerificationView({
    super.key,
    required this.phoneCountry,
    required this.phoneNumber,
  });

  final CountryModel phoneCountry;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, kToolbarHeight * 1.5, 16, 16),
        child: AppViewBuilder<PhoneVerificationViewModel>(
          model: AppDependencies.locate(),
          initState: (phoneVerificationVm) =>
              phoneVerificationVm(phoneCountry, phoneNumber),
          builder: (phoneVerificationVm, _) => Column(
            children: [
              WhiteTitleBar(
                heading:
                    'Enter the ${phoneVerificationVm.codeLength}-digit Code',
                subHeading: 'Please enter the verification code '
                    'you received via SMS at ${phoneVerificationVm.phoneNumber}',
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12),
                child: Form(
                  key: phoneVerificationVm.formKey,
                  child: Column(
                    children: [
                      OtpTextField(
                        length: phoneVerificationVm.codeLength,
                        controller: phoneVerificationVm.otpField,
                        onCompleted: (_) => phoneVerificationVm.verifyOtp(),
                        validator: (otp) {
                          if (otp.isEmpty) {
                            return 'Verification code cannot be empty';
                          }
                          if (otp.length < phoneVerificationVm.codeLength) {
                            return 'Cannot be less than ${phoneVerificationVm.codeLength} digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (phoneVerificationVm.isBusy)
                        const SizedBox(height: 16)
                      else
                        CountdownTimerDisplayWidget.fromDateTime(
                          phoneVerificationVm.resendCodeAvailableAt,
                          format: 'mm:ss',
                          style: AppStyles.of(context).textStyle.copyWith(
                                color: AppColors.of(context).bodyText,
                              ),
                          prefix: Text(
                            'Resend Code in ',
                            style: AppStyles.of(context).textStyle.copyWith(
                                  color: AppColors.of(context).bodyText,
                                ),
                          ),
                          expiredWidget: InkResponse(
                            onTap: phoneVerificationVm.resendResetOtp,
                            child: Text(
                              'Resend Code',
                              style: AppStyles.of(context).textStyle.copyWith(
                                    color: AppColors.of(context).bodyText,
                                  ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Submit',
                        busy: phoneVerificationVm.isBusy,
                        onPressed: phoneVerificationVm.verifyOtp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
