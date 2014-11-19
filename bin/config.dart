import 'dart:io';
import 'package:args/args.dart';

const String DIR_SOURCE_CONFIG = "packages/stagexl_rockdot_zend/config";
const String DIR_TARGET_CONFIG = "bin/config";

String dir_target;

void main(List args) {

  _setupArgs(args);

  Directory buildDir = new Directory(dir_target);
  if (!buildDir.existsSync()) {
    buildDir.createSync();
    new Directory("$dir_target/local").createSync();
    new Directory("$dir_target/live").createSync();
    new File("$DIR_SOURCE_CONFIG/local/private.properties").copySync("$dir_target/local/private.properties");
    new File("$DIR_SOURCE_CONFIG/local/public.properties").copySync("$dir_target/local/public.properties");
    new File("$DIR_SOURCE_CONFIG/live/private.properties").copySync("$dir_target/live/private.properties");
    new File("$DIR_SOURCE_CONFIG/live/public.properties").copySync("$dir_target/live/public.properties");
  } else {
    print("The directory $dir_target exists. I've decided not to overwrite it. If you want a clean config, delete it manually and run this script again.");
    exit(1);
  }
}



/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List args) {
  ArgParser argParser = new ArgParser();

  argParser.addOption('target', abbr: 't', defaultsTo: DIR_TARGET_CONFIG, help: 'The path (relative!) the Zend config will be written to.', valueHelp: 'target', callback: (_target_basedir) {
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
