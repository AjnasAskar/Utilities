import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trikart_flutter_app/common/consts.dart';
import 'package:trikart_flutter_app/generated/l10n.dart';
import 'package:trikart_flutter_app/providers/connectivity_provider.dart';
import 'package:trikart_flutter_app/widgets/common_button.dart';
import 'package:trikart_flutter_app/widgets/reusable_widgets.dart';

import 'common_error_page.dart';

class NetworkConnectivity extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Function? onTap;
  final Color color;

  NetworkConnectivity(
      {required this.child,
      this.inAsyncCall = false,
      this.opacity = 0.3,
      this.onTap,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, snapshot, _) {
      List<Widget> widgetList = [];
      widgetList.add(child);
      if (!snapshot.isConnected || snapshot.enableRefresh) {
        widgetList.add(Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.white,
          alignment: Alignment.center,
          child: CommonErrorPage(
              defaultFont: false,
              fromPage: 'home',
              errorTitle: S.of(context).noInternet,
              errorSubTitle: S.of(context).noInternetDesc,
              buttonText: S.of(context).refresh,
              onButtonTap: () {
                snapshot.updateEnableRefresh();
                if (onTap != null) {
                  onTap!();
                }
              }),
        ));
      }
      if (inAsyncCall) {
        final modal = Stack(
          children: [
            Opacity(
              opacity: opacity,
              child: ModalBarrier(dismissible: false, color: color),
            ),
            ReusableWidgets.circularLoader(),
          ],
        );
        widgetList.add(modal);
      }
      return Stack(
        children: widgetList,
      );
    });
  }
}
