import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './transaction_provider.dart';
import './balance_card.dart';
import './transaction_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          BalanceCard(
            income: transactionProvider.totalIncome,
            expense: transactionProvider.totalExpense,
          ),
          Expanded(child: TransactionList(transactionProvider.transactions)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewTransaction(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => _NewTransactionDialog(
        transactionProvider: transactionProvider,
        titleController: titleController,
        amountController: amountController,
      ),
    );
  }
}

class _NewTransactionDialog extends StatefulWidget {
  final TransactionProvider transactionProvider;
  final TextEditingController titleController;
  final TextEditingController amountController;

  _NewTransactionDialog({
    required this.transactionProvider,
    required this.titleController,
    required this.amountController,
  });

  @override
  __NewTransactionDialogState createState() => __NewTransactionDialogState();
}

class __NewTransactionDialogState extends State<_NewTransactionDialog> {
  String transactionType = 'Income'; // Default selection

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: widget.amountController,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allows decimal input
            ],
          ),
          DropdownButton<String>(
            value: transactionType,
            items: ['Income', 'Expense'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                transactionType = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final title = widget.titleController.text;
            final amount = double.tryParse(widget.amountController.text) ?? 0.0;
            if (title.isNotEmpty && amount > 0) {
              final isExpense = transactionType == 'Expense';
              widget.transactionProvider.addTransaction(title, amount, isExpense);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}