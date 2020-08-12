import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

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
  var _savedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavourite: false,
  );

  var _isInit = true;
  var _loading = false;

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _savedProduct = Provider.of<Products>(context).findById(productId);
        _imageURLController.text = _savedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      if ((!_imageURLController.text.startsWith("http") &&
              !_imageURLController.text.startsWith("https")) ||
          (!_imageURLController.text.endsWith(".png") &&
              !_imageURLController.text.endsWith(".jpg") &&
              !_imageURLController.text.endsWith(".jpeg"))) {
        return;
      }

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
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _loading = true;
    });
    if (_savedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_savedProduct.id, _savedProduct);
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_savedProduct)
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Could not process request"),
                  content: Text("Some error occoured please try again"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      }).then((value) {
        setState(() {
          _loading = false;
        });
        Navigator.of(context).pop();
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _savedProduct.title,
                          decoration: InputDecoration(labelText: "Title"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _savedProduct = Product(
                                id: _savedProduct.id,
                                isFavourite: _savedProduct.isFavourite,
                                title: value,
                                description: _savedProduct.description,
                                price: _savedProduct.price,
                                imageUrl: _savedProduct.imageUrl);
                          },
                        ),
                        TextFormField(
                          initialValue: _savedProduct.price.toString(),
                          decoration: InputDecoration(labelText: "Price"),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            if (double.tryParse(value) == null) {
                              return 'please enter a valid number';
                            }

                            if (double.parse(value) < 0) {
                              return 'please enter a value greater than 0';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _savedProduct = Product(
                                id: _savedProduct.id,
                                isFavourite: _savedProduct.isFavourite,
                                title: _savedProduct.title,
                                description: _savedProduct.description,
                                price: double.parse(value),
                                imageUrl: _savedProduct.imageUrl);
                          },
                        ),
                        TextFormField(
                          initialValue: _savedProduct.description,
                          decoration: InputDecoration(labelText: "Description"),
                          minLines: 3,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            if (value.length < 10) {
                              return 'description must contain atleast 10 words';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _savedProduct = Product(
                                id: _savedProduct.id,
                                isFavourite: _savedProduct.isFavourite,
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
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: Container(
                                child: _imageURLController.text.isEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                controller: _imageURLController,
                                focusNode: _imageURLFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'please provide a value';
                                  }

                                  if (!value.startsWith("http") ||
                                      !value.startsWith("https")) {
                                    return 'please provide a valid url';
                                  }

                                  if (!value.endsWith(".png") &&
                                      !value.endsWith(".jpg") &&
                                      !value.endsWith(".jpeg")) {
                                    return "images should be in png,jpg,jpeg format";
                                  }

                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _savedProduct = Product(
                                      id: _savedProduct.id,
                                      isFavourite: _savedProduct.isFavourite,
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
