import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nagamanager/models/chart_annual_model.dart';
import 'package:nagamanager/models/item_model.dart';
import 'package:nagamanager/models/stocking_argumen_model.dart';
import 'package:nagamanager/models/stocking_model.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/providers/providers.dart';
import 'package:nagamanager/providers/tracking_provider.dart';
import 'package:nagamanager/shared/shared.dart';
import 'package:nagamanager/ui/widgets/detail_chart_widget.dart';
import 'package:nagamanager/ui/widgets/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

import '../../models/chart_detail_barang_model.dart';
import '../../models/location_model.dart';
import '../../providers/loading_provider.dart';
import '../../providers/location_provider.dart';
import '../../shared/helper.dart';
import '../widgets/chart_widget.dart';
import '../widgets/pie_chart_out_widget.dart';
import '../widgets/pie_chart_widget.dart';

part 'base_page.dart';
part 'dashboard_page.dart';
part 'detail_chart_page.dart';
part 'detail_stock_page.dart';
part 'home_page.dart';
part 'location_page.dart';
part 'login_page.dart';
part 'splash_page.dart';
part 'stocking_page.dart';
part 'tracking_camera_page.dart';
part 'tracking_page.dart';
part 'edit_item_page.dart';
