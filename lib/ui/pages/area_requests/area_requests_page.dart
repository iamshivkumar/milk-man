import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/loading.dart';
import '../profile/providers/profile_provider.dart';
import 'widgets/request_sheet.dart';

class AreaRequestsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profileStream = watch(profileProvider);
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Areas"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => RequestSheet(profileStream.data!.value.id),
          );
        },
        label: Text("REQUEST"),
        icon: Icon(Icons.add),
      ),
      body: profileStream.when(
        data: (profile) => ListView(
          children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Pending Areas",
                    style: style.headline6,
                  ),
                )
              ] +
              profile.pendingAreas
                  .map(
                    (e) => ListTile(
                      title: Text(e),
                    ),
                  )
                  .toList() +
              [
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Rejected Areas",
                    style: style.headline6,
                  ),
                )
              ] +
              [] +
              [
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Active Areas",
                    style: style.headline6,
                  ),
                )
              ] +
              profile.areas
                  .map(
                    (e) => ListTile(
                      title: Text(e),
                    ),
                  )
                  .toList(),
        ),
        loading: () => Loading(),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
