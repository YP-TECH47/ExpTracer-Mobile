import 'package:expense_tracker_app/expexse_item.dart';
import 'package:expense_tracker_app/models/expense_functionality.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Expenseslist extends StatelessWidget {
  Expenseslist(
      {super.key, required this.expenses, required this.onremoveexpense});

  final List<Expense> expenses;
  void Function(Expense expense) onremoveexpense;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
          background: Container(color: Colors.red),
          key: ValueKey(expenses[index]),
          onDismissed: (direction) => onremoveexpense(expenses[index]),
          child: ExpenseItems(expenses[index]),
        ),
      ),
    );
  }
}
