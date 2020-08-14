import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = "/product-detail";

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    var top = 0.0;
    Widget _leading() {
      if (top != (MediaQuery.of(context).padding.top + kToolbarHeight))
        return BackButton(color: Colors.black);
      return null;
    }

    return Scaffold(
      // appBar: AppBar(title: ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            // leading: _leading(),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  title: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(right: 50),
                    color: top !=
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight)
                        ? Colors.black54
                        : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(loadedProduct.title, textAlign: TextAlign.center,),
                    ),
                  ),
                  background: Hero(
                      tag: loadedProduct.id,
                      child: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.cover,
                      )),
                );
              },
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Rs. ${loadedProduct.price}",
                style: TextStyle(color: Colors.grey, fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "${loadedProduct.description}",
                  style: TextStyle(fontSize: 15),
                  softWrap: true,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 800,
            )
          ]))
        ],
      ),
    );
  }
}
