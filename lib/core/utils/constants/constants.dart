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

const Color profitColor = Color(0xFF2E7D32);
const Color expenseColor = Color(0xFFD32F2F);

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

final Map<String, List<String>> groupedProfitCategories = {
  'Income & Earnings': [
    'Salary',
    'Freelance',
    'Business Profit',
    'Bonus',
    'Sales',
  ],
  'Investments & Passive': [
    'Investment Return',
    'Dividends',
    'Rental Income',
    'Interest',
  ],
  'Other Income': [
    'Gift / Allowance',
    'Refund',
    'Other Profit',
  ],
};

final List<String> currencies = [
  '\u20B9', // ₹
  '\u0024', // $
  '\u20AC', // €
  '\u00A3', // £
  '\u00A5', // ¥
  '\u20A3', // ₣
  '\u0E3F', // ฿
  '\u20AB', // ₫
  '\u20A9', // ₩
  '\u20AA', // ₪
  '\u20B1', // ₱
  '\u20BA', // ₺
  '\u20BD', // ₽
  '\u20BF', // ₿
  'AED',
  'KWD',
  'BHD',
  'JOD',
];

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

  // Profit / Income Categories
  'Salary': Icons.account_balance_wallet,
  'Freelance': Icons.laptop_chromebook,
  'Business Profit': Icons.store,
  'Bonus': Icons.card_giftcard,
  'Sales': Icons.point_of_sale,
  'Investment Return': Icons.show_chart,
  'Dividends': Icons.pie_chart,
  'Rental Income': Icons.real_estate_agent,
  'Interest': Icons.savings,
  'Gift / Allowance': Icons.redeem,
  'Refund': Icons.currency_exchange,
  'Other Profit': Icons.add_chart,

  // Others
  'Others': Icons.more_horiz,
};

const textSize = TextStyle(
  fontSize: 17,
);

enum BudgetBucket { living, savings, charity }

BudgetBucket getBucketForCategory(String? type) {
  if (type == null) return BudgetBucket.living;
  final t = type.toLowerCase();
  if (t.contains('investment') ||
      t.contains('savings') ||
      t.contains('dividend') ||
      t.contains('stock') ||
      t.contains('interest')) {
    return BudgetBucket.savings;
  }
  if (t.contains('charity') ||
      t.contains('donation') ||
      t.contains('zakat') ||
      t.contains('gift') ||
      t.contains('beneficial')) {
    return BudgetBucket.charity;
  }
  return BudgetBucket.living;
}

