import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reusable_widgets.dart';
import 'package:intl/intl.dart' as intl;

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final TextInputType? inputType;
  final Function? validator;
  final Function? onTap;
  final Function? onEditingComplete;
  final bool isObscure;
  final bool isReadOnly;
  final Widget? prefix;
  final Color? fillColor;
  final Function? onSaved;
  final Function? onChanged;
  final bool showObscureIcon;
  final TextInputAction? inputAction;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final Widget? onSuffix;
  final List<TextInputFormatter>? inputFormatters;
  final bool arabicPadding;

  const CustomTextField(
      {Key? key,
      this.hintText = '',
      this.labelText,
      this.inputType,
      this.validator,
      this.onTap,
      this.fillColor,
      this.prefix,
      this.isReadOnly = false,
       this.showObscureIcon = true,
      this.onEditingComplete,
      this.isObscure = false,
      this.onSaved,
      this.onChanged,
      this.onSuffix,
      this.inputAction,
      this.inputFormatters,
      this.controller,
      this.maxLength,
        this.arabicPadding = false,
      this.maxLines})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool enableLabel = false;
  bool enableObscure = true;
  @override
  Widget build(BuildContext context) {
    return CustomForm(
      controller: widget.controller,
      isObscure: widget.isObscure,
      labelText: enableLabel ? widget.labelText : null,
      hintText: widget.hintText,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      inputType: widget.inputType ?? TextInputType.text,
      onTap: () {
        if (!widget.isReadOnly) {
          setState(() {
            enableLabel = true;
          });
        }
      },
      onObscureTap: () {
        setState(() {
          enableObscure = !enableObscure;
        });
      },
      fillColor: enableLabel ? Colors.white : widget.fillColor,
      isReadOnly: widget.isReadOnly,
      onSuffix: widget.onSuffix,
      prefix: enableLabel || widget.controller!.text.isNotEmpty
          ? widget.prefix
          : null,
      enableObscure: enableObscure,
      showObscureIcon : widget.showObscureIcon,
      enableLabel: enableLabel,
      onChanged: (val) {},
      validator:
          widget.validator == null ? (val) {} : (val) => widget.validator!(val),
      onSaved: (String? newValue) {},
      arabicPadding: widget.arabicPadding,
    );
  }
}

class CustomForm extends FormField<String> {
  final TextEditingController? controller;
  final Function onChanged;
  final bool isObscure;
  final bool enableObscure;
  final Widget? prefix;
  final bool enableLabel;
  final Color? fillColor;
  final String? labelText;
  final bool showObscureIcon;
  final bool isReadOnly;
  final TextInputType? inputType;
  final String hintText;
  final VoidCallback? onTap;
  final int? maxLength;
  final VoidCallback? onObscureTap;
  final Widget? onSuffix;
  final List<TextInputFormatter>? inputFormatters;
  final bool arabicPadding;

  CustomForm(
      {Key? key,
      required FormFieldSetter<String> onSaved,
      required FormFieldValidator<String> validator,
      this.controller,
      this.onTap,
      this.prefix,
        this.showObscureIcon = true,
      this.fillColor,
      this.enableObscure = true,
      this.enableLabel = false,
      this.onObscureTap,
      this.inputType,
      required this.isReadOnly,
      this.isObscure = false,
      this.labelText,
      this.onSuffix,
      this.inputFormatters,
      this.maxLength,
      required this.onChanged,
      this.hintText = '',
        this.arabicPadding = false,
      String initialValue = ''})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<String> state) {
              final outlinedBorder = OutlineInputBorder(
                  borderSide: BorderSide(
                      color: enableLabel
                          ? ColorPalette.primaryColor
                          : HexColor('#C5C5C5')));
              return Column(
                children: [
                  SizedBox(
                    height: 48.h,
                    child: TextFormField(
                        controller: controller,
                        style: FontStyle.black16Medium,
                        onTap: onTap,
                        inputFormatters: inputFormatters,
                        keyboardType: inputType,
                        maxLength: maxLength,
                        readOnly: isReadOnly,
                        onChanged: (val) {
                          state.didChange(val);
                          onChanged(val);
                        },
                        obscureText: isObscure ? enableObscure : false,
                        decoration: InputDecoration(
                            border: outlinedBorder,
                            counterText: '',
                            focusedBorder: outlinedBorder,
                            enabledBorder: outlinedBorder,
                            contentPadding: EdgeInsets.only(
                                bottom: 5.h, left: 15.w, right: onSuffix != null ? arabicPadding ? 15.w : 0 : 15.w),
                            errorBorder: outlinedBorder,
                            labelText: labelText,
                            labelStyle: FontStyle.primary12Medium,
                            fillColor: fillColor,
                            filled: fillColor != null ? true : false,
                            hintText: hintText,
                            hintStyle: FontStyle.grey15Medium,
                            prefix: prefix,
                            suffixIcon: onSuffix != null
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.h, horizontal: 10.w),
                                    child: onSuffix,
                                  )
                                : isObscure && showObscureIcon
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: enableObscure
                                              ? Colors.black
                                              : ColorPalette.primaryColor,
                                        ),
                                        onPressed: onObscureTap,
                                      )
                                    : null,
                            floatingLabelBehavior: enableLabel
                                ? FloatingLabelBehavior.always
                                : FloatingLabelBehavior.never)),
                  ),
                  ReusableWidgets.textFieldError(state.errorText.toString(),
                      showError: state.hasError)
                ],
              );
            });
}
