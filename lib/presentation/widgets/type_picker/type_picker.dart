import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import '../../../core/utils/validation/form_validation.dart';

class TypePicker extends StatelessWidget {
  final ValueNotifier<String?> selectedType;

  const TypePicker({
    required this.selectedType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedType,
      builder: (context, value, child) {
        final TextEditingController controller =
            TextEditingController(text: value);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: darkColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: InputBorder.none,
              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
            ),
            validator: validateType,
            onTap: () async {
              final selected = await _showTypeBottomSheet(context);
              if (selected != null) {
                selectedType.value = selected;
              }
            },
          ),
        );
      },
    );
  }

  Future<String?> _showTypeBottomSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: groupedCategories.length,
                  itemBuilder: (context, groupIndex) {
                    final groupName =
                        groupedCategories.keys.elementAt(groupIndex);
                    final categories = groupedCategories[groupName]!;

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
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade600,
                            ),
                            title: Text(
                              type,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary)
                                : null,
                            onTap: () {
                              Navigator.pop(context, type);
                            },
                          );
                        }),
                        if (groupIndex < groupedCategories.length - 1)
                          const Divider(height: 1, thickness: 0.5),
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
