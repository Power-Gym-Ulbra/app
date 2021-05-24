import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:scoped_model/scoped_model.dart';

class StudentsTabGym extends StatefulWidget {
  @override
  _StudenstTabGymState createState() => _StudenstTabGymState();
}

class _StudenstTabGymState extends State<StudentsTabGym> {
  StudentModel studentModel = StudentModel();

  @override
  void initState() {
    studentModel.loadStudents();
    super.initState();
  }

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
            child: Expanded(
              child: ScopedModelDescendant<StudentModel>(
                  rebuildOnChange: true,
                  builder: (context, child, model) {
                    if (model.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (model.students.isEmpty ||
                        model.students.length == 0) {
                      return Center(
                        child: Text(
                          'Nenhum aluno cadastrado',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            color: white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      );
                    }
                    final listStudents = model.students;

                    return ListView.builder(
                      itemCount: listStudents.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/perfilStudent',
                              arguments: {
                                'student': listStudents[index],
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                              listStudents[index].name,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: white,
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: listStudents[index].image == ""
                                  ? NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                    )
                                  : NetworkImage(
                                      "${listStudents[index].image}",
                                    ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: white,
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
