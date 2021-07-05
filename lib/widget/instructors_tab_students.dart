import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/instructor_data.dart';
import 'package:power_gym/model/instructor_model.dart';
import 'package:scoped_model/scoped_model.dart';

class InstructorsListStudent extends StatefulWidget {
  const InstructorsListStudent({Key key}) : super(key: key);

  @override
  _InstructorsListState createState() => _InstructorsListState();
}

class _InstructorsListState extends State<InstructorsListStudent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScopedModelDescendant<InstructorModel>(
      builder: (context, child, instructorModel) {
        return Center(
          child: instructorModel.isLoading
              ? CircularProgressIndicator()
              : _buildList(instructorModel, size),
        );
      },
    );
  }

  Container _buildList(InstructorModel instructorModel, Size size) {
    final instructors = instructorModel.instructors;
    if (instructors.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.network(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/out.svg?alt=media&token=83d7ecf2-32c4-49c8-a8ad-24a4798dc110'),
            SizedBox(height: 10),
            Text(
              'Nenhum instrutor(a) cadastrado(a)',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: instructors.length,
          itemBuilder: (context, index) {
            final instructor = instructors[index];

            return _listTile(instructor, index, context);
          },
        ),
      );
    }
  }

  ListTile _listTile(
      InstructorData instructor, int index, BuildContext context) {
    int nowYear = int.parse(DateTime.now().toString().substring(0, 4));
    int yearStudent =
        int.parse(instructor.birthday.substring(6, 10).toString());

    String yearsOld = (nowYear - yearStudent).toString();

    return ListTile(
      title: Text(
        '${instructor.name}, $yearsOld',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: white,
            fontSize: 14,
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: instructor.image == ""
            ? NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
              )
            : NetworkImage(
                "${instructor.image}",
              ),
      ),
      trailing: Icon(
        instructor.gender == 'Masculino' ? Icons.male : Icons.female,
        color: white,
      ),
    );
  }
}
