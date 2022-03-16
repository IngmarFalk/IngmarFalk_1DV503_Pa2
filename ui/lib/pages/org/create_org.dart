import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class CreateOrgPage extends ConsumerWidget {
  static const String id = "/create_org";

  const CreateOrgPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kcIceBlue.withOpacity(.17),
        body: Center(
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "C R E A T E   O R G A N I Z A T I O N",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 550,
                child: CustomForm(
                  type: FormType.createProject,
                  fields: {
                    "org_name": CustomTextField(
                      hintText: "organization name",
                      prefixIcon: const Icon(Icons.house),
                    ),
                    "field": CustomTextField(
                      hintText: "field",
                      prefixIcon: const Icon(Icons.date_range),
                    ),
                    "description": CustomTextField(
                      height: 200,
                      hintText: "description",
                      prefixIcon: const Icon(Icons.padding_outlined),
                      maxLines: 7,
                    ),
                  },
                  urls: const ['http://127.0.0.1:8000/create_org/'],
                  buttonTexts: const ["C R E A T E"],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
