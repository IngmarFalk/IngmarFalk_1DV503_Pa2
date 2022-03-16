import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/main.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class CreateProjectPage extends ConsumerWidget {
  static const String id = "/create_project";

  String? email;

  CreateProjectPage({
    this.email,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    email ??= "";
    return SafeArea(
      child: Scaffold(
        backgroundColor: kcIceBlue.withOpacity(.17),
        body: Center(
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "C R E A T E   P R O J E C T ",
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
                    "name": CustomTextField(
                      hintText: "project name",
                      prefixIcon: const Icon(Icons.house),
                    ),
                    "due_date": CustomTextField(
                      hintText: "due data: YYYY-MM-DD",
                      prefixIcon: const Icon(Icons.date_range),
                    ),
                    "organization": CustomTextField(
                      hintText: "organization",
                      prefixIcon: const Icon(Icons.calendar_month_rounded),
                    ),
                    "description": CustomTextField(
                      height: 200,
                      hintText: "description",
                      prefixIcon: const Icon(Icons.padding_outlined),
                      maxLines: 7,
                    ),
                  },
                  urls: ['http://127.0.0.1:8000/create_project/?email=$email'],
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
