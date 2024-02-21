import 'package:flutter/material.dart';
import 'package:kakao_map_plugin_example/src/models/location.dart';

class LocationDropDown extends StatefulWidget {
  const LocationDropDown({super.key, required this.locationList});

  final List<LocationDto> locationList;
  @override
  State<LocationDropDown> createState() => _LocationDropDownState();
}

class _LocationDropDownState extends State<LocationDropDown> {
  LocationDto? _selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  void test() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _selectedValue,
      items: widget.locationList.map(
        (value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value.location),
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(
          () {
            _selectedValue = value!;
          },
        );
      },
      icon: const Padding(
          //Icon at tail, arrow bottom is default icon
          padding: EdgeInsets.only(left: 20),
          child: Icon(Icons.arrow_circle_down_sharp)),
      iconEnabledColor: Colors.grey, //Icon color
      style: const TextStyle(
          //te
          color: Colors.black, //Font color
          fontSize: 20 //font size on dropdown button
          ),

      dropdownColor: Colors.white, //dropdown background color
      underline: Container(), //remove underline
      isExpanded: true, //make true to make width 100%
    );
  }
}
