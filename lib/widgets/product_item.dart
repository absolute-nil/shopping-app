import 'package:flutter/material.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  ProductItem(this.id, this.title, this.description, this.price, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(1.0, 1.0),
              spreadRadius: 2.0)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Stack(
            children: <Widget>[
              new Positioned.fill(child:
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ) 
              )
              ,
              new Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  
                  child: InkWell(
                    splashColor: Theme.of(context).accentColor.withOpacity(0.4),

                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: id,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          // child: GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).pushNamed(
          //       ProductDetailScreen.routeName,
          //       arguments: id,
          //     );
          //   },
          //   child: Image.network(
          //     imageUrl,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
