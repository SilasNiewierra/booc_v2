import 'package:flutter/material.dart';

class DropDownFormField extends FormField<dynamic> {
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final Function onChanged;
  final EdgeInsets contentPadding;

  DropDownFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      this.hintText = 'Select one option',
      this.required = false,
      this.errorText = 'Please select one option',
      this.value,
      this.dataSource,
      this.onChanged,
      this.contentPadding = const EdgeInsets.fromLTRB(12, 0, 0, 0)})
      : super(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Container(
              margin: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputDecorator(
                    decoration: InputDecoration(
                      enabledBorder: state.hasError
                          ? UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            )
                          : null,
                      contentPadding: contentPadding,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.category,
                          size: 30.0,
                        ),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        isExpanded: true,
                        hint: Text(
                          hintText,
                        ),
                        value: value == '' ? null : value,
                        onChanged: (dynamic newValue) {
                          state.didChange(newValue);
                          onChanged(newValue);
                        },
                        items: dataSource.map((item) {
                          String title = item
                              .split("_")
                              .map((str) =>
                                  "${str[0].toUpperCase()}${str.substring(1)}")
                              .join(" ");
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Text(title, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: state.hasError ? 5.0 : 0.0),
                  Text(
                    state.hasError ? state.errorText : '',
                    style: TextStyle(
                        color: Colors.redAccent.shade700,
                        fontSize: state.hasError ? 12.0 : 0.0),
                  ),
                ],
              ),
            );
          },
        );
}
