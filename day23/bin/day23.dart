import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

Future<void> main(List<String> args) async {
  var grid = Grid(readFile(args[0]));
  grid.link();
  // grid.collapse();
  print(grid);
  var routeLengths = grid.navigate(grid.start, grid.end);
  var maxLength = routeLengths.reduce((value, element) => max(value, element));
  print(maxLength);
  var grid2 = Grid(readFile(args[0]));
  grid2.linkPermissively();
  grid2.collapse();
  var routeLengths2 = grid2.navigatePermissively(grid2.start, grid2.end);
  var maxLength2 =
      routeLengths2.reduce((value, element) => max(value, element));
  print(maxLength2);
}

List<String> readFile(String fileName) {
  final file = File(fileName);
  return file.readAsLinesSync();
}

class Point extends Equatable {
  final int row;
  final int col;

  Point(this.row, this.col);

  @override
  List<Object?> get props => [row, col];
}

class Tile {
  List<Tile> links = [];
  final TileType type;
  int weight = 1;

  Tile(this.type);

  @override
  String toString() {
    return type.toString();
  }
}

enum TileType {
  path,
  downSlide,
  upSlide,
  leftSlide,
  rightSlide;

  @override
  String toString() {
    switch (this) {
      case TileType.path:
        return '.';
      case TileType.downSlide:
        return 'v';
      case TileType.upSlide:
        return '^';
      case TileType.leftSlide:
        return '<';
      case TileType.rightSlide:
        return '>';
    }
  }
}

class Grid {
  late final int width;
  late final int height;
  final Map<Point, Tile> tiles = {};

  Tile get start {
    return get(0, 1)!;
  }

  Tile get end {
    return get(height - 1, width - 2)!;
  }

  void put(int row, int col, Tile tile) {
    tiles[Point(row, col)] = tile;
  }

  Tile? get(int row, int col) {
    return tiles[Point(row, col)];
  }

  Grid(List<String> lines) {
    width = lines.first.length;
    height = lines.length;
    for (var row = 0; row < height; row++) {
      var line = lines[row];
      for (var col = 0; col < width; col++) {
        var char = line.codeUnitAt(col);
        switch (String.fromCharCode(char)) {
          case '.':
            put(row, col, Tile(TileType.path));
            break;
          case '>':
            put(row, col, Tile(TileType.rightSlide));
            break;
          case '<':
            put(row, col, Tile(TileType.leftSlide));
            break;
          case 'v':
            put(row, col, Tile(TileType.downSlide));
            break;
          case '^':
            put(row, col, Tile(TileType.upSlide));
            break;
        }
      }
    }
  }

  @override
  String toString() {
    var ret = "";
    for (var row = 0; row < height; row++) {
      for (var col = 0; col < width; col++) {
        ret += get(row, col)?.type.toString() ?? ' ';
      }
      ret += "\n";
    }
    return 'Grid{width: $width, height: $height} \n$ret';
  }

  void link() {
    for (var row = 0; row < height; row++) {
      for (var col = 0; col < width; col++) {
        var tile = get(row, col);
        if (tile != null) {
          var north = get(row - 1, col);
          if (north != null && north.type != TileType.downSlide) {
            tile.links.add(north);
          }

          var south = get(row + 1, col);
          if (south != null && south.type != TileType.upSlide) {
            tile.links.add(south);
          }

          var east = get(row, col + 1);
          if (east != null && east.type != TileType.leftSlide) {
            tile.links.add(east);
          }

          var west = get(row, col - 1);
          if (west != null && west.type != TileType.rightSlide) {
            tile.links.add(west);
          }
        }
      }
    }
  }

  void linkPermissively() {
    for (var row = 0; row < height; row++) {
      for (var col = 0; col < width; col++) {
        var tile = get(row, col);
        if (tile != null) {
          var north = get(row - 1, col);
          if (north != null) {
            tile.links.add(north);
          }

          var south = get(row + 1, col);
          if (south != null) {
            tile.links.add(south);
          }

          var east = get(row, col + 1);
          if (east != null) {
            tile.links.add(east);
          }

          var west = get(row, col - 1);
          if (west != null) {
            tile.links.add(west);
          }
        }
      }
    }
  }

  Iterable<int> navigate(Tile start, Tile end) sync* {
    List<(Tile current, Tile? last)> queue = [];
    List<(Tile current, Tile? last)> nextQueue = [(start, null)];
    var distance = 0;
    while (nextQueue.isNotEmpty) {
      queue = nextQueue;
      nextQueue = [];
      while (queue.isNotEmpty) {
        var (current, last) = queue.removeLast();
        if (current == end) {
          yield (distance);
        }
        var branches = current.links
            .where((element) => element != last)
            .map((link) => (link, current));
        if (branches.length > 1) {
          // print(branches);
        }
        nextQueue.addAll(branches);
      }
      distance++;
    }
  }

  Iterable<int> navigatePermissively(Tile start, Tile end) sync* {
    List<Path> queue = [Path.initial(start)];
    int i = 0;
    while (queue.isNotEmpty) {
      var path = queue.removeLast();
      if (path.tile == end) {
        yield (path.distance - 1);
      }
      var branches = path.tile.links
          .where((tile) => !path.seen(tile))
          .map((tile) => Path(path, tile));
      queue.addAll(branches);
      if (++i % 1000000 == 0) {
        print("$i: queue: ${queue.length}");
      }
    }
  }

  void collapse() {
    for (var tile in tiles.values) {
      if (tile.links.length == 2) {
        if (tile.links[1].links.length == 2) {
          tile.links[0].links.remove(tile);
          tile.links[1].links.remove(tile);
          tile.links[0].links.add(tile.links[1]);
          tile.links[1].links.add(tile.links[0]);
          tile.links[1].weight += tile.weight;
        } else if (tile.links[0].links.length == 2) {
          tile.links[0].links.remove(tile);
          tile.links[1].links.remove(tile);
          tile.links[0].links.add(tile.links[1]);
          tile.links[1].links.add(tile.links[0]);
          tile.links[0].weight += tile.weight;
        }
      }
    }
  }
}

class Path {
  late final Tile tile;
  late final Path? prev;

  Path.initial(this.tile) {
    prev = null;
  }

  Path(this.prev, this.tile);

  int get distance => (prev?.distance ?? 0) + tile.weight;

  bool seen(Tile tile) {
    return this.tile == tile || (prev?.seen(tile) ?? false);
  }
}
