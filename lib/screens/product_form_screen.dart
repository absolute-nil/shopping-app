import 'package:flutter/material.dart';

import '../providers/product.dart';

class ProductFormScreen extends StatefulWidget {
  static const route_name = "/product-form";
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _savedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.removeListener(_updateImageURL);
    _imageURLController.dispose();
    super.dispose();
  }

  void _saveForm() {
    _form.currentState.save();
    print(_savedProduct.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: (){
            _saveForm();
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Title"),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _savedProduct = Product(
                          id: null,
                          title: value,
                          description: _savedProduct.description,
                          price: _savedProduct.price,
                          imageUrl: _savedProduct.imageUrl);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Price"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      _savedProduct = Product(
                          id: null,
                          title: _savedProduct.title,
                          description: _savedProduct.description,
                          price: double.parse(value),
                          imageUrl: _savedProduct.imageUrl);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Description"),
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) {
                      _savedProduct = Product(
                          id: null,
                          title: _savedProduct.title,
                          description: value,
                          price: _savedProduct.price,
                          imageUrl: _savedProduct.imageUrl);
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(right: 10, top: 8),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Container(
                          child: _imageURLController.text.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Icon(Icons.image),
                                      Text("Enter Url")
                                    ])
                              : FittedBox(
                                  child: Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Image URL"),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.url,
                          controller: _imageURLController,
                          focusNode: _imageURLFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) {
                            _savedProduct = Product(
                                id: null,
                                title: _savedProduct.title,
                                description: _savedProduct.description,
                                price: _savedProduct.price,
                                imageUrl: value);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
