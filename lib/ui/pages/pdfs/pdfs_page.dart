import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';

import '../../utils/dates.dart';
import '../../widgets/loading.dart';
import '../pdf_generate/providers/generate_view_model_provider.dart';
import 'pdf_vew_page.dart';
import 'providers/files_provider.dart';

class PdfsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final filesAsync = watch(filesProvider);
    final model = watch(generateViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Pdfs"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text("GENERATE"),
        onPressed: () async {
       final date =   await showDatePicker(
            context: context,
            initialDate: Dates.today,
            firstDate: DateTime(2020),
            lastDate: DateTime(2025),
          );
          if(date==null){
            return;
          }
          await model.createDoc(dateTime: date);
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
                  trailing: IconButton(
                    onPressed: () async {
                      await Share.shareFiles(
                        [e.file.path],
                        text: e.name,
                      );
                    },
                    icon: Icon(Icons.share),
                  ),
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
