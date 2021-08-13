import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/profile.dart';

import 'package:milk_man_app/core/providers/key_provider.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';
import 'package:milk_man_app/ui/pages/profile/providers/profile_provider.dart';
import 'package:milk_man_app/ui/utils/labels.dart';

class AddWalletAmountSheet extends ConsumerWidget {
  final String id;
  AddWalletAmountSheet(
    this.id,
  );
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _formKey = watch(keyProvder);
    final theme = Theme.of(context);
    final Profile profile = context.read(profileProvider).data!.value;
    double? amount;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Add wallet amount"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                onSaved: (v) => amount = double.parse(v!),
                validator: (v) {
                  if(v!.isEmpty){
                    return "Enter Amount";
                  } else if(double.parse(v)>profile.walletAmount){
                    return "You don't have this much wallet amount";
                  } else if(double.parse(v)<0){
                    return "Should not be negative";
                  }
                },
                decoration: InputDecoration(
                  prefixText: Labels.rupee + " ",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    context.read(repositoryProvider).addWalletAmount(
                          amount: amount!,
                          id: id,
                          milkManId:profile.id,
                        );
                    Navigator.pop(context);
                  }
                },
                color: theme.accentColor,
                child: Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
