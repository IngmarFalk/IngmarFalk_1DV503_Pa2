part of widgets;

class SideBar extends ConsumerWidget {
  final double height;
  final double width;
  final Color color;
  final SideBarChoiceNotifier choice;
  final TextEditingController teController;
  SideBar({
    required this.teController,
    required this.choice,
    this.color = kcIceBlue,
    this.height = double.infinity,
    this.width = 200,
    Key? key,
  }) : super(key: key);

  // final Map<String, Function> sideBarItems = {
  //   "O R G A N I Z A T I O N S":
  //(SideBarChoiceNotifier choice) =>
  //       choice.choice = SideBarChoice.orgs,
  //   "P R O J E C T S": (SideBarChoiceNotifier choice) =>
  //       choice.choice = SideBarChoice.projects,
  //   "T A S K S": () {},
  //   "M E S S A G E S": () {},
  // };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = InheritedLoginProvider.of(context);

    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "F I N D E R",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: kcDarkBlue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SideBarItem(
                  text: "O R G A N I Z A T I O N S",
                  onTap: () {
                    print(choice.choice);
                    choice.choice = SideBarChoice.orgs;
                    teController.text = "a";
                    teController.text = "";
                  }),
              SideBarItem(
                text: "P R O J E C T S",
                onTap: () => choice.choice = SideBarChoice.projects,
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
          Column(children: <Widget>[
            SideBarItem(
              text: state.isLoggedIn ? "S I G N   O U T" : "S I G N   I N",
              onTap: () {
                if (state.isLoggedIn) {
                  state.setIsLoggedIn(false);
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamed(context, LoginScreen.id);
                }
              },
            ),
          ]),
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
    this.duration = const Duration(milliseconds: 0),
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
          borderRadius: BorderRadius.circular(3) // borderRadius,
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
  Color _backgroundColor = kcIceBlue;
  Color _textColor = kcDarkBlue.withOpacity(.9);
  bool get hovering => _hovering;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  set hovering(bool val) {
    _hovering = val;
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
    backgroundColor = val ? kcLightBlue.withOpacity(.3) : kcIceBlue;
    textColor = val ? kcDarkBlue : kcDarkBlue.withOpacity(1);
    notifyListeners();
  }
}
