import 'package:flutter/material.dart';


class CustomDropdown extends StatefulWidget {
  final String text;
  final List<Widget> dropDownList;
  final Function(int index) onMenuTap;
  final int? index;
  const CustomDropdown(
      {Key? key,
      required this.text,
      required this.dropDownList,
      this.index,
      required this.onMenuTap})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey? actionKey;
  double? height, width, xPosition, yPosition;

  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.text);
    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox =
        actionKey!.currentContext!.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition! + (height ?? 0),
        height: context.height(size: 0.18),
        child: _dropDown(
          itemHeight: (height ?? 0),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataProvider>(builder: (_, model, __) {
      return InkWell(
        key: actionKey,
        onTap: () {
          if (model.isDropdownOpened) {
            context.read<AppDataProvider>().removeOverLay();
          } else {
            findDropdownData();
            context
                .read<AppDataProvider>()
                .updateFloatingDropdown(_createFloatingDropdown(), context);
            model.updateIsDropdownOpened(true);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: FontStyle.black14SemiBold,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Image.asset(
                  'assets/images/drop_down.png',
                  width: 7.w,
                  height: 6.h,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _dropDown({required double itemHeight}) {
    return Column(
      children: <Widget>[
        Material(
          elevation: 10,
          child: Container(
            height: context.height(size: 0.18),
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.dropDownList.length,
                padding: const EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context.read<AppDataProvider>().removeOverLay();
                      widget.onMenuTap(index);
                    },
                    child: widget.dropDownList[index],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
