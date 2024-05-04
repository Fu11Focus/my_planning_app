import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tests/data/wish_board_items.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/del_container.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popover/popover.dart';

class WishBoardPage extends StatefulWidget {
  const WishBoardPage({Key? key}) : super(key: key);

  @override
  State<WishBoardPage> createState() => _WishBoardPageState();
}

class _WishBoardPageState extends State<WishBoardPage> {
  FilePickerResult? result;
  late TextEditingController textVisible;
  String imgSelectPath = '...';
  late List<dynamic> wishboard;
  File? _imageFile;
  final _myBox = Hive.box('WishBox');
  WishItems dbItems = WishItems();

  @override
  void initState() {
    super.initState();
    if (_myBox.get('WISHITEMS') == null) {
      dbItems.createInitialData();
    } else {
      dbItems.loadData();
    }

    _imageFile = null;
    wishboard = dbItems.wishItems;

    textVisible = TextEditingController(text: '');
  }

  void saveVisible() async {
    if (result != null) {
      File image = File(result!.files.single.path!);

      Directory appDir = await getApplicationDocumentsDirectory();
      String newPath = '${appDir.path}/images';

      if (!(await Directory(newPath).exists())) {
        await Directory(newPath).create(recursive: true);
      }

      String newFilePath = '$newPath/${image.path.split('/').last}';

      await image.copy(newFilePath);

      setState(() {
        _imageFile = File(newFilePath);
        dbItems.addWishItems({'img': _imageFile!.path, 'txt': textVisible.text});
        wishboard = dbItems.wishItems;
      });
      result = null;
      textVisible.text = '';
      imgSelectPath = '...';
      Navigator.pop(context);
    } else if (textVisible.text != '') {
      setState(() {
        dbItems.addWishItems({'img': null, 'txt': textVisible.text});
        wishboard = dbItems.wishItems;
      });
      result = null;
      textVisible.text = '';
      imgSelectPath = '...';
      Navigator.pop(context);
    }
  }

  void _pickImage() async {
    result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File image = File(result!.files.single.path!);
      setState(() => imgSelectPath = image.path);
    }
  }

  void delWish(index) {
    setState(() {
      dbItems.deleteItem(index);
      wishboard = dbItems.wishItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    void showDialogWishboard() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                    actionsPadding: const EdgeInsets.all(0),
                    insetPadding: const EdgeInsets.only(top: 10, bottom: 300, left: 20, right: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.all(0),
                    contentTextStyle: const TextStyle(color: txt),
                    backgroundColor: bg,
                    elevation: 0,
                    content: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, right: 20, bottom: 40, left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(color: bg, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [BoxShadow(color: shadowDark, offset: Offset(5, 5), blurRadius: 5), BoxShadow(color: shadowLight, offset: Offset(-5, -5), blurRadius: 5)]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(imgSelectPath.length > 20 ? '${imgSelectPath.substring(0, 20)}...' : imgSelectPath),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                color: shadowDark,
                                onPressed: _pickImage,
                                icon: const Icon(
                                  Icons.image,
                                  color: txt,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(color: bg, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), boxShadow: [BoxShadow(color: shadowLight, offset: Offset(0, -5), blurRadius: 5)]),
                          child: TextField(
                            controller: textVisible,
                            style: const TextStyle(color: txt),
                            maxLines: 10,
                            decoration: const InputDecoration(hintText: 'Write your goals, dreams, visible :)'),
                          ),
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: saveVisible,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: txt),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            imgSelectPath = '...';
                            textVisible.text = '';
                          });
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: txt),
                        ),
                      ),
                    ],
                  )));
    }

    return Scaffold(
      endDrawer: const RightMenu(thisPage: 'Whish Board'),
      appBar: const MyAppBar(
        icon: Icons.sunny_snowing,
        text: 'Wish Board',
      ),
      body: wishboard.isEmpty
          ? const Center(
              child: Text(
                'You can add to board anyhthink with photo or text. Save on board your dream!',
                style: TextStyle(color: hintTxt, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          : MasonryGridView.builder(
              itemCount: wishboard.length,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) => Builder(builder: (context) {
                return GestureDetector(
                  onLongPress: () => showPopover(
                    backgroundColor: bg,
                    width: 150,
                    height: 50,
                    context: context,
                    bodyBuilder: (context) => DelContainer(action: () => {delWish(index), Navigator.pop(context)}),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: bg, borderRadius: BorderRadius.all(Radius.circular(12)), boxShadow: [BoxShadow(color: shadowLight, offset: Offset(-5, -5), blurRadius: 5), BoxShadow(color: shadowDark, offset: Offset(5, 5), blurRadius: 5)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(12), child: wishboard[index]['img'] != null ? Image.file(File(wishboard[index]['img']!)) : null),
                        Container(
                          margin: wishboard[index]['txt'] != '' ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5) : const EdgeInsets.all(0),
                          child: wishboard[index]['txt'] != '' ? Text(wishboard[index]['txt']!, style: const TextStyle(color: txt)) : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showDialogWishboard,
        backgroundColor: brand,
        child: const Icon(
          Icons.add,
          color: shadowDark,
        ),
      ),
    );
  }
}
