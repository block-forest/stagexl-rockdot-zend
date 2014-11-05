import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart';

const String DEFAULT_DART_PACKAGE = "autogen";
const String DEFAULT_AS_PACKAGE = "";
const String DEFAULT_BUILD_DIR = "build";
const String DEFAULT_TARGET_DIR = "deploy";

String source_basedir = Platform.script.toFilePath();
String target_basedir;

void main(List args) {

  _setupArgs(args);

  
  //copy zend files
  Directory binDir = new Directory(join(source_basedir, "source", "server"));
  if (binDir.existsSync()) {
    binDir.listSync(recursive: true, followLinks: false).forEach((FileSystemEntity entity) {
      if (FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.FILE) {
        _convert(entity.path);
      }
    });
  } else {
    print("Tried to find Server sources here, but didn't succeed: ${binDir.path}");
    exit(1);
  }
  
  //copy properties files


  //copy files from $DEFAULT_BUILD_DIR

  Directory buildDir = new Directory(DEFAULT_BUILD_DIR);
  if (buildDir.existsSync()) {

  } else {
    print("Did you build your project?");
    exit(1);
  }
}


/// Takes a File path, e.g. bin/examples/wonderfl/xmas/StarUnit.as, and writes it to
/// the output directory provided, e.g. lib/autogen/src/wonderfl/xmas/star_unit.dart.
/// During the process, excessive RegExp magic is applied.
void _convert(String filePath) {

  //e.g. bin/examples/wonderfl/xmas/StarUnit.as
  //print("asFilePath: $asFilePath");

  File file = new File(filePath);

  String fileContents = file.readAsStringSync();
  String dartFileContents = _applyMagic(fileContents);

  //Write new file
  new File(join(target_basedir, filePath)).absolute
      ..createSync(recursive: true)
      ..writeAsStringSync(dartFileContents);

}

/// Applies magic to an ActionScript file String, converting it to almost error free Dart.
/// Note that the focus lies on the conversion of the Syntax tree and the most obvious
/// differences in the respective API's.
String _applyMagic(String f) {

  //read all properties files

  
  // replace package declaration
  //f = f.replaceAllMapped(new RegExp("(\\s*)package\\s+[a-z0-9.]+\\s*\\{"), (Match m) => "${m[1]} part of $dart_package_name;");
  // remove closing bracket at end of class
  //f = f.replaceAll(new RegExp("\\}\\s*\$"), "");

  return f;
}

/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List args) {
  ArgParser argParser = new ArgParser();

  argParser.addOption('target', abbr: 't', defaultsTo: DEFAULT_TARGET_DIR, help: 'The path (relative!) the generated Dart package will be written to. Usually, your Dart project\'s \'lib\' directory.', valueHelp: 'target', callback: (_target_basedir) {
    target_basedir = _target_basedir;
  });


  argParser.addFlag('help', negatable: false, help: 'Displays the help.', callback: (help) {
    if (help) {
      print(argParser.usage);
      exit(1);
    }
  });

  argParser.parse(args);
}
