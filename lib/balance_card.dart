import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double income;
  final double expense;

  BalanceCard({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    double balance = income - expense;

    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.only(right: 200,left: 200,top: 20,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('BALANCE', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${balance.toStringAsFixed(1)} som',
                    style: TextStyle(fontSize: 40, color: balance >= 0 ? Colors.black : Colors.red)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 32),
                    Text('Income', style: TextStyle(color: Colors.green, fontSize: 16)),
                    SizedBox(height: 5),
                    Text('${income.toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.green, fontSize: 20)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.red, size: 32),
                    Text('Expense', style: TextStyle(color: Colors.red, fontSize: 16)),
                    SizedBox(height: 5),
                    Text('${expense.toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.red, fontSize: 20)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
