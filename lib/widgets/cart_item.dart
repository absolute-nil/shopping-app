import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String id;
  final double price;
  final int quantity;

  const CartItem({Key key, this.title, this.id, this.price, this.quantity});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Padding(
          padding: const EdgeInsets.all(5),
          child: FittedBox(child: Text("Rs. $price")),
        ),),
        title: Text(title),
        subtitle: Text("Total ${price * quantity}"),
        trailing: Text("$quantity x"),
      ),
    );
  }
}