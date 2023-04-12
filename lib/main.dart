import 'package:flutter/material.dart';
import './ui/climate.dart';

import 'package:http/http.dart';


void main()
{
  runApp(MaterialApp(
    title: 'climate',
    home: climate(),
  ));
}