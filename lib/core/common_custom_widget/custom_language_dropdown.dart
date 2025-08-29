import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final String hintText;
  final ValueChanged<String?> onChanged;

  // Customization parameters
  final double buttonWidth;
  final double buttonHeight;
  final double itemHeight;
  final double fontSize;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final Widget? icon;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.hintText,
    required this.onChanged,
    this.buttonWidth = 140,
    this.buttonHeight = 40,
    this.itemHeight = 40,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
  isExpanded: true,
  value: selectedValue,
  hint: Text(
    hintText,
    style: TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).hintColor,
    ),
  ),
  items: items
      .map(
        (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(fontSize: fontSize, color: textColor),
          ),
        ),
      )
      .toList(),
  onChanged: onChanged,
  buttonStyleData: ButtonStyleData(
    padding: padding,
    height: buttonHeight,
    width: buttonWidth,
  ),
  menuItemStyleData: MenuItemStyleData(
    height: itemHeight,
  ),
  iconStyleData: IconStyleData(
    icon: icon ?? const Icon(Icons.arrow_drop_down),
  ),
  dropdownStyleData: DropdownStyleData(
    decoration: BoxDecoration(
      color: Colors.white,              // background color of dropdown
      borderRadius: BorderRadius.circular(12), // rounded corners
      border: Border.all(color: Colors.grey.shade300), // optional border
    ),
  ),
),

    );
  }
}
