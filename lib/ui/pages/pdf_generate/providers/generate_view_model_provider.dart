import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/order.dart';
import 'package:milk_man_app/core/enums/order_status.dart';
import 'package:milk_man_app/core/models/pdf_order.dart';
import 'package:milk_man_app/core/models/subscription.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';
import 'package:milk_man_app/ui/pages/pdfs/providers/path_giver.dart';
import 'package:milk_man_app/ui/utils/utils.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

final generateViewModelProvider = ChangeNotifierProvider((ref)=>GenerateViewModel(ref));

class GenerateViewModel extends ChangeNotifier {
  final ProviderReference ref;

  GenerateViewModel(this.ref);

  Repository get _repository => ref.read(repositoryProvider);

  Future<void> createDoc({required DateTime dateTime}) async {
    final List<PdfOrder> pdfOrders = [];
    print("1");
    final List<Subscription> subscriptions =
        await _repository.subscriptionsFuture();
    for (var s in subscriptions.where((element) => element.deliveries.where((e) => e.date==dateTime).isNotEmpty).toList()) {
      pdfOrders.add(PdfOrder.fromSubscription(subscription: s, date: dateTime));
    }
    print("2");
    final List<Order> orders = await _repository.ordersFuture(dateTime);
    for (var o in orders) {
      pdfOrders.add(PdfOrder.fromOrder(o));
    }
    print("3");
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 9);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Index';
    headerRow.cells[1].value = 'Customer';
    headerRow.cells[2].value = 'Area';
    headerRow.cells[3].value = 'Address';
    headerRow.cells[4].value = 'Product';
    headerRow.cells[5].value = 'Price';
    headerRow.cells[6].value = 'Quantity';
    headerRow.cells[7].value = 'Total';
    headerRow.cells[8].value = 'Status';

    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    print("4");
    for (var order in pdfOrders) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = pdfOrders.indexOf(order).toString();
      row.cells[1].value = order.customerName;
      row.cells[2].value = order.area;
      row.cells[3].value = order.address;
      row.cells[4].value = order.products.first.name;
      row.cells[5].value = order.products.first.price;
      row.cells[6].value = order.products.first.quantity;
      row.cells[7].value = order.total;
      row.cells[8].value = order.status;
      // row.style = PdfGridRowStyle(
      //   backgroundBrush:  PdfBrushes.lightGreen
      // );
      for (var product in order.products.skip(1)) {
        PdfGridRow r = grid.rows.add();
        r.cells[4].value = product.name;
        r.cells[5].value = product.price;
        r.cells[6].value = product.quantity;
      }
    }
    print("5");
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5,right: 5,bottom: 5);
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 0, page.getClientSize().width, page.getClientSize().height),
    );
     print("6");
    final String? path = ref.read(pathProvider).state;
    if (path == null) {
      return;
    }
    await File("$path/${Utils.formatedDate(dateTime)}.pdf")
        .writeAsBytes(document.save());
    document.dispose();
  }


}
