import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart';

final String TEMPLATE_DIR = "bin/template";
const String TEMPLATE_ASSET_FILE = "assets.dart.tpl";

const String PACKAGE_REPLACE_STRING = "@package@";
const String GETTER_REPLACE_STRING = "@getter@";
const String MAPENTRY_REPLACE_STRING = "@entry@";

const String ASSETNAME_REPLACE_STRING = "@asset@";
const String ASSETTYPE_REPLACE_STRING = "@type@";

const String DEFAULT_SOURCE_DIR = "web/assets";
const String DEFAULT_TARGET_DIR = "lib/src/bootstrap";
const String DEFAULT_TARGET_FILE = "assets.dart";

String assetSourceDir;
String assetTargetFile = DEFAULT_TARGET_FILE;

String packageName;


void main(List args) {

  _setupArgs(args);
  
  if(assetSourceDir == DEFAULT_SOURCE_DIR){
    print("Defaulting to $DEFAULT_SOURCE_DIR as source directory");
  }
  
  packageName = _getPackageNameFromPubspec();
  
  //add const to events
  _scanSource();
  
  
  print("Done. You can now access Assets like this: \n\tBitmapData bmd = Assets.assetname \n\tSound snd = Assets.assetname");
  
}

void _scanSource() {
  
  String imageGetter = '''
  static BitmapData get @asset@ {
    return _singleton.mgr.getBitmapData("@asset@");
  }
''';
  String soundGetter = '''
  static Sound get @asset@ {
    return _singleton.mgr.getSound("@asset@");
  }
''';
  
  String imageEntry = '_singleton.mgr.addBitmapData("@asset@", "assets/@asset@.@type@");\n\t\t';
  String soundEntry = '_singleton.mgr.addSound("@asset@", "assets/@asset@.@type@");\n\t\t';
  
  String generatedGetters = "";
  String generatedEntries = "";
  
  
  /* iterate over source path, grab *.as files */
    Directory sourceDir = new Directory(assetSourceDir);
    if (sourceDir.existsSync()) {
      sourceDir.listSync(recursive: false, followLinks: false).forEach((FileSystemEntity entity) {
        if (FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.FILE) {
          String ext = extension(entity.path).toLowerCase().substring(1);
          String baseName = basenameWithoutExtension(entity.path).toLowerCase();
          print(baseName);
          print(ext);
          if(ext == "jpg" || ext == "png"){
            generatedGetters += imageGetter.replaceAll(ASSETNAME_REPLACE_STRING, baseName);
            generatedEntries += imageEntry
                                      .replaceAll(ASSETNAME_REPLACE_STRING, baseName)
                                      .replaceAll(ASSETTYPE_REPLACE_STRING, ext);
          }
          if(ext == "mp3"){
            generatedGetters += imageGetter.replaceAll(ASSETNAME_REPLACE_STRING, baseName);
            generatedEntries += soundEntry
                                       .replaceAll(ASSETNAME_REPLACE_STRING, baseName)
                                       .replaceAll(ASSETTYPE_REPLACE_STRING, ext);
          }
        }
      });
      _createAssetFile(generatedGetters, generatedEntries);
    } else {
      print("The directory that was provided as source directory does not exist: $assetSourceDir");
      exit(1);
    }
}

/// Adds the newly created library as dependency to the project's root pubspec.yaml.
String _getPackageNameFromPubspec() {
  File pubspecRootFile = new File('pubspec.yaml').absolute;
  String pubspecRootFileContent = pubspecRootFile.readAsStringSync();
  return new RegExp("name\\s*:\\s*(\\w+)").firstMatch(pubspecRootFileContent).group(1);
}


/// Copies Screen template file from [TEMPLATE_DIR] to [DIR_SCREEN].
/// During the process, all occurences of [GETTER_REPLACE_STRING], [MAPENTRY_REPLACE_STRING] and [PACKAGE_REPLACE_STRING] are replaced.
void _createAssetFile(String getters, String mapEntries) {
  File file = new File("$TEMPLATE_DIR/$TEMPLATE_ASSET_FILE");
  String fileContent = file.readAsStringSync();
 
  fileContent = fileContent.replaceAll(new RegExp(GETTER_REPLACE_STRING), getters);
  fileContent = fileContent.replaceAll(new RegExp(MAPENTRY_REPLACE_STRING), mapEntries);
  fileContent = fileContent.replaceAll(new RegExp(PACKAGE_REPLACE_STRING), packageName);

  new File(join(DEFAULT_TARGET_DIR, "$assetTargetFile"))
      ..createSync(recursive: true)
      ..writeAsStringSync(fileContent);
}

/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List args) {
  ArgParser argParser = new ArgParser();
  
  argParser.addOption('sourcedir', abbr: 's', defaultsTo: DEFAULT_SOURCE_DIR, help: 'The source directory where to search the assets.', valueHelp: 'sourcedir', callback: (_sourceDir) {
    assetSourceDir = _sourceDir;
  });

  argParser.addFlag('help', negatable: false, help: 'Displays the help.', callback: (help) {
    if (help) {
      print(argParser.usage);
      exit(1);
    }
  });

  argParser.parse(args);
}