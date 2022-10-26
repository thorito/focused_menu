library focused_menu;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focused_menu_custom/modals.dart';

class FocusedMenuHolderController {
  late _FocusedMenuHolderState _widgetState;
  bool _isOpened = false;
  bool get isOpened => _isOpened;

  void _addState(_FocusedMenuHolderState widgetState) {
    this._widgetState = widgetState;
  }

  open() async {
    if (!_isOpened) {
      _isOpened = true;
      await _widgetState.openMenu(_widgetState.context);
    }
  }

  close() {
    if (_isOpened) {
      _isOpened = false;
      Navigator.pop(_widgetState.context);
    }
  }

  void dispose() {
    close();
  }
}

class FocusedMenuHolder extends StatefulWidget {
  final FocusedMenuHolderController? controller;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final bool openWithTap;
  final bool enableMenuScroll;
  final Widget child;

  const FocusedMenuHolder({
    required this.menuItems,
    required this.onPressed,
    required this.child,
    this.controller,
    this.duration,
    this.menuBoxDecoration,
    this.menuItemExtent,
    this.animateMenuItems,
    this.blurSize,
    this.blurBackgroundColor,
    this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.openWithTap = false,
    this.enableMenuScroll = true,
    Key? key,
  }) : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState(controller);
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  FocusedMenuHolderController? controller;
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  _FocusedMenuHolderState(FocusedMenuHolderController? focusController) {
    if (focusController != null) {
      controller = focusController;
      controller?._addState(this);
    }
  }

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future<void> openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: widget.duration ?? Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    controller: widget.controller,
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    enableMenuScroll: widget.enableMenuScroll,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class FocusedMenuDetails extends StatelessWidget {
  final FocusedMenuHolderController? controller;
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final bool? enableMenuScroll;

  const FocusedMenuDetails({
    required this.menuItems,
    required this.child,
    required this.childOffset,
    required this.childSize,
    required this.menuBoxDecoration,
    required this.itemExtent,
    required this.animateMenu,
    required this.blurSize,
    required this.blurBackgroundColor,
    required this.menuWidth,
    this.controller,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.enableMenuScroll = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize!.width);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;

    return WillPopScope(
      onWillPop: () async {
        controller?.close();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    _exit(context);
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                    child: Container(
                      color: (blurBackgroundColor ?? Colors.black)
                          .withOpacity(0.7),
                    ),
                  )),
              Positioned(
                top: topOffset,
                left: leftOffset,
                child: TweenAnimationBuilder(
                  duration: Duration(milliseconds: 200),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return Transform.scale(
                      scale: value,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  tween: Tween(begin: 0.0, end: 1.0),
                  child: Container(
                    width: maxMenuWidth,
                    height: menuHeight,
                    decoration: menuBoxDecoration ??
                        BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                              const BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  spreadRadius: 1)
                            ]),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      child: InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: enableMenuScroll),
                          child: ListView.builder(
                            itemCount: menuItems.length,
                            padding: EdgeInsets.zero,
                            physics: enableMenuScroll == true
                                ? BouncingScrollPhysics()
                                : NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              FocusedMenuItem item = menuItems[index];

                              Widget listItem = GestureDetector(
                                  onTap: () {
                                    if (item.onPressed == null) return;
                                    _exit(context);
                                    item.onPressed?.call();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(bottom: 1),
                                    color: item.backgroundColor ?? Colors.white,
                                    height: itemExtent ?? 50.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          if (item.leadingIcon != null) ...[
                                            item.leadingIcon!
                                          ],
                                          item.title,
                                          if (item.trailingIcon != null) ...[
                                            item.trailingIcon!
                                          ]
                                        ],
                                      ),
                                    ),
                                  ));
                              if (animateMenu) {
                                return TweenAnimationBuilder(
                                    builder: (context, dynamic value, child) {
                                      return Transform(
                                        transform:
                                            Matrix4.rotationX(1.5708 * value),
                                        alignment: Alignment.bottomCenter,
                                        child: child,
                                      );
                                    },
                                    tween: Tween(begin: 1.0, end: 0.0),
                                    duration:
                                        Duration(milliseconds: index * 200),
                                    child: listItem);
                              } else {
                                return listItem;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exit(BuildContext context) {
    controller != null ? controller?.dispose() : Navigator.pop(context);
  }
}
