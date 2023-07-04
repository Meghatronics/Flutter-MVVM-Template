import 'package:flutter/material.dart';

import '../../presentation.dart';
import 'app_bottom_sheet.dart';
import 'searchable_list_sheet.dart';

class AppDropdownField<T> extends StatefulWidget {
  const AppDropdownField({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.onChanged,
    this.label,
    this.hint,
    this.isRequired = false,
    this.validator,
    this.onTap,
    this.icon,
    this.validatorMode = AutovalidateMode.disabled,
  });

  final DropdownValueController<T> controller;
  final Widget Function(T item) itemBuilder;
  final String? label;
  final String? hint;
  final bool isRequired;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onTap;
  final AutovalidateMode validatorMode;
  final String? Function(T?)? validator;
  final Widget? icon;

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  final _errorNotifier = ValueNotifier<String?>(null);
  late final FocusNode _focusNode;

  bool _sheetIsOpen = false;
  @override
  void initState() {
    widget.controller.addListener(listener);
    _focusNode = FocusNode(
      canRequestFocus: true,
      skipTraversal: false,
      descendantsAreFocusable: false,
      descendantsAreTraversable: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    setState(() {});
  }

  String? _validator(T? value) {
    final hasValidator = widget.validator != null;
    String? error;
    if (!hasValidator && widget.isRequired && (value == null)) {
      error = 'This field is required';
    }

    if (hasValidator) {
      error = widget.validator!(value);
    }
    Future.delayed(
      Duration.zero,
      () => _errorNotifier.value = error,
    );
    return error != null ? '' : null;
  }

  Future<void> _showSelectionSheet(BuildContext context) async {
    AppBottomSheet selectionSheet;

    if (widget.controller._searchable) {
      selectionSheet = SearchableListSheet<T>(
        heading: widget.label,
        dataList: widget.controller.options.toSet(),
        searchQuery: widget.controller.searchOptions,
        itemBuilder: (context, item) => Container(
          constraints: const BoxConstraints(
            maxHeight: 56,
            minHeight: 48,
          ),
          padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: item == widget.controller.value
                ? AppColors.of(context).grey3
                : null,
          ),
          child: widget.itemBuilder(item),
        ),
      );
    } else {
      selectionSheet = AppBottomSheet<T>(
        heading: widget.label,
        padding: const EdgeInsets.all(16),
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (T item in widget.controller.options)
              InkWell(
                onTap: () => Navigator.of(context).pop(item),
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 56,
                    minHeight: 48,
                  ),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: item == widget.controller.value
                        ? AppColors.of(context).grey3
                        : null,
                  ),
                  child: widget.itemBuilder(item),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    _sheetIsOpen = true;
    final selection = await selectionSheet.show(
      context: context,
      routeName: '${widget.label} Dropdown',
      isScrollControlled: true,
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      _sheetIsOpen = false;
      listener();
    });

    if (widget.onChanged != null) widget.onChanged!(selection);
    if (selection != null) {
      widget.controller.value = selection;
      _focusNode.nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.value;
    final isFocused = _focusNode.hasFocus;
    return GestureDetector(
      onTap: () async {
        if (isFocused) {
          _showSelectionSheet(context);
        } else {
          _focusNode.requestFocus();
        }
      },
      child: Focus.withExternalFocusNode(
        focusNode: _focusNode,
        key: ObjectKey(widget.label),
        autofocus: false,
        onFocusChange: (focused) {
          if (focused && !_sheetIsOpen) {
            _showSelectionSheet(context);
          }
          listener();
        },
        child: ValueListenableBuilder(
          valueListenable: _errorNotifier,
          builder: (_, error, __) => Column(
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
                            style: AppStyles.of(context)
                                .label14Regular
                                .copyWith(
                                  color:
                                      AppColors.of(context).attitudeErrorDark,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 56,
                  minHeight: 48,
                ),
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: isFocused || _sheetIsOpen ? 1.6 : 1,
                    color: error != null
                        ? AppColors.of(context).attitudeErrorDark
                        : AppColors.of(context).grey3,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: value != null
                          ? widget.itemBuilder(value)
                          : widget.hint != null
                              ? Text(
                                  widget.hint!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                    color: AppColors.of(context).grey3,
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ),
                    widget.icon ??
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.of(context).grey3,
                          size: 24,
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Offstage(
                child: TextFormField(
                  autofocus: false,
                  readOnly: true,
                  enabled: false,
                  validator: (_) => _validator(value),
                  decoration: const InputDecoration(
                    isDense: true,
                    errorStyle: TextStyle(
                      height: 1,
                      fontSize: 1,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              if (error != null)
                Text(
                  error,
                  style: AppStyles.of(context)
                      .body12Regular
                      .copyWith(color: AppColors.of(context).attitudeErrorDark),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownValueController<T> extends ValueNotifier<T?> {
  DropdownValueController({
    T? initialValue,
    List<T> options = const [],
  })  : _options = options.toSet(),
        _searchable = false,
        _searchQueryHandler = null,
        super(initialValue);

  DropdownValueController.searchable({
    T? initialValue,
    List<T> options = const [],
    required Set<T> Function(String query, Set<T> options) searchQueryHandler,
  })  : _options = options.toSet(),
        _searchable = true,
        _searchQueryHandler = searchQueryHandler,
        super(initialValue);

  Set<T> _options;
  final bool _searchable;
  final Set<T> Function(String query, Set<T> options)? _searchQueryHandler;

  Set<T> searchOptions(String query) {
    if (_searchQueryHandler != null) {
      return _searchQueryHandler!(query, _options);
    }
    if (T is String) {
      return _options
          .where(
            (option) => (option as String).contains(query),
          )
          .toSet();
    }
    return _options;
  }

  List<T> get options => _options.toList();

  set options(Iterable<T> val) {
    _options = val.toSet();
    notifyListeners();
  }

  void clear() {
    value = null;
  }
}
