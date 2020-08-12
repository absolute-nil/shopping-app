import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static final routeName = "/cart-screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "Rs. ${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    backgroundColor: Colors.white,
                    shadowColor: Theme.of(context).primaryColor,
                    elevation: 2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                      // .values to list is used to convert map to list (map is stored in the cart provider)
                      productId: cart.items.keys.toList()[i],
                      id: cart.items.values.toList()[i].id,
                      title: cart.items.values.toList()[i].title,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price)))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return FlatButton(
      onPressed: (!(widget.cart.items.length > 0) || (_isLoading))? null : () async {
        setState(() {
          _isLoading = true;
        });
        try {
          await Provider.of<Orders>(context, listen: false)
              .addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
          widget.cart.clearItems();
        } catch (e) {
          scaffold.showSnackBar(SnackBar(
              content: Text(
            "Couldnt process order",
            textAlign: TextAlign.center,
          )));
        }
                setState(() {
          _isLoading = false;
        });
      },
      child: _isLoading? CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,) : Text("Order Now"),
      color: Theme.of(context).accentColor,
    );
  }
}
