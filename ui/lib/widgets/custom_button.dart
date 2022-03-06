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

  /// Required fields
  final String text;
  final Function onTap;

  CustomTextButton({
    Key? key,
    required this.text,
    required this.onTap,
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
  }) : super(key: key);

  /// Instantiating the color provider for the Button colors
  /// backgroundColor default == kcLightBeige
  /// color (text Color) default == kcMedBlue
  /// contains 1 function -> onHover(bool val)
  final _colorProvider = ChangeNotifierProvider<ButtonColorChangeNotifier>(
    (ref) => ButtonColorChangeNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Updates the color in case of a change
    final color = ref.watch(_colorProvider);

    return Center(
      child: InkWell(
        /// Disabling MouseCursor when the button is disabled or busy
        mouseCursor:
            disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,

        /// Checking if Button is NOT busy/disabled and
        ///
        /// Updating colors if that is the case
        onHover: (val) => (disabled || busy) ? () {} : color.onHover(val),

        /// Calling the provided onPressed function if that is the case
        onTap: () => (disabled || busy) ? () {} : onTap(),

        child: AnimatedContainer(
          width: (width * scale!).toDouble(),
          height: (height * scale!).toDouble(),

          /// Animation
          duration: duration,
          curve: curve,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            /// The border is not included in the animation
            /// Its color depends on:
            ///     busy
            ///     disabled
            border: border ??
                Border.all(
                  width: borderWidth,

                  /// BorderColor
                  color: busy || disabled ? busyOrDisabledColor : borderColor,
                ),

            borderRadius: borderRadius,

            /// Fill Color
            color:
                busy || disabled ? busyOrDisabledColor : color.backgroundColor,
            boxShadow: shadow
                ? [
                    const BoxShadow(
                        color: Color.fromARGB(255, 214, 211, 211),
                        blurRadius: 2,
                        spreadRadius: .2)
                  ]
                : [const BoxShadow(spreadRadius: 0, blurRadius: 0)],
          ),

          /// Checks if button is busy and shows ProgressIndicator if so
          /// else just the regular text
          child: busy
              ? const CircularProgressIndicator()
              : Text(
                  text,

                  /// Text Color
                  style: textStyle ??
                      TextStyle(
                        color: disabled ? kcLightGrey : color.color,
                      ),
                ),
        ),
      ),
    );
  }
}
