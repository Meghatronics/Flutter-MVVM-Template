import 'package:flutter/material.dart';

import '../../../../core/views/app_view_builder.dart';
import '../../../../dependencies/app_dependencies.dart';
import '../../../../utilities/mixins/validator_mixin.dart';
import '../../../shared/components/app_button_widget.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../domain/models/login_dto.dart';
import '../../domain/models/login_method_enum.dart';
import '../../domain/view_models/forgot_password_view_model.dart';
import '../widgets/login_method_switch_button.dart';
import '../widgets/white_title_bar.dart';

class ForgotPasswordView extends StatelessWidget with ValidatorMixin {
  const ForgotPasswordView({super.key, required this.credential});

  final LoginDto? credential;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, kToolbarHeight * 1.5, 16, 16),
        child: Column(
          children: [
            const WhiteTitleBar(
              heading: 'Forgot Password?',
              subHeading: 'Don’t worry we’ve got you covered. '
                  'Enter the email address associated to your account.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12),
                child: AppViewBuilder<ForgotPasswordViewModel>(
                  model: AppDependencies.locate(),
                  initState: (forgotPasswordVm) =>
                      forgotPasswordVm.init(credential),
                  builder: (forgotPasswordVm, _) => Form(
                    key: forgotPasswordVm.formKeys[0],
                    child: Column(
                      children: [
                        if (forgotPasswordVm.loginMethod.isEmail)
                          AppTextField(
                            label: 'Email',
                            hint: 'Enter your email',
                            isRequired: true,
                            controller: forgotPasswordVm.emailField,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            capitalization: TextCapitalization.none,
                            suffix: LoginMethodSwitchButton(
                              loginMethod: LoginMethod.phone,
                              onTapped: forgotPasswordVm.changeRecoveryMethod,
                            ),
                            keyboardAction: TextInputAction.go,
                            onEditComplete: () {
                              FocusScope.of(context).unfocus();
                              forgotPasswordVm.sendResetOtp();
                            },
                          )
                        else if (forgotPasswordVm.loginMethod.isPhone)
                          AppPhoneNumberField(
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            isRequired: true,
                            controller: forgotPasswordVm.phoneField,
                            suffix: LoginMethodSwitchButton(
                              loginMethod: LoginMethod.email,
                              onTapped: forgotPasswordVm.changeRecoveryMethod,
                            ),
                            validator: validatePhone,
                            keyboardAction: TextInputAction.go,
                            onEditComplete: () {
                              FocusScope.of(context).unfocus();
                              forgotPasswordVm.sendResetOtp();
                            },
                          ),
                        const SizedBox(height: 32),
                        AppButton(
                          label: 'Reset',
                          onPressed: forgotPasswordVm.sendResetOtp,
                          busy: forgotPasswordVm.isBusy,
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
