import 'package:flutter/material.dart';

class TypePicker extends StatelessWidget {
  final ValueNotifier<String?> selectedType;

  const TypePicker({required this.selectedType, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedType,
      builder: (context, value, child) {
        return TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            hintText: 'Select type',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          onTap: () async {
            final selected = await _showTypeBottomSheet(context);
            if (selected != null) {
              selectedType.value = selected;
            }
          },
          controller: TextEditingController(text: value),
        );
      },
    );
  }

  Future<String?> _showTypeBottomSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        final List<String> types = ['Food', 'Drink', 'Sports', 'Others'];
        return ListView.builder(
          itemCount: types.length,
          itemBuilder: (context, index) {
            final type = types[index];
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
  }

  Future<void> _showCustomTypeDialog(BuildContext context) async {
    final TextEditingController customTypeController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Custom Type'),
          content: TextField(
            controller: customTypeController,
            decoration: const InputDecoration(hintText: 'Custom Type'),
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
                final customType = customTypeController.text;
                if (customType.isNotEmpty) {
                  Navigator.of(context).pop();
                  selectedType.value = customType;
                }
              },
            ),
          ],
        );
      },
    );
  }
}
