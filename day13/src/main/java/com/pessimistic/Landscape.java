package com.pessimistic;

import java.util.List;

public class Landscape {
    private final List<String> partitionContents;
    private final Tile[] grid;
    private final int height;
    private final int width;

    public Landscape(List<String> partitionContents) {
        this.partitionContents = partitionContents;
        this.grid = parse(partitionContents);
        this.height = partitionContents.size();
        this.width = partitionContents.getFirst().length();
//        System.out.println(partitionContents);
    }

    private Tile[] parse(List<String> partitionContents) {
        int height = partitionContents.size();
        int width = partitionContents.getFirst().length();
        Tile[] ret = new Tile[height * width];
        for (int row = 0; row < partitionContents.size(); row++) {
            String line = partitionContents.get(row);
            for (int col = 0; col < line.length(); col++) {
                ret[row * width + col] = Tile.from(line.charAt(col));
            }
        }
        return ret;
    }

    public int getReflectionHeight(int smudges) {
        outer:
        for (int reflectionRow = 1; reflectionRow < this.height; reflectionRow++) {
            int smudgesNeeded = 0;
            for (int checkRow = 1; reflectionRow - checkRow >= 0 && reflectionRow + checkRow <= this.height; checkRow++) {
                smudgesNeeded += this.rowsReflect(reflectionRow + checkRow - 1, reflectionRow - checkRow);
            }
            if (smudges == smudgesNeeded) {
                return reflectionRow;
            }
        }
        return 0;
    }

    private int rowsReflect(int top, int bottom) {
        int sum = 0;
        for (int i = 0; i < this.width; i++) {
            if (get(top, i) != get(bottom, i)) {
                sum++;
            }
        }
        return sum;
    }

    private Tile get(int row, int col) {
        return grid[row * this.width + col];
    }

    public int getReflectionWidth(int smudges) {
        for (int reflectionCol = 1; reflectionCol < this.width; reflectionCol++) {
            int smudgesNeeded = 0;
            for (int checkCol = 1; reflectionCol - checkCol >= 0 && reflectionCol + checkCol <= this.width; checkCol++) {
                smudgesNeeded += this.colsReflect(reflectionCol + checkCol - 1, reflectionCol - checkCol);
            }
            if (smudges == smudgesNeeded) {
                return reflectionCol;
            }
        }
        return 0;
    }


    private int colsReflect(int right, int left) {
        int sum = 0;
//        System.out.format("checking %d and %d\n",left,right);
        for (int i = 0; i < this.height; i++) {
            if (get(i, left) != get(i, right)) {
                sum++;
            }
        }
        return sum;
    }
}
