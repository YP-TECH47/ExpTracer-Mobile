import 'package:expense_tracker_app/expenses_list.dart';
import 'package:expense_tracker_app/models/expense_functionality.dart';
import 'package:expense_tracker_app/newExpense.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  late final DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();

    databaseRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://new-expenses-default-rtdb.firebaseio.com/',
    ).ref('expenses');

    fetchExpensesFromFirebase();
  }

  void fetchExpensesFromFirebase() async {
    try {
      DatabaseEvent event = await databaseRef.once();
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<Expense> loadedExpenses = [];
        data.forEach((key, value) {
          loadedExpenses.add(
            Expense(
              id: key.toString(),
              title: value['title'],
              amount: (value['amount'] as num).toDouble(),
              date: DateTime.parse(value['date']),
              category: value['category'],
            ),
          );
        });

        setState(() {
          _registeredExpenses.addAll(loadedExpenses);
        });
      }
    } catch (e) {
      print("Error fetching expenses: $e");
    }
  }

  void _addExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height,
        child: NewExpense(onaddexpense: addNewExpenseToFirebase),
      ),
    );
  }

  void addNewExpenseToFirebase(Expense expense) async {
    try {
      DatabaseReference newExpenseRef = databaseRef.push();
      await newExpenseRef.set({
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category,
      });

      setState(() {
        _registeredExpenses.add(
          Expense(
            id: newExpenseRef.key!.toString(),
            title: expense.title,
            amount: expense.amount,
            date: expense.date,
            category: expense.category,
          ),
        );
      });
    } catch (e) {
      print("Error adding expense: $e");
    }
  }

  void _removeExpense(Expense expense) async {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    try {
      await databaseRef.child(expense.id!).remove(); // Use string ID

      setState(() {
        _registeredExpenses.remove(expense);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense deleted.'),
          persist: false,
          action: SnackBarAction(
            label: 'Undo',

            onPressed: () async {
              DatabaseReference restoredRef = databaseRef.push();
              await restoredRef.set({
                'title': expense.title,
                'amount': expense.amount,
                'date': expense.date.toIso8601String(),
                'category': expense.category,
              });

              setState(() {
                _registeredExpenses.insert(
                  expenseIndex,
                  Expense(
                    id: restoredRef.key!.toString(),
                    title: expense.title,
                    amount: expense.amount,
                    date: expense.date,
                    category: expense.category,
                  ),
                );
              });
            },
          ),
        ),
      );
    } catch (e) {
      print("Error removing expense: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpenseOverlay,
        backgroundColor: const Color.fromARGB(255, 255, 103, 15),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("EXPENSE TRACKER")),
      body: width < 600
          ? Column(
              children: [
                Expenseslist(
                  expenses: _registeredExpenses,
                  onremoveexpense: _removeExpense,
                ),
              ],
            )
          : Row(
              children: [
                Expenseslist(
                  expenses: _registeredExpenses,
                  onremoveexpense: _removeExpense,
                ),
              ],
            ),
    );
  }
}
