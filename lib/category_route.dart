// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory; //added
  Category _currentCategory; //added
  final _categories = <Category>[];
  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];
  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _categoryNames.length; i++) {
      var category = Category(
        name: _categoryNames[i],
        color: _baseColors[i],
        iconLocation: Icons.cake,
        units: _retrieveUnitList(_categoryNames[i]),
      );
      if (i == 0) {
        _defaultCategory = category; //el 1er elemento(category) del array será el default. Segun el i  de _categoryNames este será Length.
      }
      _categories.add(category); //se agregó var category de tipo Category para almacenar cada category y poder setear un defaultCategory
    }
  }

  /// Function to call when a [Category] is tapped. el category actual sera el presionado
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  /// Makes the correct number of rows for the list view.
  ///
  /// For portrait, we use a [ListView].
  Widget _buildCategoryWidgets() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        //added. Hemos creado un widget aux CategoryTile para agregar un onTap a las propiedades de un objeto, en este caso un Category
        return CategoryTile(
          category: _categories[index],
          onTap: _onCategoryTap, //cada category tendra su onTap
        );
      },
      itemCount: _categories.length,
    );
  }

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _buildCategoryWidgets(),
    );

    //El Backdrop permite setear en el frontPanel el UnitConverter widget y como backPanel el listView original (se mostrará al hacer tap en el navigtation drawer icon)
    return Backdrop(
      currentCategory:
          _currentCategory == null ? _defaultCategory : _currentCategory, //si array es nulo poner currentCategory = defaultCategory sino poner el actual
      frontPanel: _currentCategory == null
          ? UnitConverter(category: _defaultCategory) //instanciamos el widget UnitConverter con defaultCategory.* Esto lo haciamos en el Converter Route del navigateToConverter!!
          : UnitConverter(category: _currentCategory),//instanciamos el widget UnitConverter con currentCategory * Esto lo haciamos en el Converter Route del navigateToConverter!!
      backPanel: listView,
      frontTitle: Text('Unit Converter'),
      backTitle: Text('Select a Category'),
    );
  }
}
