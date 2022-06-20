part of 'widgets.dart';

class FilterBarangWidget extends StatefulWidget {
  const FilterBarangWidget({Key? key}) : super(key: key);

  @override
  _FilterBarangWidgetState createState() => _FilterBarangWidgetState();
}

class _FilterBarangWidgetState extends State<FilterBarangWidget> {
  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    return SizedBox(
      width: 400.w,
      child: Column(
        children: [
          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide()),
                prefixIcon: Icon(Icons.search)),
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          itemProvider.changeShow(index);
                        },
                        leading: Checkbox(
                          onChanged: (value) {
                            itemProvider.changeShow(index);
                          },
                          value:
                              itemProvider.listDetailStockFilter[index].isShow,
                        ),
                        title: Text(
                            itemProvider.listDetailStockFilter[index].name),
                      ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: itemProvider.listDetailStockFilter.length))
        ],
      ),
    );
  }
}

class FilterBarangWidgetMobile extends StatefulWidget {
  const FilterBarangWidgetMobile({Key? key}) : super(key: key);

  @override
  _FilterBarangWidgetMobileState createState() =>
      _FilterBarangWidgetMobileState();
}

class _FilterBarangWidgetMobileState extends State<FilterBarangWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    return SizedBox(
      width: 400.w,
      child: Column(
        children: [
          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide()),
                prefixIcon: Icon(Icons.search)),
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          itemProvider.changeShow(index);
                        },
                        leading: Checkbox(
                          onChanged: (value) {
                            itemProvider.changeShow(index);
                          },
                          value:
                              itemProvider.listDetailStockFilter[index].isShow,
                        ),
                        title: Text(
                            itemProvider.listDetailStockFilter[index].name),
                      ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: itemProvider.listDetailStockFilter.length))
        ],
      ),
    );
  }
}
