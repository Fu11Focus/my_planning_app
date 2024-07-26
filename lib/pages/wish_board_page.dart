import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ToDoDude/data/wish_board_items.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/del_container.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/neomorphism_button.dart';
import 'package:ToDoDude/widgets/right_menu.dart';
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
    imgSelectPath = '...';
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

  void _pickImage(Function setDialogState) async {
    result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File image = File(result!.files.single.path!);
      setDialogState(() => imgSelectPath = image.path);
    }
  }

  void delWish(index) {
    setState(() {
      dbItems.deleteItem(index);
      wishboard = dbItems.wishItems;
    });
  }

  void showDialogWishboard() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
                  actionsPadding: const EdgeInsets.all(0),
                  // insetPadding: const EdgeInsets.only(top: 10, bottom: 300, left: 20, right: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.all(0),
                  contentTextStyle: const TextStyle(color: txt),
                  backgroundColor: bg,
                  elevation: 0,
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, right: 20, bottom: 40, left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xff24262b),
                                bg,
                                Color(0xff36383d)
                              ], stops: [
                                0.4,
                                0.6,
                                1,
                              ], begin: Alignment.topLeft, end: Alignment.bottomRight, transform: GradientRotation(0.95)),
                              /*color: bg,*/ borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [BoxShadow(color: shadowDark, offset: Offset(5, 5), blurRadius: 5), BoxShadow(color: shadowLight, offset: Offset(-5, -5), blurRadius: 5)]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(imgSelectPath.length > 20 ? '${imgSelectPath.substring(0, 20)}...' : imgSelectPath),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: NeomorphismButton(
                                  action: () => _pickImage(setDialogState),
                                  height: 35,
                                  width: 35,
                                  child: const Icon(
                                    Icons.image_outlined,
                                    color: txt,
                                    size: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
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
                  ),
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 20),
                        child: NeomorphismButton(
                          action: saveVisible,
                          height: 40,
                          width: 80,
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              color: brand,
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: NeomorphismButton(
                        action: () {
                          Navigator.pop(context);
                          setState(() {
                            imgSelectPath = '...';
                            textVisible.text = '';
                          });
                        },
                        height: 40,
                        width: 80,
                        child: const Text('Cancel', style: TextStyle(color: txt, fontSize: 18)),
                      ),
                    )
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => showAdaptiveDialog(
                    context: context,
                    builder: (context) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.7,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: index,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.4,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: wishboard
                              .map((element) => Builder(
                                    builder: (BuildContext context) {
                                      return element['img'] != null
                                          ? Center(
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.file(
                                                    File(element['img']),
                                                  )),
                                            )
                                          : Center(
                                              child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(color: const Color(0xcc292d32), borderRadius: BorderRadius.circular(12)),
                                              child: Text(
                                                element['txt'],
                                                style: const TextStyle(color: txt, fontSize: 24, decoration: TextDecoration.none),
                                              ),
                                            ));
                                    },
                                  ))
                              .toList(),
                        ),
                        TextButton(
                            onPressed: Navigator.of(context).pop,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              decoration: const BoxDecoration(color: bg, borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: txt, fontSize: 18),
                              ),
                            )),
                      ],
                    ),
                  ),
                  onLongPress: () => showPopover(
                    direction: (index > 3) ? PopoverDirection.top : PopoverDirection.bottom,
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
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Center(
          child: NeomorphismButton(
            action: showDialogWishboard,
            height: 40,
            width: 40,
            child: const Icon(Icons.add, color: brand),
          ),
        ),
      ),
    );
  }
}
