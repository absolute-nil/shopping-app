import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderData;

  OrderItem(this.orderData);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("${widget.orderData.amount.toStringAsFixed(2)}"),
            subtitle: Text(DateFormat("dd/MM/yyyy hh:mm")
                .format(widget.orderData.dateTime)),
            trailing: IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow,
                  progress: _animationController,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                    _expanded
                        ? _animationController.forward()
                        : _animationController.reverse();
                  });
                }),
          ),
          if (_expanded)
            Divider(
              thickness: 1,
              color: Theme.of(context).accentColor,
            ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            // constraints: BoxConstraints(
            //     minHeight: _expanded ? 20 : 0,
            //     maxHeight: _expanded
            //         ? min(widget.orderData.products.length * 20.0 + 20, 100)
            //         : 0),
            curve: Curves.easeIn,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? min(widget.orderData.products.length * 20.0 + 20, 100)
                : 0,
            child: ListView(
                children: widget.orderData.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              "${prod.quantity}x  ${prod.price}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        ))
                    .toList()),
          )
        ],
      ),
    );
  }
}
