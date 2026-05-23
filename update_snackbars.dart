import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  final regex = RegExp(r'Get\.snackbar\(\s*([\047"])(.*?)\1\s*,\s*([\047"])(.*?)\3');
  
  for (var file in files) {
    String content = file.readAsStringSync();
    if (content.contains('Get.snackbar')) {
      bool modified = false;
      content = content.replaceAllMapped(regex, (match) {
        modified = true;
        String q1 = match.group(1)!;
        String title = match.group(2)!;
        String q3 = match.group(3)!;
        String message = match.group(4)!;
        
        // Skip if already has .tr
        if (title.endsWith('.tr')) return match.group(0)!;
        
        return 'Get.snackbar($q1$title$q1.tr, $q3$message$q3.tr';
      });
      if (modified) {
        file.writeAsStringSync(content);
        print('Updated ${file.path}');
      }
    }
  }
}
