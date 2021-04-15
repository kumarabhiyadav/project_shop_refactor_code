import 'package:flutter/material.dart';
import 'package:project_shop/providers/product.dart';
import 'package:project_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = './edit_product_screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
    void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
  final _imageUrlController = TextEditingController();
  String appBarTitle = '';
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;


  @override
  void didChangeDependencies() {
    if (_isInit) {
      final appBarAndproductId =
          ModalRoute.of(context).settings.arguments as List;
      if (appBarAndproductId == null) {
        appBarTitle = "Add New Product";
      }

      if (appBarAndproductId != null) {
        if (appBarAndproductId.length == 2) {
          appBarTitle = appBarAndproductId[0].toString();
          _editedProduct = Provider.of<Products>(context, listen: false)
              .findProductbyId(appBarAndproductId[1].toString());
          _initValues = {
            'title': _editedProduct.title,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
            'imageUrl': '',
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _onSubmitForm() async {
    if (_form.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _form.currentState.save();
      if (_editedProduct.id == null) {
         try {
           await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
         } catch (e) {
               _showErrorDialog(e);
         }
        
      }
      if (_editedProduct.id != null) {
       
        try {
          await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        } catch (e) {
          _showErrorDialog(e);
        }
      }
    } else {
      
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

        return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _onSubmitForm();
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ))
          : SingleChildScrollView(
              child: Container(
                
                padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal:width *0.025),
                child: Column(
                  children: [
                    Card(
                      
                      child: Form(
                        key: _form,
                        child: Padding(
                          padding: EdgeInsets.all(width *0.020),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Name:",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Padding(
                                padding:  EdgeInsets.all(width *0.020),
                                child: TextFormField(
                                  initialValue: _initValues['title'],
                                  decoration: InputDecoration(),
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return "Please Enter Product Name";

                                    return null;
                                  },
                                  onSaved: (val) {
                                    _editedProduct = Product(
                                        id: _editedProduct.id,
                                        title: val,
                                        description: _editedProduct.description,
                                        price: _editedProduct.price,
                                        imageUrl: _editedProduct.imageUrl);
                                  },
                                ),
                              ),
                              Text(
                                "Description:",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Padding(
                                padding:EdgeInsets.all(width *0.020),
                                child: TextFormField(
                                  initialValue: _initValues['description'],
                                  decoration: InputDecoration(
                                      hintText: 'Enter description'),
                                  maxLines: 3,
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return "Please Enter Description of Your Product";
                                    if (val.length <= 10)
                                      return "Please Enter more About your product";
                                    return null;
                                  },
                                  onSaved: (val) {
                                    _editedProduct = Product(
                                        id: _editedProduct.id,
                                        title: _editedProduct.title,
                                        description: val,
                                        price: _editedProduct.price,
                                        imageUrl: _editedProduct.imageUrl);
                                  },
                                ),
                              ),
                              Text(
                                "Price:",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(width *0.020),
                                child: TextFormField(
                                  initialValue: _initValues['price'],
                                  decoration: InputDecoration(
                                      hintText: 'Enter Price of Product'),
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return "Please Enter Price Of Your Product";
                                    if (double.tryParse(val) <= 0)
                                      return "Value Should not be less than 0";
                                    return null;
                                  },
                                  onSaved: (val) {
                                    _editedProduct = Product(
                                        id: _editedProduct.id,
                                        title: _editedProduct.title,
                                        description: _editedProduct.description,
                                        price: double.parse(val),
                                        imageUrl: _editedProduct.imageUrl);
                                  },
                                ),
                              ),
                              Text(
                                "Image URL:",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(width *0.020),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'Enter Image Url'),
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return "Please Enter Image URL";

                                    return null;
                                  },
                                  controller: _imageUrlController,
                                  onSaved: (val) {
                                    _editedProduct = Product(
                                        id: _editedProduct.id,
                                        title: _editedProduct.title,
                                        description: _editedProduct.description,
                                        price: _editedProduct.price,
                                        imageUrl: _imageUrlController.text);
                                  },
                                ),
                              ),
                              Center(
                                child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: _imageUrlController.text.isEmpty
                                        ? Text('Enter a URL')
                                        : Image.network(
                                            _imageUrlController.text)),
                              ),
                              Center(
                                  child: TextButton(
                                      onPressed: () {
                                       setState(() {
                                          
                                       });
                                      },
                                      child: Text('Load Image')))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        elevation: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                _onSubmitForm();
                              },
                              child: Text("Save Product Details",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style:
                                  TextButton.styleFrom(primary: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
