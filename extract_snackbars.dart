import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  final regex = RegExp(r'Get\.snackbar\(\s*([\047"])(.*?)\1\s*,\s*([\047"])(.*?)\3');
  
  int count = 0;
  for (var file in files) {
    final content = file.readAsStringSync();
    final matches = regex.allMatches(content);
    for (var match in matches) {
      print('Title: "${match.group(2)}", Message: "${match.group(4)}"');
      count++;
    }
  }
  print('Total snackbars found: $count');
}
