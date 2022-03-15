part of widgets;

class CustomTextField extends ConsumerWidget {
  final Border? border;
  final BorderRadius? borderRadius;
  final TextAlign textAlign;
  final double width, height;
  final double? wordSpacing, letterSpacing;
  final Color backgroundColor, textColor;
  final Color? accentColor;
  final String? hintText;
  final Icon? prefixIcon, suffixIcon;
  final TextInputType inputType;
  final EdgeInsets? margin, padding;
  final Duration duration;
  final VoidCallback? onClickSuffix;
  final TextBaseline? textBaseline;
  final TextStyle? textStyle;
  final InputDecoration? inputDecoration;
  final String? autofillHints;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? enabled;
  final bool autofocus, isShadow;
  bool obscureText;
  final FocusNode? focusNode;
  final int? minLines, maxLines;
  final ValueChanged<String>? onChanged;
  final Function? validator;
  final GestureTapCallback? onTap;
  TextEditingController? controller;

  CustomTextField({
    this.width = 500,
    this.height = 70,
    this.inputType = TextInputType.text,
    this.accentColor = kcMedBlue,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.wordSpacing = 3.0,
    this.letterSpacing = 3.0,
    this.fontSize = 16,
    this.autofocus = false,
    this.obscureText = false,
    this.isShadow = true,
    this.duration = const Duration(milliseconds: 300),
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
    this.fontStyle,
    this.autofillHints,
    this.textStyle,
    this.border,
    this.borderRadius,
    this.inputDecoration,
    this.padding,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.margin = const EdgeInsets.only(
      bottom: 15,
    ),
    this.onClickSuffix,
    this.textBaseline,
    this.fontWeight,
    this.enabled,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.controller,
    this.textAlign = TextAlign.start,
    Key? key,
  }) : super(key: key);

  final statusProvider = ChangeNotifierProvider<TextFieldNotifier>(
    (ref) => TextFieldNotifier(),
  );

  Future<void> toggleFocus(TextFieldNotifier status) async {
    status.shadowColor = kcVeryLightBlue;
    status.isFocus = true;
    await Future.delayed(
      const Duration(milliseconds: 2500),
    );
    status.isFocus = false;
    status.shadowColor = kcLightGrey;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(statusProvider);

    return AnimatedContainer(
      duration: duration,
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: isShadow
            ? [
                BoxShadow(
                    color: status.shadowColor,
                    blurRadius: status.blurRadius,
                    spreadRadius: status.shadowSpread)
              ]
            : [const BoxShadow(spreadRadius: 0, blurRadius: 0)],
      ),
      child: Stack(
        children: <Widget>[
          BackgroundColorWidget(
            duration: duration,
            status: status,
            borderRadius: borderRadius,
            accentColor: accentColor,
            backgroundColor: backgroundColor,
          ),
          InkWell(
            // onHover: (val) => status.onTextFieldHover(val),
            onTap: () async {
              if (suffixIcon == null &&
                  controller != null &&
                  obscureText != true) {
                controller!.clear();
              } else {
                status.obscured = true;
              }
              await toggleFocus(status);
              status.obscured = false;
            },
            child: SuffixIconWidget(
              suffixIcon: suffixIcon,
              obscureText: obscureText,
              textColor: textColor,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                prefixIcon != null
                    ? PrefixIconWidget(
                        prefixIcon: prefixIcon,
                        status: status,
                        backgroundColor: backgroundColor,
                        accentColor: accentColor,
                      )
                    : const SizedBox(width: 20),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.only(right: 50),
                    child: TextFormField(
                      textAlign: textAlign,
                      controller: controller,
                      cursorWidth: 1.5,
                      cursorColor: textColor,
                      obscureText: obscureText ? !status.obscured : false,
                      keyboardType: inputType,
                      style: textStyle ??
                          GoogleFonts.montserrat(
                            fontStyle: fontStyle,
                            fontWeight: fontWeight,
                            wordSpacing: wordSpacing,
                            letterSpacing: letterSpacing,
                            textBaseline: textBaseline,
                            fontSize: fontSize,
                            color: textColor,
                          ),
                      autofocus: autofocus,
                      focusNode: focusNode,
                      enabled: enabled,
                      maxLines: maxLines,
                      minLines: minLines,
                      onChanged: onChanged,
                      onTap: () {
                        toggleFocus(status);
                        if (onTap != null) {
                          onTap!();
                        }
                      },
                      validator: (val) => inputType ==
                              TextInputType.emailAddress
                          ? val != null && EmailValidator.validate(val)
                              ? null
                              : "Please enter a valid email"
                          //  I know... very high level validation, its ok though for this
                          : (val != null && val.length > 8) || !obscureText
                              ? null
                              : "Password should be 8 character long",
                      textInputAction: TextInputAction.next,
                      autofillHints: [autofillHints ?? ""],
                      decoration: inputDecoration ??
                          InputDecoration(
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(.3),
                            ),
                            hintText: hintText,
                            border: InputBorder.none,
                          ),
                      // cursorColor: isFocus ? accentColor : backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrefixIconWidget extends StatelessWidget {
  const PrefixIconWidget({
    Key? key,
    required this.prefixIcon,
    required this.status,
    required this.backgroundColor,
    required this.accentColor,
  }) : super(key: key);

  final Icon? prefixIcon;
  final TextFieldNotifier status;
  final Color backgroundColor;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Icon(
        prefixIcon?.icon,
        color: status.isFocus ? backgroundColor : accentColor,
      ),
    );
  }
}

class SuffixIconWidget extends StatelessWidget {
  const SuffixIconWidget({
    Key? key,
    required this.suffixIcon,
    required this.obscureText,
    required this.textColor,
  }) : super(key: key);

  final Icon? suffixIcon;
  final bool obscureText;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      alignment: Alignment.centerRight,
      child: Icon(
        (suffixIcon == null && obscureText == false)
            ? Icons.close
            : Icons.visibility,
        color: textColor,
      ),
    );
  }
}

class BackgroundColorWidget extends StatelessWidget {
  const BackgroundColorWidget({
    Key? key,
    required this.duration,
    required this.status,
    required this.borderRadius,
    required this.accentColor,
    required this.backgroundColor,
  }) : super(key: key);

  final Duration duration;
  final TextFieldNotifier status;
  final BorderRadius? borderRadius;
  final Color? accentColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          borderRadius: status.isFocus
              ? borderRadius
              : const BorderRadius.all(Radius.circular(60)),
          color: status.isFocus ? accentColor : backgroundColor,
        ),
      ),
    );
  }
}
