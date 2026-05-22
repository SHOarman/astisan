import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    var content = file.readAsStringSync();
    
    if (content.contains('headers:') && !content.contains("Accept-Language")) {
      var newContent = content.replaceAll(
        'headers: {',
        "headers: { 'Accept-Language': ApiServices.currentLanguage, "
      );
      
      newContent = newContent.replaceAll(
        'headers: <String, String>{',
        "headers: <String, String>{ 'Accept-Language': ApiServices.currentLanguage, "
      );

      if (newContent != content) {
        if (newContent.contains('ApiServices')) {
          file.writeAsStringSync(newContent);
          print('Updated: ${file.path}');
        }
      }
    }
  }
}
