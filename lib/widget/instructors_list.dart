import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/instructor_data.dart';
import 'package:power_gym/model/instructor_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

class InstructorsList extends StatefulWidget {
  const InstructorsList({Key key}) : super(key: key);

  @override
  _InstructorsListState createState() => _InstructorsListState();
}

class _InstructorsListState extends State<InstructorsList> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  DateTime selectedDate;
  bool selected = true;
  String gender = 'Masculino';
  ImagePicker picker = ImagePicker();
  PickedFile pickedFile;
  File _image;

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

            return GestureDetector(
              onTap: () {
                nameController.text = instructor.name;
                gender = instructor.gender;
                if (instructor.gender == 'Masculino') {
                  selected = true;
                } else {
                  selected = false;
                }
                showDialog(
                  context: context,
                  builder: (_) {
                    return _editIntructor(instructor, size);
                  },
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: size.height * .3,
                      child: AlertDialog(
                        title: Text('Excluir aluno?'),
                        actions: [
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('Excluir'),
                            onPressed: () {
                              instructorModel.deleteInstructor(
                                  instructor.uid, _onSuccessDelete, _onFail);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: _listTile(instructor, index, context),
            );
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

  ScopedModelDescendant<InstructorModel> _editIntructor(
    InstructorData instructor,
    Size size,
  ) {
    return ScopedModelDescendant<InstructorModel>(
      builder: (context, child, instructorModel) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(12.0),
          content: Container(
            height: size.height * .4,
            width: 300,
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      'Editar Instrutor',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: gray,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      CircleAvatar(
                        child: Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                getImage(true, instructorModel);
                              },
                              icon: Icon(Icons.add_a_photo),
                              color: gray,
                            ),
                          ],
                        ),
                        maxRadius: size.height * .04,
                        backgroundImage: instructor.image != ''
                            ? NetworkImage(instructor.image)
                            : _image == null
                                ? NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                  )
                                : null,
                      ),
                    ],
                  ),
                  _pickDate(context, instructorModel, instructor),
                  TextFormField(
                    controller: nameController,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: gray,
                      ),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nome',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: yellow,
                      )),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: gray,
                        ),
                      ),
                      hintStyle: TextStyle(color: gray, fontSize: 12),
                      prefixIcon: Icon(
                        Icons.person,
                        color: gray,
                        size: 18,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome inválido ou vazio';
                      }
                      return null;
                    },
                  ),
                  _genderSelect(instructorModel),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCELAR'),
              onPressed: () {
                Navigator.pop(context);
                nameController.text = '';
                selectedDate = null;
                selected = true;
                gender = 'Masculino';
                _image = null;
              },
            ),
            TextButton(
              child: Text('SALVAR'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  InstructorData instructorData = InstructorData();
                  instructorData.name = nameController.text;
                  instructorData.gender = gender;
                  instructorData.image = instructor.image;
                  instructorData.birthday = selectedDate == null
                      ? instructor.birthday
                      : '${DateFormat('dd/MM/y').format(selectedDate)}';

                  if (_image != null) {
                    instructorModel.uploadFile(_image, instructorData.name);

                    Future.delayed(Duration(seconds: 10)).then(
                      (value) {
                        FirebaseStorage storageReference =
                            FirebaseStorage.instance;
                        Reference ref = storageReference
                            .ref()
                            .child('instructors')
                            .child(nameController.text)
                            .child('${_image.path}');

                        ref.getDownloadURL().then((value) {
                          print(value);
                          instructorData.image = value;
                        });
                      },
                    );

                    Future.delayed(Duration(seconds: 12)).then(
                      (value) {
                        instructorModel
                            .editInstructor(
                          instructorData,
                          instructor.uid,
                          _onSuccessEdit,
                          _onFail,
                        )
                            .whenComplete(() {
                          nameController.text = '';
                          selectedDate = null;
                          selected = true;
                          gender = 'Masculino';
                          _image = null;
                        });
                      },
                    );
                    Navigator.pop(context);
                  } else {
                    instructorModel
                        .editInstructor(
                      instructorData,
                      instructor.uid,
                      _onSuccessEdit,
                      _onFail,
                    )
                        .whenComplete(() {
                      nameController.text = '';
                      selectedDate = null;
                      selected = true;
                      gender = 'Masculino';
                      _image = null;
                    });
                    Navigator.pop(context);
                  }
                }
              },
            )
          ],
        );
      },
    );
  }

  Row _genderSelect(InstructorModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Row(
            children: [
              Checkbox(
                value: selected ? true : false,
                shape: CircleBorder(),
                onChanged: (value) {
                  model.newGender(true, 'Masculino');

                  gender = model.gender;
                  selected = model.selected;
                },
              ),
              Text(
                'Masculino',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: gray,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Checkbox(
                value: selected ? false : true,
                shape: CircleBorder(),
                onChanged: (value) {
                  model.newGender(false, 'Feminino');

                  gender = model.gender;
                  selected = model.selected;
                },
              ),
              Text(
                'Feminino',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: gray,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DateTime convertDateTime(String validade) {
    DateTime parsedDate = DateTime.parse('0001-11-30 00:00:00.000');

    List<String> validadeSplit = validade.split('/');

    if (validadeSplit.length > 1) {
      String day = validadeSplit[0].toString();
      String month = validadeSplit[1].toString();
      String year = validadeSplit[2].toString();

      parsedDate = DateTime.parse('$year-$month-$day 00:00:00.000');
    }

    return parsedDate;
  }

  Container _pickDate(
    BuildContext context,
    InstructorModel instructorModel,
    InstructorData instructor,
  ) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: gray,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              SizedBox(width: 3),
              Container(
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: gray,
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Container(
                child: Text(
                  'Data de nascimento',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: gray,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: convertDateTime(instructor.birthday),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                locale: Locale('pt', 'BR'),
              ).then((pickedDate) {
                if (pickedDate == null) {
                  return;
                }

                instructorModel.pickDate(pickedDate);
                selectedDate = instructorModel.date;
              });
            },
            child: Text(
              selectedDate == null
                  ? instructor.birthday
                  : '${DateFormat('dd/MM/y').format(selectedDate)}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: selectedDate == null ? facebook : yellow,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Algo deu errado!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSuccessDelete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Instrutor deletado com sucesso!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSuccessEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Instrutor editado com sucesso!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future getImage(bool gallery, InstructorModel model) async {
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      model.newImage(File(pickedFile.path));
      _image = model.image;
    }
  }
}
