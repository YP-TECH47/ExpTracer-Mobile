import 'package:expense_tracker_app/models/expense_functionality.dart';
import 'package:flutter/material.dart';

class ExpenseItems extends StatelessWidget {
  const ExpenseItems(this.expense, {super.key});
  final Expense expense;

  @override
  Widget build(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(expense.title),
            const SizedBox(height: 3),
            Row(
              children: [
                Text(expense.amount.toStringAsFixed(2),),
                const Spacer(),
                Row(
                  children: [
                    const SizedBox(width: 7),
                    Text(expense.category),
                    const SizedBox(width: 7),
                    Text(expense.formattedDate),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
