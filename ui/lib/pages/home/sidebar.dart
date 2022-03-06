import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class SideBar extends ConsumerWidget {
  final double height;
  final double width;
  SideBar({
    this.height = double.infinity,
    this.width = 200,
    Key? key,
  }) : super(key: key);

  Map<String, Function> sideBarItems = {
    "O R G A N I Z A T I O N S": () {},
    "P R O J E C T S": () {},
    "T A S K S": () {},
    "M E S S A G E S": () {},
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kcIceBlue,
      ),
      child: Column(
        children: <Widget>[
          SideBarItem(
            text: "O R G A N I Z A T I O N S",
            onTap: () {},
          ),
          SideBarItem(
            text: "P R O J E C T S",
            onTap: () {},
          ),
          SideBarItem(
            text: "T A S K S",
            onTap: () {},
          ),
          SideBarItem(
            text: "M E S S A G E S",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class SideBarItem extends ConsumerWidget {
  final Duration duration;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback onTap;
  final double height;
  final double width;
  final Color color, textColor;
  final Color? accentColor;
  final bool shadow;
  final double margin;
  final EdgeInsets padding;
  final IconData? prefixIcon, suffixIcon;
  final BorderRadius? borderRadius;
  SideBarItem({
    required this.text,
    required this.onTap,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.height = 30,
    this.width = 200,
    this.color = kcIceBlue,
    this.textColor = kcDarkBlue,
    this.duration = const Duration(milliseconds: 200),
    this.accentColor,
    this.shadow = true,
    this.margin = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    Key? key,
  }) : super(key: key);

  final _hoveringNotifier = ChangeNotifierProvider<SideBarItemChangeNotifier>(
    (ref) => SideBarItemChangeNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hovering = ref.watch(_hoveringNotifier);

    return AnimatedContainer(
      duration: duration,
      margin: const EdgeInsets.only(bottom: 10),
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: hovering.backgroundColor,
        borderRadius: borderRadius,
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: hovering.shadowColor,
                  blurRadius: hovering.blurRadius,
                  spreadRadius: hovering.shadowSpread,
                )
              ]
            : [const BoxShadow(spreadRadius: 0, blurRadius: 0)],
      ),
      child: InkWell(
        onTap: onTap,
        onHover: (val) => hovering.onHover(val),
        child: Center(
          child: Text(
            text,
            // textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: hovering.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class SideBarItemChangeNotifier extends ChangeNotifier {
  bool _hovering = false;
  Color _shadowColor = kcLightGrey;
  double _shadowSpread = .4;
  double _blur = .5;
  Color _backgroundColor = Colors.white;
  Color _textColor = kcDarkBlue.withOpacity(.9);
  bool get hovering => _hovering;
  Color get shadowColor => _shadowColor;
  double get shadowSpread => _shadowSpread;
  double get blurRadius => _blur;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  set hovering(bool val) {
    _hovering = val;
    notifyListeners();
  }

  set shadowColor(Color newShadowColor) {
    _shadowColor = newShadowColor;
    notifyListeners();
  }

  set shadowSpread(double newSpread) {
    _shadowSpread = newSpread;
    notifyListeners();
  }

  set blurRadius(double newBlur) {
    _blur = newBlur;
    notifyListeners();
  }

  set backgroundColor(Color newBackgroundColor) {
    _backgroundColor = newBackgroundColor;
    notifyListeners();
  }

  set textColor(Color newTextColor) {
    _textColor = newTextColor;
    notifyListeners();
  }

  void onHover(bool val) {
    hovering = val;
    shadowColor = val ? kcIceBlue : kcLightGrey.withOpacity(.5);
    shadowSpread = val ? .5 : .5;
    blurRadius = val ? .5 : 1.0;
    backgroundColor = val ? kcMedBlue : Colors.white;
    textColor = val ? Colors.white : kcDarkBlue.withOpacity(.9);
    notifyListeners();
  }
}
