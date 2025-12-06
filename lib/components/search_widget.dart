import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/extentions.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppIcons.dart';
import '../utils/utils.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({
    super.key,
    this.controller,
    this.isLoading,
    this.onTextChanged,
    this.onTextChangedWithDelay,
    this.hint,
    this.textInputAction,
    this.margin,
    this.height,
    this.onClick,
    this.enabled,
    this.borderColor,
    this.showCloseButton,
    this.onCloseClick,
    this.type,
    this.borderRadius,
    this.onSearchSubmit,
    this.focusNode,
  });

  TextEditingController? controller = TextEditingController();
  bool? isLoading = false;
  String? hint;
  bool? enabled;
  Function? onClick;
  String? type;

  TextInputAction? textInputAction;
  Function? onTextChanged;
  Function? onTextChangedWithDelay;
  Function? onSearchSubmit;
  Color? borderColor;
  double? margin;
  double? height;
  double? borderRadius;
  bool? showCloseButton;
  Function? onCloseClick;
  FocusNode? focusNode;

  final _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AbsorbPointer(
        absorbing: !(enabled ?? true),
        child: Container(
          // height: height ?? 42,
          margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: context.resources.color.colorWhite,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            border: Border.all(
              color: borderColor ?? context.resources.color.colorWhite,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.search,
                  width: 20,
                  color: context.resources.color.colorGrey,
                ),
                Expanded(
                  child: SizedBox(
                    height: height ?? 42,
                    child: TextFormField(
                      focusNode: focusNode,
                      textAlignVertical: TextAlignVertical.top,
                      cursorColor: context.resources.color.colorPrimary,
                      onEditingComplete: () => onTextChangedWithDelay != null
                          ? Utils().hideKeyboard(Get.context!)
                          : context.nextEditableTextFocus(),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      controller: controller,
                      textInputAction:
                          textInputAction ?? TextInputAction.search,
                      onFieldSubmitted: (text) {
                        if (onSearchSubmit != null) {
                          onSearchSubmit!(text);
                        }
                      },
                      onChanged: (text) {
                        if (onTextChanged != null) {
                          onTextChanged!(text);
                        }

                        if (onTextChangedWithDelay != null) {
                          _debouncer.run(() {
                            if (onTextChangedWithDelay != null) {
                              onTextChangedWithDelay!(text);
                            }
                          });
                        }
                      },
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: context.resources.color.colorGrey,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          top: Utils().isRTL() ? 0 : 0,
                          right: 8,
                          left: 8,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: hint ?? "Search jobs, Projects",
                        hintStyle: TextStyle(
                          color: context.resources.color.colorGrey7,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                // if (showCloseButton ?? false)
                //   GestureDetector(
                //       onTap: () {
                //         onCloseClick?.call();
                //       },
                //       child: Image.asset(
                //         AppIcons.closeCircle,
                //         width: 24,
                //         color: Theme.of(context)
                //             .textTheme
                //             .displaySmall
                //             ?.color
                //             ?.withOpacity(.6),
                //       ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
