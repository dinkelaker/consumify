import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

import '../widgets/app_drawer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formGlobalKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  var _initialValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _initialValuesSet = false;

  @override
  void initState() {
    // register listener to execute _updateImageUrl
    // whenever loosing focus of imageUrl field
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_initialValuesSet) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);

        _initialValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
        _initialValuesSet = true;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.disc_full),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formGlobalKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initialValues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // when this input is submitted, go to Price input
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) return 'Please provide a tile.';
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initialValues['price'],
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // when this input is submitted, go to Price input
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) return 'Please provide a price.';
                    double price = double.tryParse(value);
                    if (price == null) return 'Please enter a number.';
                    if (price <= 0)
                      return 'Please enter a number greater than 0.';
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                ),
                TextFormField(
                  initialValue: _initialValues['description'],
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // when this input is submitted, go to Price input
                    FocusScope.of(context).requestFocus(_imageFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) return 'Please provide a description';
                    if (value.length < 10)
                      return 'Please enter at least 10 characters.';
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                  focusNode: _descriptionFocusNode,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Container(
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter a URL to an image')
                            : FittedBox(
                                child: Image.network(_imageUrlController.text,
                                    fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        //initialValue: not allowed since this field uses a controller,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please provide a url for an image.';
                          if (!value.startsWith('http') &&
                              !value.startsWith('https'))
                            return 'Please provide a valid url.';
                          if (!value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg') &&
                              !value.endsWith('.png') &&
                              !value.endsWith('.gif'))
                            return 'Please provide a valid image format.';
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        controller: _imageUrlController,
                        focusNode: _imageFocusNode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  void _updateImageUrl() {
    // this listener will only be called if imageUrl field had focus
    if (!_imageFocusNode.hasFocus) {
      // but only when we lost focus, we need to update
      setState(() {
        // we do not need to update state
        // since we know that the state updated
      });
    }
  }

  @override
  void dispose() {
    print("Disposing focus nodes and controller for edit product form");
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    // only save form if valid
    final isValid = _formGlobalKey.currentState.validate();
    if (!isValid) return;

    // we can save the form via its global key
    _formGlobalKey.currentState.save();
    // print(_editedProduct.id);
    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }
}
