import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Coordinate.g.dart';

@HiveType(typeId: 5)
class Coordinate
{
  @HiveField(0)
  final num latitudine;

  @HiveField(1)
  final num longitudine;

  Coordinate({
    @required this.latitudine,
    @required this.longitudine,
  });
}