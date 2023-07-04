import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../presentation.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.isRequired = false,
    this.focusNode,
    this.onChanged,
    this.onFocusChange,
    this.onTap,
    this.onEditComplete,
    this.validator,
    this.validatorMode = AutovalidateMode.disabled,
    this.prefixText,
    this.prefix,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.keyboardAction = TextInputAction.next,
    this.capitalization = TextCapitalization.sentences,
    this.keyboardPadding = 40,
    this.enabled = true,
    this.formatters,
  })  : _isSecret = false,
        obscuringCharacter = '*';

  const AppTextField.secret({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.isRequired = false,
    this.focusNode,
    this.onChanged,
    this.onFocusChange,
    this.onTap,
    this.onEditComplete,
    this.validator,
    this.validatorMode = AutovalidateMode.disabled,
    this.prefixText,
    this.prefix,
    this.keyboardType = TextInputType.text,
    this.keyboardAction = TextInputAction.next,
    this.capitalization = TextCapitalization.none,
    this.keyboardPadding = 40,
    this.enabled = true,
    this.formatters,
    this.obscuringCharacter = '•',
  })  : _isSecret = true,
        suffix = null;

  final String? label;
  final String? hint;
  final bool isRequired;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onTap;
  final VoidCallback? onEditComplete;
  final AutovalidateMode validatorMode;
  final String? Function(String)? validator;
  final String? prefixText;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final TextCapitalization capitalization;
  final double keyboardPadding;
  final bool enabled;
  final List<TextInputFormatter>? formatters;
  final String obscuringCharacter;
  final bool _isSecret;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _errorNotifier = ValueNotifier<String?>(null);
  late final FocusNode _focusNode;
  late bool _visible;

  @override
  void initState() {
    _visible = !widget._isSecret;
    _focusNode = widget.focusNode ?? FocusNode();
    final focusChangeCallback = widget.onFocusChange;
    if (focusChangeCallback != null) {
      _focusNode.addListener(() => focusChangeCallback(_focusNode.hasFocus));
    }
    super.initState();
  }

  void _toggleVisibility() {
    setState(() {
      _visible = !_visible;
    });
  }

  String? _validator(String? value) {
    final hasValidator = widget.validator != null;
    String? error;
    if (!hasValidator &&
        widget.isRequired &&
        (value == null || value.isEmpty)) {
      error = 'This field is required';
    }

    if (hasValidator) {
      error = widget.validator!(value ?? '');
    }
    Future.delayed(
      Duration.zero,
      () => _errorNotifier.value = error,
    );
    return error != null ? '' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RichText(
              text: TextSpan(
                style: AppStyles.of(context).label14Regular,
                children: [
                  TextSpan(
                    text: widget.label,
                  ),
                  if (widget.isRequired)
                    TextSpan(
                      text: ' *',
                      style: AppStyles.of(context).label14Regular.copyWith(
                            color: AppColors.of(context).attitudeErrorDark,
                          ),
                    ),
                ],
              ),
            ),
          ),
        TextFormField(
          focusNode: _focusNode,
          enabled: widget.enabled,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.keyboardAction,
          textCapitalization: widget.capitalization,
          obscureText: !_visible,
          obscuringCharacter: widget.obscuringCharacter,
          scrollPadding: EdgeInsets.only(bottom: widget.keyboardPadding),
          validator: _validator,
          autovalidateMode: widget.validatorMode,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditComplete ??
              () {
                FocusScope.of(context).nextFocus();
              },
          style: AppStyles.of(context).value16Regular,
          inputFormatters: widget.formatters,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintMaxLines: 1,
            prefixText: widget.prefixText,
            prefixIcon: widget.prefix,
            suffixIcon: widget._isSecret
                ? ExcludeFocus(
                    child: IconButton(
                      onPressed: _toggleVisibility,
                      icon: Icon(
                        _visible
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        color: AppColors.of(context).secondaryColor,
                      ),
                    ),
                  )
                : widget.suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            errorStyle: const TextStyle(
              height: 1,
              fontSize: 1,
              color: Colors.transparent,
            ),
            hintStyle: AppStyles.of(context).label14Regular.copyWith(
                  color: AppColors.of(context).grey4,
                ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.of(context).primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.6,
                color: AppColors.of(context).primaryColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: AppColors.of(context).attitudeErrorLight,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.6,
                color: AppColors.of(context).attitudeErrorDark,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _errorNotifier,
          builder: (_, error, __) => error == null
              ? const SizedBox.shrink()
              : Text(
                  error,
                  style: AppStyles.of(context).body14Regular.copyWith(
                        color: AppColors.of(context).attitudeErrorDark,
                      ),
                ),
        )
      ],
    );
  }
}
