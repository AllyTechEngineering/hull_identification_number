import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _hinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HIN Validation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _hinController,
                decoration: InputDecoration(labelText: 'Enter HIN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a HIN';
                  }

                  // Use RegExp for HIN validation
                  RegExp hinRegExp = RegExp(r'^[A-Za-z]{3}\d{5}\d{2}\d{2}$');
                  if (!hinRegExp.hasMatch(value)) {
                    return 'Invalid HIN format. Please enter a valid HIN.';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, perform further processing.
                    validateHIN(_hinController.text);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add your HIN validation logic here
  void validateHIN(String hin) {
    // For simplicity, I'll just print the result for now
    print('HIN Validation Result: $hin');
  }
}
