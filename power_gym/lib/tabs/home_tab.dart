import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeTabGym extends StatefulWidget {
  @override
  _HomeTabGymState createState() => _HomeTabGymState();
}

class _HomeTabGymState extends State<HomeTabGym> {
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
            model: StudentModel(),
            child: ScopedModelDescendant<StudentModel>(
              builder: (context, child, model) {
                if (model.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (model.students == null ||
                    model.students.length == 0) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: model.students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            model.students[index].name,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: white,
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: model.students[index].image == ""
                                ? NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                  )
                                : NetworkImage(
                                    "${model.students[index].image}",
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
