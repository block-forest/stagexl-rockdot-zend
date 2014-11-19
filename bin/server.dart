import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:stagexl_rockdot_zend/stagexl_rockdot_zend.dart';

const String DIR_SOURCE_ZEND = "packages/stagexl_rockdot_zend/source";
const String DIR_SOURCE_CONFIG = "bin/config";
const String DIR_TARGET = "deploy";
const String DIR_BUILD_DEFAULT = "build";

String dir_target;
Properties properties;

void main(List args) {

  _setupArgs(args);

  //check for existence of local config directory
  Directory configDir = new Directory(DIR_SOURCE_CONFIG);
  if (!configDir.existsSync()) {
    print("You need to copy the Zend configs first (and change them towards your needs, of course).\npub run stagexl_rockdot_zend:config");
    exit(1);
  }

  //check for existence of local config directory
  Directory buildDir = new Directory(DIR_BUILD_DEFAULT);
  if (!buildDir.existsSync()) {
    print("Did you build your project?");
    exit(1);
  }

  //assemble properties files
  properties = new Properties();
  KeyValuePropertiesParser parser = new KeyValuePropertiesParser();
  parser.parseProperties(new File("web/v1/project.properties").readAsStringSync(), properties);
  parser.parseProperties(new File("$DIR_SOURCE_CONFIG/local/private.properties").readAsStringSync(), properties);
  parser.parseProperties(new File("$DIR_SOURCE_CONFIG/local/public.properties").readAsStringSync(), properties);

  //copy zend files
  Directory sourceDir = new Directory(DIR_SOURCE_ZEND);
  if (sourceDir.existsSync()) {
    sourceDir.listSync(recursive: true, followLinks: false).forEach((FileSystemEntity entity) {
      _convert(entity);
    });
  } else {
    print("Tried to find Server sources here, but didn't succeed: ${sourceDir.path}");
    exit(1);
  }



  new File("$DIR_BUILD_DEFAULT/web/project.dart.js").copySync("$DIR_TARGET/server/public");
  new Directory("$DIR_TARGET/server/public/packages/browser").createSync(recursive: true);
  new File("$DIR_BUILD_DEFAULT/web/packages/browser/dart.js").copySync("$DIR_TARGET/server/public/packages/browser");
  new File("$DIR_BUILD_DEFAULT/web/packages/browser/interop.js").copySync("$DIR_TARGET/server/public/packages/browser");
}


void _convert(FileSystemEntity entity) {

  File file = new File(entity.path);
  String newFilePath = entity.path.replaceFirst(new RegExp(DIR_SOURCE_ZEND + "/"), "");
  newFilePath = join(dir_target, newFilePath);


  if (FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.DIRECTORY) {
    if (newFilePath.contains(new RegExp(r'packages'))) {
      return;
    }
    new Directory(newFilePath).createSync(recursive: true);
  } else if (FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.FILE) {

    String fileExt = extension(entity.path);

    if (fileExt.contains(new RegExp(r'jpg|png|gif'))) {
      file.copySync(newFilePath);
    } else {
      String fileContents = file.readAsStringSync();
      String dartFileContents = _applyMagic(fileContents);

      //Write new file
      new File(newFilePath).absolute
          ..createSync(recursive: true)
          ..writeAsStringSync(dartFileContents);
    }
  }

}

String _applyMagic(String f) {

  properties.propertyNames.forEach((prop) {
    f = f.replaceAll(new RegExp("@$prop@"), properties.getProperty(prop));
  });

  return f;
}

/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List args) {
  ArgParser argParser = new ArgParser();

  argParser.addOption('target', abbr: 't', defaultsTo: DIR_TARGET, help: 'The path (relative!) your generated code will be written to.', valueHelp: 'target', callback: (_target_basedir) {
    dir_target = _target_basedir;
  });


  argParser.addFlag('help', negatable: false, help: 'Displays the help.', callback: (help) {
    if (help) {
      print(argParser.usage);
      exit(1);
    }
  });

  argParser.parse(args);
}
