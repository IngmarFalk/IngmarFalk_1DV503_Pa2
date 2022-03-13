import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/pages/home/center_view/filter_button_notifier.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class FilterButton extends ConsumerWidget {
  final ChangeNotifierProvider<FilterButtonNotifier> filteringNotifier;
  const FilterButton({
    required this.filteringNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtering = ref.watch(filteringNotifier);
    return CustomTextButton(
      margin: const EdgeInsets.all(0),
      height: 90,
      width: 60,
      onTap: () {
        filtering.openFilter(!filtering.filtering);
      },
      text: "",
      icon: const Icon(
        Icons.menu_sharp,
        color: kcDarkBlue,
      ),
    );
  }
}

class FilterOptions extends ConsumerWidget {
  final ChangeNotifierProvider<FilterButtonNotifier> filteringNotifier;
  final List<Map<String, dynamic>> options;
  const FilterOptions({
    required this.filteringNotifier,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtering = ref.watch(filteringNotifier);
    return SizedBox(
      height: options.length * 34,
      width: 400,
      child: ListView.builder(
        itemCount: options.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int idx) => Container(
          height: 30,
          width: 400,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: kcMedBlue, width: .5),
              right: BorderSide(color: kcMedBlue, width: .5),
              left: BorderSide(color: kcMedBlue, width: .5),
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              SizedBox(
                height: 29.5,
                width: 200,
                child: Center(
                  child: Text(
                    options[idx]["name"],
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kcDarkBlue,
                    ),
                  ),
                ),
              ),
              FilterDropDownItem(
                options: options,
                filtering: filtering,
                idx: idx,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterDropDownItem extends StatelessWidget {
  final int idx;
  const FilterDropDownItem({
    Key? key,
    required this.idx,
    required this.options,
    required this.filtering,
  }) : super(key: key);

  final List<Map<String, dynamic>> options;
  final FilterButtonNotifier filtering;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 140,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          icon: const Icon(Icons.arrow_drop_down),
          borderRadius: BorderRadius.circular(0),
          focusColor: Colors.white,
          hint: Text(options[idx]["name"]),
          // value: filtering.filterVals[options[idx]["name"]],
          isExpanded: true,
          alignment: Alignment.center,
          elevation: 16,
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: kcDarkBlue,
          ),
          onChanged: (String? newValue) {
            filtering.addFilter([options[idx]["name"], newValue.toString()]);
          },
          items: options[idx]["options"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
