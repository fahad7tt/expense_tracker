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
    final activeColor = isProfit ? profitColor : expenseColor;

    return ValueListenableBuilder<String?>(
      valueListenable: selectedType,
      builder: (context, value, child) {
        final TextEditingController controller =
            TextEditingController(text: value);
        return TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Category',
            labelStyle: TextStyle(
              color: context.isDarkMode ? lightGrayText : null,
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.isDarkMode ? lightGrayText : null,
            ),
          ),
          validator: validateType,
          onTap: () async {
            final selected =
                await _showTypeBottomSheet(context, categoriesMap, activeColor);
            if (selected != null) {
              selectedType.value = selected;
            }
          },
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
        final bool isDarkMode = context.isDarkMode;

        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 12, bottom: 20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  isProfit ? 'Select Income Category' : 'Select Expense Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? lightColor : deepBlue,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoriesMap.length,
                  itemBuilder: (context, groupIndex) {
                    final groupName = categoriesMap.keys.elementAt(groupIndex);
                    final categories = categoriesMap[groupName]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (groupName != 'Others')
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, bottom: 8, left: 8),
                            child: Text(
                              groupName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: activeColor,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ...categories.map((type) {
                          final bool isSelected = selectedType.value == type;
                          final IconData icon =
                              typeIcons[type] ?? Icons.category_rounded;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Material(
                              color: isSelected
                                  ? activeColor.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? activeColor
                                        : (isDarkMode
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFE2E8F0)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    icon,
                                    color: isSelected
                                        ? lightColor
                                        : (isDarkMode
                                            ? lightColor
                                            : darkGray),
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  type,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? activeColor
                                        : (isDarkMode
                                            ? lightColor
                                            : darkGray),
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Icon(Icons.check_circle_rounded,
                                        color: activeColor, size: 22)
                                    : null,
                                onTap: () {
                                  Navigator.pop(context, type);
                                },
                              ),
                            ),
                          );
                        }),
                        if (groupIndex < categoriesMap.length - 1)
                          const Divider(height: 16, thickness: 0.5),
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
