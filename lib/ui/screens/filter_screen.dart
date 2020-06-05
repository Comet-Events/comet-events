import 'dart:ui';

import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class FilterScreen extends StatelessWidget{
  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appTheme.secondaryMono,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric( horizontal: 25 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                   Text(
                    'Filters',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 35,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1,3)
                        )
                      ]
                    )
                  ),
                  horizontalLine(context),
                  DistanceRadiusFilter(min: 0, max: 200),
                  horizontalLine(context),
                  TimeFilter(),
                  horizontalLine(context),
                  categoriesSection(),
                  horizontalLine(context),
                  tagsSection(),
                  horizontalLine(context),
                  filterChanges(),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget horizontalLine(BuildContext context){
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Container(
          color: CometThemeManager.lighten(_appTheme.secondaryMono),
          height: 1,
          width: MediaQuery.of(context).size.width
        ),
      ),
    );
  }

  Widget filterChanges(){
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(22.5)),
            highlightColor: Colors.white,
            splashColor: Colors.white,
            onTap: (){}, //reset changes and go back to homescreen
            child: Container(
              width: 100,
              height: 45,
              decoration: BoxDecoration(
                color: CometThemeManager.lighten(CometThemeManager.lighten(_appTheme.mainColor)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(90, 0, 0, 0),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(22.5)),
              ),
              child: Center(
                child: Text(
                  'Reset',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _appTheme.mainColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          CometSubmitButton(
            onTap: (){}, //apply changes and go back to homescreen
            text: 'Apply Filters'
          )
        ],
      ),
    );
  }

  Column tagsSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Tags',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 22,
                shadows: [Shadow( color: Colors.black26, offset: Offset(1,3))]
              )
            ),
            // SearchBar<TagChip>(
            //   onSearch: search,
            //   onItemFound: (TagChip tag, int index) {
            //     return ListTile(
            //       title: Text(tag.title),
            //     );
            //   },
            // ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ChipsFilter(title: "Tags"),
        )
      ],
    );
  }

  Column categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Categories',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 22,
            shadows: [Shadow( color: Colors.black26, offset: Offset(1,3))]
          )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ChipsFilter(title: "Categories", categories: true)
        )
      ],
    );
  }
}

  class DistanceRadiusFilter extends StatefulWidget {
    final double min, max;

    const DistanceRadiusFilter ({Key key, this.min, this.max}): super(key: key);

    @override
    _DistanceRadiusFilterState createState() => _DistanceRadiusFilterState();
  }
  class _DistanceRadiusFilterState extends State<DistanceRadiusFilter> {
    double radius = 0;
    bool showNewVal = false;
    
    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sectionHeader(),
          distanceSlider(),
          sliderLabels()
        ],
      );
    }

    Row sectionHeader(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Distance Radius',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              shadows: [
                Shadow( color: Colors.black26, offset: Offset(1,3))
              ]
            )
          ),
          Text(
            showNewVal ? '${radius.toStringAsFixed(1)} mi' : '',
            style: TextStyle(
              fontSize: 20,
              color: CometThemeManager.lighten(locator<CometThemeManager>().theme.mainColor)
            )
          ),
        ],
      );
    }
    
    Widget distanceSlider(){
      return Padding(
        padding: const EdgeInsets.only( top: 60 ),
        child: Slider.adaptive(
          value: radius,
          onChanged: (newRadius){
            setState(() => radius = newRadius );
          },
          onChangeEnd: (newRadius){
            setState(() => radius = newRadius );
            radius == widget.min ? showNewVal = false : showNewVal = true;
          },
          min: widget.min,
          max: widget.max,
          divisions: 100,
          label: "${radius.toStringAsFixed(1)} m",
          activeColor: locator<CometThemeManager>().theme.mainColor,
          inactiveColor: locator<CometThemeManager>().theme.mainMono,
        ),
      );
    }

    Widget sliderLabels(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${widget.min} miles',
              style: TextStyle(color: CometThemeManager.darken(locator<CometThemeManager>().theme.opposite))
            ),
            Text('${widget.max} miles',
              style: TextStyle(color: CometThemeManager.darken(locator<CometThemeManager>().theme.opposite))
            )
          ],
        ),
      );
    }
  }

  class TimeFilter extends StatefulWidget {
    @override
    _TimeFilterState createState() => _TimeFilterState();
  }
  class _TimeFilterState extends State<TimeFilter> {
    
    Color labelTextColor = CometThemeManager.lighten(locator<CometThemeManager>().theme.secondaryMono);
    
    DateTime now = DateTime.now();
    
    DateTime fromDate = DateTime.now();
    TimeOfDay fromTime = TimeOfDay.now();

    DateTime toDate = DateTime.now().add(Duration(days: 1));
    TimeOfDay toTime = TimeOfDay.now();

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Time',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              shadows: [Shadow( color: Colors.black26, offset: Offset(1,3))]
            )
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('From', style: TextStyle(color: labelTextColor)),
                fromDateTime(),
                SizedBox(height: 10),
                Text('To', style: TextStyle(color: labelTextColor)),
                toDateTime()
              ],
            ),
          ),
        ],
      );
    }

    String showWeekday( int weekday ){
      switch (weekday) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3: 
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        default:
          return 'Sunday';
      }
    }
    
    String showRelativeWeekday(int weekday){
      if( weekday == now.weekday )
        return 'Today';
      else if( weekday == now.weekday+1)
        return 'Tomorrow';
      else
        return showWeekday(weekday);
    }

    String getMonth(int month){
      switch (month) {
        case 1:
          return 'January';
        case 2:
          return 'February';
        case 3:
          return 'March';
        case 4:
          return 'April';
        case 5:
          return 'May';
        case 6:
          return 'June';
        case 7:
          return 'July';
        case 8:
          return 'August';
        case 9:
          return 'September';
        case 10:
          return 'October';
        case 11:
          return 'November';
        default:
          return 'December';
      }
    }

    Future selectFromDate() async {
      DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: fromDate == null ? now : fromDate,
        firstDate: now,
        lastDate: now.add(Duration(days: 2))
      );

      if( pickedDate != null )
        setState((){fromDate = pickedDate;});
    }

    Future selectToDate() async {
      DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: now,
        lastDate: now.add(Duration(days: 2))
      );

      if( pickedDate != null )
        setState((){toDate = pickedDate;});
    }

    Future selectFromTime() async{
      TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: fromTime
      );

      if( pickedTime != null)
        setState((){fromTime = pickedTime;});
    }

    Future selectToTime() async{
      TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: toTime
      );

      if( pickedTime != null )
        setState((){toTime = pickedTime;});
    }
  
    Row fromDateTime(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed:(){selectFromDate();},
            child: Text(
              '${showRelativeWeekday(fromDate.weekday)}, ${getMonth(fromDate.month)} ${fromDate.day}',
              style: TextStyle(fontSize: 18)
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            color: locator<CometThemeManager>().theme.mainMono,
          ),
          FlatButton(
            onPressed:(){selectFromTime();},
            child: Text(
              '${fromTime.format(context)}',
              style: TextStyle(fontSize: 18)
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            color: locator<CometThemeManager>().theme.mainMono,
          ),
        ],
      );
    }
  
    Row toDateTime(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed:(){selectToDate();},
            child: Text(
              '${showRelativeWeekday(toDate.weekday)}, ${getMonth(toDate.month)} ${toDate.day}',
              style: TextStyle(fontSize: 18)
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            color: locator<CometThemeManager>().theme.mainMono,
          ),
          FlatButton(
            onPressed:(){selectToTime();},
            child: Text(
              '${toTime.format(context)}',
              style: TextStyle(fontSize: 18)
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            color: locator<CometThemeManager>().theme.mainMono,
          ),
        ],
      );
    }
  }

  class ChipsFilter extends StatefulWidget {
    final String title;
    final bool categories;

    ChipsFilter({Key key,
     this.title,
     this.categories = false
    }) : super(key: key);

    @override
    _ChipsFilterState createState() => _ChipsFilterState();
  }
  class _ChipsFilterState extends State<ChipsFilter> {
    bool showSuggestions = true;
    double fontSize = 18;
    List displayItems = [];
    List allItems = [
      'Education',
      'Active',
      'Social',
      'Religious',
      'Food',
      'Protest'
    ];
    //here, displayItems is the list of all tags that are being shown on the screen
    //allItems is intended to be the list of all existing tags or categories in the db
    //there should be no tags showing until the user adds them

    final CometThemeData _appTheme = locator<CometThemeManager>().theme;

    @override
    void initState(){
      super.initState();
      if( widget.categories )
        displayItems = allItems.toList();
    }

    @override
    Widget build(BuildContext context) {
      return Center(
         child: _tagsList
      );
    }

    Widget get _tagsList{
      return Tags(
        key: Key("2"),
        symmetry: false,
        columns: 0,
        textField: widget.categories ? null :
          TagsTextField(
            duplicates: false,
            autofocus: false,
            lowerCase: true,
            textStyle: TextStyle(fontSize: 18),
            suggestionTextColor: _appTheme.mainColor,
            //this should eventually suggest the contents of allItems
            suggestions: showSuggestions ? [
              "brunch",
              "casual",
              "workshop",
              "dance",
              "afro jazz"
            ] : null,
          //when they search a tag, add it to the displaying tags,
          //if it doesn't already exist, also add it to the db
          onSubmitted: (String str){
            setState((){
              displayItems.add(str);
              allItems.contains(str) ? null : allItems.add(str);
            });
          }
        ),
        itemCount: displayItems.length,
        itemBuilder: (index){
          final item = displayItems[index];

          return GestureDetector(
            child: ItemTags(
              key: Key(index.toString()),
              index: index,
              title: item,
              pressEnabled: false,
              //TO DO: change this so that the active color is white if
              //a pre-existing tag is selected and purple if the user creates a new tag
              activeColor: widget.categories ? 
                _appTheme.mainColor.withOpacity(0.25) :             
                _appTheme.themeData.brightness == Brightness.dark ? Colors.white.withOpacity(0.25) : Colors.black.withOpacity(0.25),
              border: Border.all(
                width: 1,
                color: widget.categories ? 
                  _appTheme.mainColor :
                  _appTheme.themeData.brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              combine: ItemTagsCombine.onlyText,
              removeButton: widget.categories ? null : 
                ItemTagsRemoveButton(
                  color: _appTheme.secondaryMono,
                  backgroundColor: _appTheme.themeData.brightness == Brightness.dark ?
                    Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8),
                  onRemoved: (){
                    setState((){
                      displayItems.removeAt(index);
                    });
                  }
                ),
              textStyle: TextStyle(
                color: widget.categories ?
                  _appTheme.mainColor :
                  _appTheme.opposite,
                fontSize: 18
              ),
            ),
          );
        },
      );
    }
  
  }
