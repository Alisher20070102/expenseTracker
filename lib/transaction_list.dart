import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import './transaction.dart';
import './transaction_provider.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  void _editTransaction(BuildContext context, Transaction transaction) {
    final titleController = TextEditingController(text: transaction.title);
    final amountController = TextEditingController(text: transaction.amount.abs().toString());
    String transactionType = transaction.amount < 0 ? 'Expense' : 'Income';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Edit Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              ),
              DropdownButton<String>(
                value: transactionType,
                items: ['Income', 'Expense'].map((value) {
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
                final newTitle = titleController.text;
                final newAmount = double.tryParse(amountController.text) ?? 0.0;
                if (newTitle.isNotEmpty && newAmount > 0) {
                  final isExpense = transactionType == 'Expense';
                  Provider.of<TransactionProvider>(context, listen: false)
                      .updateTransaction(transaction.id, newTitle, newAmount, isExpense);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        final transaction = transactions[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
            ),
            title: Text(transaction.title),
            subtitle: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${transaction.amount.toStringAsFixed(0)}.sum'),
                    Text(DateFormat.yMMMd().add_jm().format(transaction.date)),
                  ],
                ),
                Expanded(child: SizedBox(width: 500)),
                Text(
                  transaction.amount < 0 ? "Expense" : "Income",
                  style: TextStyle(
                    color: transaction.amount < 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: SizedBox(width: 500)),
              ],
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () => _editTransaction(context, transaction),
                ),
                SizedBox(width: 30),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Ishonchimgiz komilmi ?'),
                        content: Text('Oylab koring !!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(); // Close the dialog without deleting
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<TransactionProvider>(context, listen: false)
                                  .deleteTransaction(transaction.id);
                              Navigator.of(ctx).pop(); // Close the dialog after deleting
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
