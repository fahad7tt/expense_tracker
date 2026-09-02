import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import '../../../core/utils/validation/form_validation.dart';
import '../../../../core/utils/theme/system_theme.dart';

class TypePicker extends StatelessWidget {
  final ValueNotifier<String?> selectedType;
  final bool isProfit;

  const TypePicker({
    required this.selectedType,
    this.isProfit = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoriesMap = isProfit ? groupedProfitCategories : groupedCategories;
    final activeColor = isProfit ? profitColor : buttonColor;

    return ValueListenableBuilder<String?>(
      valueListenable: selectedType,
      builder: (context, value, child) {
        final TextEditingController controller =
            TextEditingController(text: value);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: TextStyle(
                color: context.isDarkMode ? lightGray : null,
              ),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: context.isDarkMode ? lightGray : null,
              ),
            ),
            validator: validateType,
            onTap: () async {
              final selected = await _showTypeBottomSheet(context, categoriesMap, activeColor);
              if (selected != null) {
                selectedType.value = selected;
              }
            },
          ),
        );
      },
    );
  }

  Future<String?> _showTypeBottomSheet(
      BuildContext context,
      Map<String, List<String>> categoriesMap,
      Color activeColor) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  isProfit ? 'Select Profit Category' : 'Select Category',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoriesMap.length,
                  itemBuilder: (context, groupIndex) {
                    final groupName =
                        categoriesMap.keys.elementAt(groupIndex);
                    final categories = categoriesMap[groupName]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (groupName != 'Others')
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 24, bottom: 8, left: 8),
                            child: Text(
                              groupName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ...categories.map((type) {
                          final bool isSelected = selectedType.value == type;
                          final IconData icon =
                              typeIcons[type] ?? Icons.category;

                          return ListTile(
                            leading: Icon(
                              icon,
                              color: isSelected
                                  ? activeColor
                                  : Colors.grey.shade600,
                            ),
                            title: Text(
                              type,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? activeColor : null,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: activeColor)
                                : null,
                            onTap: () {
                              Navigator.pop(context, type);
                            },
                          );
                        }),
                        if (groupIndex < categoriesMap.length - 1)
                          Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Theme.of(context).dividerColor),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
