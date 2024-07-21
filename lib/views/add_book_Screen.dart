import 'package:ebook/component/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ebook/models/book_model.dart';
import 'package:ebook/book_repo/book_repository.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _authorController = TextEditingController();
  final _programmingLanguageController = TextEditingController();
  final _copiesController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _authorController.dispose();
    _programmingLanguageController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addBook() async {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        author: _authorController.text,
        programmingLanguage: _programmingLanguageController.text,
        imagePath: _image?.path,
        copies: int.parse(_copiesController.text),
      );

      final bookRepository = BookRepository();
      await bookRepository.insertBook(book);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                controller: _titleController,
                labelText: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: _subtitleController,
                labelText: 'Subtitle',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subtitle';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: _authorController,
                labelText: 'Author',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: _programmingLanguageController,
                labelText: 'Programming Language',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a programming language';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: _copiesController,
                labelText: 'Copies',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of copies';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _image == null
                  ? TextButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    )
                  : Image.file(_image!, height: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: const Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
