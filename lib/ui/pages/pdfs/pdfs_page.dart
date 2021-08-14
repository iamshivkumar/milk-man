import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/ui/pages/pdf_generate/providers/generate_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/pdfs/pdf_vew_page.dart';
import 'package:milk_man_app/ui/pages/pdfs/providers/files_provider.dart';
import 'package:milk_man_app/ui/utils/dates.dart';
import 'package:milk_man_app/ui/widgets/loading.dart';

class PdfsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final filesAsync = watch(filesProvider);
    final model = watch(generateViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Pdfs"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () async {
          await model.createDoc(dateTime: Dates.today);

          context.refresh(filesProvider);
        },
      ),
      body: filesAsync.when(
        data: (files) => ListView(
          children: files
              .map(
                (e) => ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewPage(fileModel: e),
                      ),
                    );
                  },
                  title: Text(e.name),
                ),
              )
              .toList(),
        ),
        loading: () => Loading(),
        error: (e, s) => SizedBox(),
      ),
    );
  }
}
