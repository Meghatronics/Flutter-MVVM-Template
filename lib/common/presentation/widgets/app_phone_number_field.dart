import 'dart:collection';

import 'package:flutter/material.dart';

import '../../domain/models/country_model.dart';
import '../presentation.dart';
import 'components/app_text_field.dart';
import 'components/searchable_list_sheet.dart';

class AppPhoneNumberField extends StatelessWidget {
  const AppPhoneNumberField({
    super.key,
    required this.controller,
    required this.validator,
    this.isRequired = false,
    this.label,
    this.hint,
    this.suffix,
    this.keyboardAction = TextInputAction.next,
    this.onEditComplete,
    this.enabled = true,
  });

  final PhoneInputController controller;
  final String? label;
  final String? hint;
  final bool isRequired;
  final String? Function(String? number, CountryModel? country) validator;
  final Widget? suffix;
  final TextInputAction keyboardAction;
  final VoidCallback? onEditComplete;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: TextInputType.phone,
      keyboardAction: keyboardAction,
      onEditComplete: onEditComplete,
      isRequired: true,
      validator: (p0) => validator(p0, controller.country),
      suffix: suffix,
      enabled: enabled,
      prefix: InkResponse(
        onTap: () => controller.selectCountry(context),
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, v, __) => Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${controller.country?.flag ?? ''}${controller.country?.phoneCode ?? '     '}',
                    style: AppStyles.of(context).value16Regular.copyWith(
                          color: AppColors.of(context).textMute,
                        ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.of(context).grey3,
                    size: 20,
                  ),
                  VerticalDivider(
                    width: 1,
                    color: AppColors.of(context).grey3,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneInputController extends TextEditingController {
  CountryModel? _country;
  CountryModel? get country => _country;

  set country(CountryModel? val) {
    _country = val;
    notifyListeners();
  }

  final _countries = <CountryModel>{};

  UnmodifiableListView<CountryModel> get supportedCountries =>
      UnmodifiableListView(_countries);
  set supportedCountries(Iterable<CountryModel> countries) {
    _countries.clear();
    _countries.addAll(countries);
    notifyListeners();
  }

  void addCountries(Iterable<CountryModel> countries) {
    _countries.addAll(countries);
    notifyListeners();
  }

  Future<void> selectCountry([BuildContext? context]) async {
    final sheet = SearchableListSheet<CountryModel>(
      currentValue: _country,
      dataList: _countries,
      listenable: this,
      searchQuery: (query) {
        final searchQuery = query.toLowerCase();
        final startsWithQuery = _countries.where(
          (country) =>
              country.name.toLowerCase().startsWith(searchQuery) ||
              country.phoneCode.startsWith(searchQuery),
        );

        final containsQuery = _countries.where(
          (country) =>
              country.name.toLowerCase().contains(searchQuery) ||
              country.phoneCode.contains(searchQuery),
        );

        final filteredList = startsWithQuery.followedBy(containsQuery).toSet();
        return filteredList;
      },
      itemBuilder: (context, country) => Row(
        children: [
          Text(
            country.flag,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Text(
            '${country.name} (${country.phoneCode})',
            style: AppStyles.of(context).value16Regular,
          ),
        ],
      ),
    );

    final selection = await sheet.show(context: context);
    if (selection != null) {
      _country = selection;
      notifyListeners();
    }
  }
}
