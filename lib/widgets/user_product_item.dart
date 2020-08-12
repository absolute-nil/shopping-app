import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_form_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({Key key, this.id, this.title, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ProductFormScreen.route_name, arguments: id);
                },
                color: Theme.of(context).accentColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text("Are you sure?"),
                            content: Text("Do you want to delete this item?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("NO")),
                              FlatButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    try {
                                      await Provider.of<Products>(context,
                                              listen: false)
                                          .deleteProduct(id);
                                    } catch (e) {
                                      scaffold.showSnackBar(SnackBar(
                                          content: Text(e.toString(), textAlign: TextAlign.center,)));
                                    }
                                  },
                                  child: Text("YES"))
                            ],
                          ));
                },
                color: Theme.of(context).errorColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
