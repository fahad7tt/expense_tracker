String? validateAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter amount';
  }
  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter description';
  } else if (value.length <= 20) {
    return 'Description must be at least 20 characters';
  } else if (value.contains(RegExp(r'[0-9]'))) {
    return 'Description must not contain numbers';
  }
  return null;
}

String? validateCustomType(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }
  return null;
}