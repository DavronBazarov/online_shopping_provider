import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/product.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const String routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();

  var product = ModelProduct(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageUrl: '',
  );

  var _init = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        ///..Mahsulotni eski malumotini olish
        final editingProduct =
            Provider.of<Products>(context).findById(productId as String);
        product = editingProduct;
      }
    }
    _init = false;
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Rasm URL-ni kiriting!'),
          content: Form(
            key: _imageForm,
            child: TextFormField(
              initialValue: product.imageUrl,
              decoration: const InputDecoration(
                labelText: 'Rasm URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              onSaved: (newValue) {
                product = ModelProduct(
                  id: product.id,
                  title: newValue!,
                  description: product.description,
                  price: product.price,
                  imageUrl: newValue,
                  isFavorite: product.isFavorite,
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos, rasm URL-ni kiriting.";
                } else if (!value.startsWith("http")) {
                  return "Iltimos, to'g'ri rasm URL-ni kiriting.";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("BEKOR QILISH"),
            ),
            ElevatedButton(
                onPressed: _saveImageForm, child: const Text("SAQLASH")),
          ],
        );
      },
    );
  }

  void _saveImageForm() {
    final isValidImage = _imageForm.currentState!.validate();
    if (isValidImage) {
      _imageForm.currentState!.save();
      setState(() {});
      Navigator.pop(context);
    }
  }

  var hasImage = true;

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    setState(() {
      hasImage = product.imageUrl.isNotEmpty;
    });
    if (isValid) {
      _form.currentState!.save();
      if (product.id.isEmpty) {
        Provider.of<Products>(context, listen: false).addProduct(product);
      } else {
        Provider.of<Products>(context, listen: false).updateProduct(product);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulot Qo'shish"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: product.title,
                  decoration: const InputDecoration(
                    labelText: 'Nomi',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (newValue) {
                    product = ModelProduct(
                      id: product.id,
                      title: newValue!,
                      description: product.description,
                      price: product.price,
                      imageUrl: product.imageUrl,
                      isFavorite: product.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, mahsulot nomini kiriting.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: product.price == 0 ? "" : product.price.toStringAsFixed(2),
                  decoration: const InputDecoration(
                    labelText: 'Narxi',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (newValue) {
                    product = ModelProduct(
                      id: product.id,
                      title: product.title,
                      description: product.description,
                      price: double.parse(newValue!),
                      imageUrl: product.imageUrl,
                      isFavorite: product.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, mahsulot narxini kiriting.';
                    } else if (double.tryParse(value) == null) {
                      return 'Iltimos, to\'g\'ri narx kiriting.';
                    } else if (double.parse(value) < 1) {
                      return "Mahsulot narxi 0 dan katta bo'lishi kerak.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: product.description,
                  decoration: const InputDecoration(
                    labelText: "Qo'shimcha malumot",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  onSaved: (newValue) {
                    product = ModelProduct(
                      id: product.id,
                      title: product.title,
                      description: newValue!,
                      price: product.price,
                      imageUrl: product.imageUrl,
                      isFavorite: product.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, mahsulot tarifini kiriting.';
                    } else if (value.length < 10) {
                      return 'Iltimos, batafsil ma\'lumot kiriting.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color:
                          hasImage ? Colors.grey : Theme.of(context).colorScheme.error,
                    ),
                  ),
                  child: InkWell(
                    splashColor:
                        Theme.of(context).primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(5),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      _showImageDialog(context);
                    },
                    child: Container(
                      height: 180,
                      alignment: Alignment.center,
                      child: product.imageUrl.isEmpty
                          ? Text(
                              "Asosiy rasm Url-ni kiriting!",
                              style: TextStyle(
                                color: hasImage
                                    ? Colors.black
                                    : Theme.of(context).colorScheme.error,
                              ),
                            )
                          : Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
