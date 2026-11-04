class Expense {
  Expense({
    required this.amount,
    required this.title,
    required this.date,
    required this.category,
    this.id,
  });

  String? id;
  String title;
  double amount;
  DateTime date;
  String category;

  String get formattedDate => "${date.day}/${date.month}/${date.year}";
}

List<String> categoryList = [
  "food",
  "leisure",
  "work",
  "travel",
];


