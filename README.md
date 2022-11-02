# Focused Menu Custom

This is an easy to implement package for adding Focused Long Press Menu to Flutter Applications

## Current Features

* Add Focused Menu to Any Widget you Want
* Customizations to change The Focused Menu and Animations according to your Application Needs.

## Demo
![](https://firebasestorage.googleapis.com/v0/b/hosting-thorito.appspot.com/o/focus_menu_custom%2Ffocused_menu.gif?alt=media&token=f391fabf-290d-48a7-bfec-45af5f894c5e)

## Usage
To Use, simply Wrap the Widget you want to add Focused Menu to, with FocusedMenuHolder:
```
  Expanded(
    child: GridView(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

           // Wrap each item (Card) with Focused Menu Holder
          .map((e) => FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width*0.50,
            blurSize: 5.0,
            menuItemExtent: 45,
            menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
            duration: Duration(milliseconds: 100),
            animateMenuItems: true,
            blurBackgroundColor: Colors.black54,
            openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
            menuOffset: 10.0, // Offset value to show menuItem from the selected item
            bottomOffsetHeight: 80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
            menuItems: <FocusedMenuItem>[
              // Add Each FocusedMenuItem  for Menu Options
              FocusedMenuItem(title: Text("Open"),trailingIcon: Icon(Icons.open_in_new) ,onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenTwo()));
              }),
              FocusedMenuItem(title: Text("Share"),trailingIcon: Icon(Icons.share) ,onPressed: (){}),
              FocusedMenuItem(title: Text("Favorite"),trailingIcon: Icon(Icons.favorite_border) ,onPressed: (){}),
              FocusedMenuItem(title: Text("Delete",style: TextStyle(color: Colors.redAccent),),trailingIcon: Icon(Icons.delete,color: Colors.redAccent,) ,onPressed: (){}),
            ],
            onPressed: (){},
            child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/images/image_$e.jpg"),
                    ],
                  ),
                ),
          ))
          .toList(),
    ),
  ),
```

## Roadmap
Plans to add more customizations.

## License
[MIT](https://choosealicense.com/licenses/mit/)
