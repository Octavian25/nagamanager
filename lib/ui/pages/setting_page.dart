part of 'pages.dart';

Future<Uint8List> generateLaporanPersediaan(List<ItemModel>? data) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);
  final font1 = await PdfGoogleFonts.openSansRegular();
  final font2 = await PdfGoogleFonts.openSansBold();
  int grandtotal = data!
      .map((e) => e.qty * e.price)
      .reduce((value, element) => value + element);
  List<List<String>> tableData = data
      .map((e) => [
            e.name,
            e.qty.toString(),
            NumberFormat.currency(
                    symbol: "Rp. ", decimalDigits: 0, locale: "id-ID")
                .format(e.price),
            e.type,
            e.categoryCode,
            e.subCategoryCode,
            NumberFormat.currency(
                    symbol: "Rp. ", decimalDigits: 0, locale: "id-ID")
                .format(e.qty * e.price)
          ])
      .toList();

  doc.addPage(pw.MultiPage(
    theme: pw.ThemeData.withFont(
      base: font1,
      bold: font2,
    ),
    pageFormat: PdfPageFormat.a4.copyWith(
        marginLeft: 0.7 * PdfPageFormat.cm,
        marginRight: 0.7 * PdfPageFormat.cm),
    orientation: pw.PageOrientation.portrait,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    footer: (pw.Context context) {
      return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.Theme.of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey)));
    },
    build: (context) {
      return [
        pw.Header(
          level: 1,
          text: 'Laporan Persediaan Stock',
        ),
        pw.Table.fromTextArray(context: context, data: <List<String>>[
          <String>[
            'Nama Barang',
            'Stock',
            'Harga',
            'Satuan',
            'Kategori',
            'Sub Kategori',
            'Total'
          ],
          ...tableData,
        ]),
        pw.SizedBox(height: 20),
        pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
                "Grand Total :  ${NumberFormat.currency(symbol: "Rp. ", decimalDigits: 0, locale: "id-ID").format(grandtotal)}"))
      ];
    },
  ));
  return await doc.save();
}

class GenerateLaporanStock {
  final BuildContext context;
  final ChartProvider chartProvider;
  GenerateLaporanStock(this.context, this.chartProvider);

  Future<Uint8List> generateLaporanTracking(void _) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    List<List<String>> tableData = chartProvider
        .chartDetailBarangModel!.historyDetail!
        .map((e) => [
              e.tanggal,
              e.stockIn.toString(),
              e.stockOut.toString(),
              e.available.toString()
            ])
        .toList();

    doc.addPage(pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: font1,
        bold: font2,
      ),
      pageFormat: PdfPageFormat.a4.copyWith(
          marginLeft: 0.7 * PdfPageFormat.cm,
          marginRight: 0.7 * PdfPageFormat.cm),
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (context) {
        return [
          pw.Header(
            level: 1,
            text: 'Laporan Stock Barang',
          ),
          pw.Text(
              "Periode ${chartProvider.startDate} - ${chartProvider.endDate}",
              style: pw.TextStyle(font: font2, fontSize: 9.sp)),
          pw.SizedBox(height: 20),
          pw.Text("Nama Barang : ${chartProvider.barangSelected}",
              style: pw.TextStyle(font: font2, fontSize: 11.sp)),
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>[
              'Tanggal',
              'Stock In',
              'Stock Out',
              'Available Stock',
            ],
            ...tableData,
          ]),
          pw.SizedBox(height: 20)
        ];
      },
    ));
    return await doc.save();
  }
}
