part of widgets;

class CustomTextButton extends ConsumerWidget {
  /// Optional fields
  final Border? border;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final Color borderColor;
  final double height;
  final double width;
  final TextStyle? textStyle;
  final Color busyOrDisabledColor;
  final Color activeColor;
  final Curve curve;
  final Duration duration;
  final bool disabled;
  final bool busy;
  final bool shadow;
  final double? scale;
  final EdgeInsets? margin;
  final Icon? icon;

  /// Required fields
  final String text;
  final Function onTap;

  CustomTextButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.margin,
    this.border,
    this.borderRadius,
    this.borderWidth = 1,
    this.borderColor = kcMedBlue,
    this.height = 50,
    this.width = 300,
    this.textStyle,
    this.busyOrDisabledColor = kcVeryLightBlue,
    this.activeColor = kcMedBlue,
    this.curve = Curves.easeIn,
    this.duration = const Duration(milliseconds: 200),
    this.busy = false,
    this.disabled = false,
    this.shadow = true,
    this.scale = .8,
    this.icon,
  }) : super(key: key);

  final _colorProvider = ChangeNotifierProvider<ButtonColorChangeNotifier>(
    (ref) => ButtonColorChangeNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Updates the color in case of a change
    final color = ref.watch(_colorProvider);

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 10),
      child: Center(
        child: InkWell(
          mouseCursor: disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onHover: (val) => (disabled || busy) ? () {} : color.onHover(val),
          onTap: () => (disabled || busy) ? () {} : onTap(),
          child: AnimatedContainer(
            width: (width * scale!).toDouble(),
            height: (height * scale!).toDouble(),
            duration: duration,
            curve: curve,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: border ??
                  Border.all(
                    width: borderWidth,
                    color: busy || disabled ? busyOrDisabledColor : borderColor,
                  ),
              borderRadius: borderRadius,
              color: busy || disabled
                  ? busyOrDisabledColor
                  : color.backgroundColor,
            ),
            child: busy
                ? const CircularProgressIndicator()
                : icon ??
                    Text(
                      text,

                      /// Text Color
                      style: textStyle ??
                          TextStyle(
                            color: disabled ? kcLightGrey : color.color,
                          ),
                    ),
          ),
        ),
      ),
    );
  }
}
