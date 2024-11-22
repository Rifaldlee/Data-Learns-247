import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_learns_247/core/theme/color.dart';

class CustomFormField extends StatefulWidget {
  final EdgeInsets margin;
  final bool isRequired;
  final String fieldName;
  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool useToggleVisibility;
  final bool isFormDatePicker;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    this.margin = EdgeInsets.zero,
    required this.isRequired,
    required this.fieldName,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.hintText = "",
    this.useToggleVisibility = false,
    this.validator,
    this.isFormDatePicker = false
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _textVisible = false;

  @override
  Widget build(BuildContext context) {
    if (widget.useToggleVisibility && widget.isFormDatePicker) {
      throw Exception(
        "When text field is date picker, text field cannot use toggle visibility. Set one of them to false");
    }

    Widget formFieldLabel() {
      if (widget.isRequired) {
        return Text.rich(
          TextSpan(
            text: widget.fieldName,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kBlackColor),
            children: [
              TextSpan(
                text: " *",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kRedColor),
              )
            ]
          )
        );
      }
      return Text(
        widget.fieldName,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kBlackColor)
      );
    }

    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          formFieldLabel(),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: widget.textInputType,
            obscureText: widget.useToggleVisibility && !_textVisible,
            cursorColor: kGreenColor,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kLightGreyColor),
              errorStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kRedColor),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kLightGreyColor),
                borderRadius: BorderRadius.circular(200),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kGreenColor),
                borderRadius: BorderRadius.circular(200),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kRedColor),
                borderRadius: BorderRadius.circular(200),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kGreenColor),
                borderRadius: BorderRadius.circular(200),
              ),
              suffixIcon: widget.useToggleVisibility ? IconButton(
                onPressed: () {
                  setState(() {_textVisible = !_textVisible;});
                },
                icon: Icon(
                  _textVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                  color: kBlackColor,
                )
              )
              : widget.isFormDatePicker ? const Icon(
                Icons.calendar_today,
                color: kBlackColor,
              ) : null
            ),
            onTap: widget.isFormDatePicker
              ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1980),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100)
                );
                if(pickedDate != null ){
                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  setState(() {
                    widget.controller.text = formattedDate;
                  });
                }
              } : null,
            validator: (String? value) {
              if ((value == null || value.isEmpty) && widget.isRequired) {
                return 'Please fill required form';
              }
              if (widget.validator != null) {
                return widget.validator!(value);
              }
              return null;
            },
          )
        ],
      ),
    );
  }
}
