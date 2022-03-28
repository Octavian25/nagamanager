import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:nagamanager/models/item_model.dart';
import 'package:nagamanager/models/stocking_argumen_model.dart';
import 'package:nagamanager/models/tracking_feedback_model.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/providers/providers.dart';
import 'package:nagamanager/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

part 'add_barang_widget.dart';
part 'bottom_sheet_select_item.dart';
part 'bottom_sheet_tracking.dart';
part 'item_card.dart';
part 'text_field_widget.dart';
