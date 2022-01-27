import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reusable_widgets.dart';

class CommonTextField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final TextInputType? inputType;
  final Function? validator;
  final Function? onTap;
  final Function? onEditingComplete;
  final bool isObscure;
  final Widget? prefix;
  final TextStyle? hintFontStyle;
  final Function? onSaved;
  final Function? onChanged;
  final TextInputAction? inputAction;
  final int? maxLines;
  final int? maxLength;
  final bool autoFocus;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool defaultFont;
  const CommonTextField(
      {Key? key,
      this.hintText = '',
      this.labelText,
      this.prefix,
      this.inputType,
      this.validator,
      this.hintFontStyle,
      this.onTap,
      this.onEditingComplete,
      this.autoFocus = false,
      this.isObscure = false,
      this.onSaved,
      this.onChanged,
      this.inputAction,
      this.inputFormatters,
      this.controller,
      this.maxLength,
      this.maxLines,
      this.defaultFont = true})
      : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool enableLabel = false;
  bool enableObscure = true;

  @override
  Widget build(BuildContext context) {
    final outlinedBorder = OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.primaryColor));
    return SizedBox(
      height: 48,
      child: TextFormField(
          controller: widget.controller,
          style: widget.defaultFont
              ? FontStyle.black16Medium
              : FontStyle.black15Medium_111111,
          onChanged:
              widget.onChanged != null ? (val) => widget.onChanged!(val) : null,
          onTap: () => setState(() {
                enableLabel = true;
              }),
          obscureText: widget.isObscure ? enableObscure : false,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          autofocus: widget.autoFocus,
          decoration: InputDecoration(
              border: outlinedBorder,
              counterText: "",
              focusedBorder: outlinedBorder,
              contentPadding:
                  EdgeInsets.only(bottom: 5, left: 15, right: 15),
              errorBorder: outlinedBorder,
              labelText: enableLabel ? widget.labelText : null,
              labelStyle: FontStyle.primary12Medium,
              hintText: widget.hintText,
              hintStyle: widget.hintFontStyle ?? FontStyle.grey15Medium,
              prefix: widget.prefix,
              suffixIcon: widget.isObscure
                  ? IconButton(
                      icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: enableObscure
                            ? Colors.black
                            : ColorPalette.primaryColor,
                      ),
                      onPressed: () => setState(() {
                        enableObscure = !enableObscure;
                      }),
                    )
                  : null)),
    );
  }
}
