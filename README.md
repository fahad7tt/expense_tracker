MyExpenses (Personal Expense Tracker App)

Project Overview :
This mobile application allows users to track and manage their personal expenses efficiently. The app provides a user-friendly interface to input, view, edit, and categorize expenses, as well as set reminders for daily expense recording.

Architecture Overview :
For clean maintainability and separation of concerns, the app follows **Clean Architecture** (Presentation, Domain, Data layers). 
For a simple visual breakdown of how data flows through the app, see [ARCHITECTURE.md](file:///c:/Users/ttfah/expense_tracker/ARCHITECTURE.md).

Features :
- Add Expense - Input amount, date, and description of expenses/income.
- View Expenses - Display expenses in an interactive list with filtering.
- Edit/Delete Expense - Modify or remove existing entries.
- Expense Summary - View summaries categorized by type, weekly or monthly.
- Reminder Notifications - Daily reminder notifications to record expenses.

UI/UX :
- User-Friendly Interface - Visually appealing and intuitive interface.
- Responsive Design - Adaptive Flutter widgets across different screen sizes.
- Consistent Theme - Light and Dark theme support.

State Management :
- Provider - Clean state management solution using Flutter `Provider`.

Data Persistence :
- Local Storage - Fast offline data persistence using `Hive`.

