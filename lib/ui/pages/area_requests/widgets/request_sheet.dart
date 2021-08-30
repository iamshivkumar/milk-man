import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/providers/key_provider.dart';
import '../providers/request_area_view_model_provider.dart';

class RequestSheet extends ConsumerWidget {
  final String id;

  RequestSheet(this.id);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final _formKey = watch(keyProvder);
    final model = watch(requestAreaViewModelProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
        left: 8,
        right: 8,
        top: 8,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Request Area",
                style: style.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                validator: (v) => v!.isEmpty ? "Enter Area Name" : null,
                decoration: InputDecoration(
                  labelText: "Area Name",
                ),
                onSaved: (v) => model.area = v!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                validator: (v) => v!.isEmpty ? "Enter City Name" : null,
                decoration: InputDecoration(
                  labelText: "City Name",
                ),
                onSaved: (v) => model.city = v!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: theme.accentColor,
                child: Text("REQUEST"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    model.request(
                        onRequest: () {
                          Navigator.pop(context);
                        },
                        id: id);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
