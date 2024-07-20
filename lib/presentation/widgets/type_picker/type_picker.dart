import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import '../../../core/utils/validation/form_validation.dart';

class TypePicker extends StatelessWidget {
  final ValueNotifier<String?> selectedType;
  final ValueNotifier<List<String>> typesNotifier;
  final Box<String> typesBox;

  const TypePicker({
    required this.selectedType,
    required this.typesNotifier,
    required this.typesBox,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedType,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: darkColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Select type',
              suffixIcon: Icon(Icons.arrow_drop_down),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            onTap: () async {
              final selected = await _showTypeBottomSheet(context);
              if (selected != null) {
                selectedType.value = selected;
              }
            },
            controller: TextEditingController(text: value),
          ),
        );
      },
    );
  }

  Future<String?> _showTypeBottomSheet(BuildContext context) async {
  return showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return ValueListenableBuilder<List<String>>(
        valueListenable: typesNotifier,
        builder: (context, types, child) {
          // Sort the list with 'Others' at the end
          final sortedTypes = List<String>.from(types)..sort((a, b) {
            if (a == 'Others') return 1;
            if (b == 'Others') return -1;
            return a.compareTo(b);
          });

          return ListView.builder(
            itemCount: sortedTypes.length,
            itemBuilder: (context, index) {
              final type = sortedTypes[index];
              return ListTile(
                title: Text(type),
                onTap: () {
                  if (type == 'Others') {
                    Navigator.pop(context);
                    _showCustomTypeDialog(context);
                  } else {
                    Navigator.pop(context, type);
                  }
                },
              );
            },
          );
        },
      );
    },
  );
}

  Future<void> _showCustomTypeDialog(BuildContext context) async {
    final TextEditingController customTypeController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Custom Type'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: customTypeController,
              decoration: const InputDecoration(hintText: 'Custom Type'),
              validator: (value) => validateCustomType(value),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
            child: const Text('OK'),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final customType = customTypeController.text;

                // Ensure the custom type isn't already present
                if (!typesBox.values.contains(customType)) {
                  // Update Hive box with new custom type
                  typesBox.add(customType);

                  // Update ValueNotifier with new list
                  typesNotifier.value = typesBox.values.toList();
                }
                
                // Update selectedType and close dialog
                selectedType.value = customType;
                Navigator.of(context).pop();
              }
            },
          ),
          ],
        );
      },
    );
  }
}
