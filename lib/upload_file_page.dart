import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadFilePage extends StatefulWidget {
  const UploadFilePage({Key? key}) : super(key: key);

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  final ImagePicker _picker = ImagePicker();

  XFile? _image;

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text("Gallery"),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 500,
      maxHeight: 500,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 500,
      maxHeight: 500,
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Upload page"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                _showPicker(context);
              },

              child: const Text("Select picture")),
          ElevatedButton(
              onPressed: () async {
                if (_image != null) {
                  var res = await uploadProfileImage(file: _image!);
                  print("IMAGE URL:$res");
                }
              },
              child: const Text("Upload picture"))
        ],
      ),
    );
  }

  String accessToken =
      "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiI5OTg5OTUyMTQ4NjIiLCJzY29wZSI6WyJvcGVuaWQiXSwiZXhwIjoxNjk4MTUzMTczLCJpYXQiOjE2NjY2MTcxNzMsImF1dGhvcml0aWVzIjpbIlJPTEVfQ0xJRU5UIl0sImp0aSI6IjNiSkxwUjJUbVJmNzlxS1VGT0llczBzN0RhOCIsImNsaWVudF9pZCI6IndlYl9hcHAifQ.Qa68IxeTi07ZX71E51eEPaJMgcOejax5QFd4THi0IQ1T6QXsTrrd38RiuLre5VnHQDJqm4xNon0fZ6MsGhxPzgjCQu5jB8t1Kg4WBa_4RoeJgV7k_OPjxN8yPBZuEQeiiY53kReAWpeEVVb7IbRgOmvLkUW0srr92Ogvs_i8EnymvGdVmA-9ZNf1EvSzuEQ2zAdDfYtErQuDqQfgQJQJ1Rf3VvKnpxFR2ypdc6DrH3pMrzPtkln03HatO8_gbPCNEfa3B4W4ldHie1IESsvAd1AH3CVy6jLoFDuHM5Ed-41ov6Jk5UJPe_2i71OnD-gIlOz6Droqm0NVSujtEoJrNw";

  Future<String> uploadProfileImage({required XFile file}) async {
    Dio dio = Dio();
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Authorization"] = "Bearer $accessToken";

    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final Response response = await dio.post(
      'https://colibri24.uz/services/mobile/api/client-image-upload',
      data: formData,
    );
    print('client-image-upload');
    print(response.statusCode);
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data['url'];
    } else {
      throw Exception();
    }
  }
}
