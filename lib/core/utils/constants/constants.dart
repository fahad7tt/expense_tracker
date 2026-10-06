import 'package:flutter/material.dart';

// Hive box
const String hiveBox = 'expenses';

// Colors - Unified Palette
const Color deepBlue = Color(0xFF1E3A8A);
const Color softBlue = Color(0xFF3B82F6);
const Color lightGray = Color(0xFFF8FAFC);
const Color darkGray = Color(0xFF0F172A);
const Color lightGrayText = Color(0xFF64748B);
const Color errorColor = Color(0xFFEF4444);
const Color iconColor = Color(0xFF94A3B8);
const Color cardColor = Colors.white;
const Color lightColor = Colors.white;
const Color darkColor = Colors.black;
const Color buttonColor = Color(0xFFEF4444);
const Color bgColor = Color(0xFFF8FAFC);
const Color navbarColor = Colors.white;
const Color selectedIconColor = Color(0xFF3B82F6);

const Color profitColor = Color(0xFF10B981);
const Color expenseColor = Color(0xFFEF4444);

// Icon sizes
const double homeIcon = 24.0;
const double dateIcon = 14.0;
const double normalIcon = 18.0;
const double forwardIcon = 22.0;

// Categories Definition
final Map<String, List<String>> groupedCategories = {
  'Essential & Daily': [
    'Food',
    'Groceries',
    'Drink',
    'Transport',
    'Fuel',
  ],
  'Living & Utilities': [
    'Living & Utilities',
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
    'Personal Development',
    'Education',
    'Books',
    'Office',
  ],
  'Financial': [
    'Investment',
    'Savings',
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
  '₹',   // INR
  '\$',  // USD
  '€',   // EUR
  '£',   // GBP
  '¥',   // JPY / CNY
  'C\$', // CAD
  'A\$', // AUD
  'CHF', // CHF
  'AED', // AED
  'SAR', // SAR
  'S\$', // SGD
  'HK\$',// HKD
  '₩',   // KRW
  '฿',   // THB
  'RM',  // MYR
  'R\$', // BRL
  '₽',   // RUB
  '₺',   // TRY
  'R',   // ZAR
];

final Map<String, IconData> typeIcons = {
  // Expense Category Icons
  'Food': Icons.restaurant_rounded,
  'Groceries': Icons.shopping_basket_rounded,
  'Drink': Icons.local_cafe_rounded,
  'Transport': Icons.directions_bus_rounded,
  'Fuel': Icons.local_gas_station_rounded,
  'Living & Utilities': Icons.home_work_rounded,
  'Rent': Icons.home_rounded,
  'Electricity': Icons.electric_bolt_rounded,
  'Water': Icons.water_drop_rounded,
  'Internet': Icons.wifi_rounded,
  'Phone': Icons.phone_android_rounded,
  'Entertainment': Icons.movie_rounded,
  'Dining Out': Icons.dinner_dining_rounded,
  'Shopping': Icons.shopping_bag_rounded,
  'Sports': Icons.sports_soccer_rounded,
  'Leisure': Icons.attractions_rounded,
  'Travel': Icons.flight_takeoff_rounded,
  'Health': Icons.local_hospital_rounded,
  'Medicine': Icons.medication_rounded,
  'Gym': Icons.fitness_center_rounded,
  'Beauty': Icons.content_cut_rounded,
  'Personal Development': Icons.psychology_rounded,
  'Education': Icons.school_rounded,
  'Books': Icons.menu_book_rounded,
  'Office': Icons.work_rounded,
  'Investment': Icons.show_chart_rounded,
  'Savings': Icons.savings_rounded,
  'Insurance': Icons.security_rounded,
  'Tax': Icons.receipt_long_rounded,
  'Gift': Icons.card_giftcard_rounded,
  'Donation': Icons.volunteer_activism_rounded,
  'Others': Icons.category_rounded,

  // Profit / Income Category Icons
  'Salary': Icons.account_balance_wallet_rounded,
  'Freelance': Icons.laptop_mac_rounded,
  'Business Profit': Icons.storefront_rounded,
  'Bonus': Icons.card_membership_rounded,
  'Sales': Icons.sell_rounded,
  'Investment Return': Icons.trending_up_rounded,
  'Dividends': Icons.pie_chart_rounded,
  'Rental Income': Icons.real_estate_agent_rounded,
  'Interest': Icons.savings_rounded,
  'Gift / Allowance': Icons.redeem_rounded,
  'Refund': Icons.currency_exchange_rounded,
  'Other Profit': Icons.add_chart_rounded,
};

Color getCategoryThemeColor(String? type, bool isProfit) {
  if (isProfit) return profitColor;
  if (type == null) return softBlue;
  final lower = type.toLowerCase();
  if (lower.contains('investment')) return const Color(0xFF8B5CF6);
  if (lower.contains('savings') ||
      lower.contains('insurance') ||
      lower.contains('tax')) return softBlue;
  if (lower.contains('donation') ||
      lower.contains('charity') ||
      lower.contains('gift')) return const Color(0xFF10B981);
  if (lower.contains('personal development') ||
      lower.contains('education') ||
      lower.contains('book')) return const Color(0xFFEC4899);
  if (lower.contains('food') ||
      lower.contains('grocery') ||
      lower.contains('drink')) return const Color(0xFFF97316);
  if (lower.contains('rent') ||
      lower.contains('utility') ||
      lower.contains('living')) return const Color(0xFFF59E0B);
  return expenseColor;
}
