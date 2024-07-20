// import 'package:flutter/material.dart';

// class DropdownFormField extends StatelessWidget {
//   final ValueNotifier<String?> selectedType;
//   final List<String> types;
//   final String labelText;

//   const DropdownFormField({
//     Key? key,
//     required this.selectedType,
//     required this.types,
//     required this.labelText,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showTypeSelectionSheet(context),
//       child: AbsorbPointer(
//         child: TextFormField(
//           initialValue: selectedType.value ?? '',
//           decoration: InputDecoration(
//             labelText: labelText,
//             suffixIcon: Icon(Icons.arrow_drop_down),
//             border: OutlineInputBorder(),
//           ),
//           readOnly: true,
//         ),
//       ),
//     );
//   }

//   void _showTypeSelectionSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return ListView(
//           children: [
//             ...types.map((type) {
//               return ListTile(
//                 title: Text(type),
//                 onTap: () {
//                   if (type == 'Others') {
//                     _showCustomTypeDialog(context);
//                   } else {
//                     selectedType.value = type;
//                     Navigator.pop(context);
//                   }
//                 },
//               );
//             }).toList(),
//           ],
//         );
//       },
//     );
//   }

//   void _showCustomTypeDialog(BuildContext context) {
//     final TextEditingController customTypeController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter Custom Type'),
//           content: TextField(
//             controller: customTypeController,
//             decoration: InputDecoration(hintText: 'Custom Type'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 final customType = customTypeController.text.trim();
//                 if (customType.isNotEmpty) {
//                   selectedType.value = customType;
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text('Submit'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
