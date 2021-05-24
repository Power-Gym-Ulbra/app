import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/instructor_model.dart';
import 'package:scoped_model/scoped_model.dart';

class InstructorsTab extends StatefulWidget {
  @override
  _InstructorsTabState createState() => _InstructorsTabState();
}

class _InstructorsTabState extends State<InstructorsTab> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/svg/wave.svg',
            width: size.width,
          ),
          ScopedModel(
            model: InstructorModel(),
            child: ScopedModelDescendant<InstructorModel>(
              builder: (context, child, model) {
                if (model.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (model.instructors.isEmpty ||
                    model.instructors.length == 0) {
                  return Center(
                    child: Text(
                      'Nenhum instrutor cadastrado',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: model.instructors.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            model.instructors[index].name,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: white,
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: model.instructors[index].image == ""
                                ? NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                  )
                                : NetworkImage(
                                    "${model.instructors[index].image}",
                                  ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
