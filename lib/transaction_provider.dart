import 'dart:convert'; // Import this to handle JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  double get totalIncome =>
      _transactions.where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense =>
      _transactions.where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());

  TransactionProvider() {
    loadTransactions(); // Load transactions when the provider is created
  }

  void addTransaction(String title, double amount, bool isExpense) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: isExpense ? -amount : amount,
      date: DateTime.now(),
    );
    _transactions.add(newTransaction);
    saveTransactions(); // Save transactions after adding
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    saveTransactions(); // Save transactions after deleting
    notifyListeners();
  }

  void updateTransaction(String id, String newTitle, double newAmount, bool isExpense) {
    final transactionIndex = _transactions.indexWhere((transaction) => transaction.id == id);
    if (transactionIndex >= 0) {
      _transactions[transactionIndex] = Transaction(
        id: id,
        title: newTitle,
        amount: isExpense ? -newAmount : newAmount,
        date: DateTime.now(), // Update date to the current time
      );
      saveTransactions(); // Save changes after updating
      notifyListeners();
    }
  }

  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = _transactions.map((t) => t.toJson()).toList(); // Convert transactions to JSON
    prefs.setString('transactions', jsonEncode(transactionsJson)); // Save JSON string
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsString = prefs.getString('transactions');
    if (transactionsString != null) {
      List<dynamic> transactionsList = jsonDecode(transactionsString);
      _transactions = transactionsList.map((item) => Transaction.fromJson(item)).toList(); // Convert JSON back to Transaction objects
      notifyListeners();
    }
  }
}
