import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/ui/pages/orders/providers/filterer_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/profile/providers/profile_provider.dart';

class Filterer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final List<String> areas = watch(profileProvider).data!.value.areas;
    final model = watch(filtererViewModelProvider);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "Area",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                ),
                value: areas.contains(model.area) ? model.area : null,
                onChanged: (v) => model.area = v,
                items: areas
                    .map(
                      (e) => DropdownMenuItem<String>(
                        child: Text(
                          e,
                        ),

                        value: e,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => model.number = v,
                decoration: InputDecoration(
                  labelText: "Flat Number",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
