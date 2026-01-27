import 'package:flutter/material.dart';

//hive box
const String hiveBox = 'expenses';

//colors
const Color deepBlue = Color(0xFF001F3F);
const Color softBlue = Color(0xFF66CCFF);
const Color lightGray = Color(0xFFF5F5F5);
const Color darkGray = Color(0xFF333333);
const Color lightGrayText = Color(0xFF888888);
const Color errorColor = Color(0xFFB00020);
const Color iconColor = Color(0xFFCCCCCC);
const Color cardColor = Color.fromARGB(255, 243, 243, 243);
const Color lightColor = Colors.white;
const Color darkColor = Colors.black;
const Color buttonColor = Color.fromARGB(255, 255, 152, 0);
const Color bgColor = Color.fromARGB(255, 228, 228, 228);
const Color navbarColor = Color.fromARGB(255, 143, 162, 185);
const Color selectedIconColor = Color.fromARGB(255, 19, 120, 202);

// icon size
const double homeIcon = 28.0;
const double dateIcon = 14.0;
const double normalIcon = 18.0;
const double forwardIcon = 22.0;

//font size
final Map<String, List<String>> groupedCategories = {
  'Essential & Daily': [
    'Food',
    'Groceries',
    'Drink',
    'Transport',
    'Fuel',
  ],
  'Living & Utilities': [
    'Rent',
    'Electricity',
    'Water',
    'Internet',
    'Phone',
  ],
  'Lifestyle & Entertainment': [
    'Entertainment',
    'Dining Out',
    'Shopping',
    'Sports',
    'Leisure',
    'Travel',
  ],
  'Health & Personal': [
    'Health',
    'Medicine',
    'Gym',
    'Beauty',
  ],
  'Education & Work': [
    'Education',
    'Books',
    'Office',
  ],
  'Financial': [
    'Investment',
    'Insurance',
    'Tax',
    'Gift',
    'Donation',
  ],
  'Others': [
    'Others',
  ],
};

final Map<String, IconData> typeIcons = {
  // Essential & Daily
  'Food': Icons.restaurant,
  'Groceries': Icons.shopping_basket,
  'Drink': Icons.local_drink,
  'Transport': Icons.directions_bus,
  'Fuel': Icons.local_gas_station,

  // Living & Utilities
  'Rent': Icons.home,
  'Electricity': Icons.electric_bolt,
  'Water': Icons.water_drop,
  'Internet': Icons.wifi,
  'Phone': Icons.phone_android,

  // Lifestyle & Entertainment
  'Entertainment': Icons.movie,
  'Dining Out': Icons.dining,
  'Shopping': Icons.shopping_bag,
  'Sports': Icons.sports_basketball,
  'Leisure': Icons.beach_access,
  'Travel': Icons.flight,

  // Health & Personal
  'Health': Icons.medical_services,
  'Medicine': Icons.medication,
  'Gym': Icons.fitness_center,
  'Beauty': Icons.face,

  // Education & Work
  'Education': Icons.school,
  'Books': Icons.book,
  'Office': Icons.work,

  // Financial
  'Investment': Icons.trending_up,
  'Insurance': Icons.security,
  'Tax': Icons.receipt_long,
  'Gift': Icons.card_giftcard,
  'Donation': Icons.volunteer_activism,

  // Others
  'Others': Icons.more_horiz,
};

const textSize = TextStyle(
  fontSize: 17,
);
