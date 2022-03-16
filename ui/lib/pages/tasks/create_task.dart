import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class CreateTaskPage extends ConsumerWidget {
  static const String id = "/create_task";

  const CreateTaskPage({Key? key}) : super(key: key);

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
                  "C R E A T E   T A S K",
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
                    "title": CustomTextField(
                      hintText: "title",
                    ),
                    "description": CustomTextField(
                      height: 200,
                      hintText: "description",
                      maxLines: 7,
                    ),
                    "developer": CustomTextField(
                      hintText: "developer",
                    ),
                    "project_id": CustomTextField(
                      hintText: "project id",
                    ),
                    "organization": CustomTextField(
                      hintText: "organization",
                    ),
                    "due_date": CustomTextField(
                      hintText: "due date",
                    ),
                  },
                  urls: const ['http://127.0.0.1:8000/create_task/'],
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
