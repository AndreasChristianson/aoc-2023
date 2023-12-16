#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

struct Grid {
    int width;
    int height;
    unsigned int *seen;
    char *grid;
};

enum Direction {
    N = 1,
    S = 2,
    E = 4,
    W = 8
};

enum Direction bounce_nw_se(enum Direction direction);

struct Grid readFile(char *fileName) {
    int c;
    FILE *file;
    file = fopen(fileName, "r");
    int width = 0;
    int height = 0;
    while (getc(file) != '\n') {
        width++;
    }
    rewind(file);
    while ((c = getc(file)) != EOF) {
        if (c == '\n') {
            height++;
        }
    }
    printf("%d\n", width);
    printf("%d\n", height);
    rewind(file);
    char *grid = calloc(width * height, sizeof(char));
    for (int row = 0; row < height; ++row) {
        for (int col = 0; col < width; ++col) {
            grid[row * width + col] = getc(file);
        }
        getc(file);
    }
    fclose(file);
    unsigned int *seen = calloc(width * height, sizeof(unsigned int));
    struct Grid ret;
    ret.width = width;
    ret.height = height;
    ret.grid = grid;
    ret.seen = seen;
    return ret;
}

enum Direction bounce_nw_se(enum Direction direction) {
    switch (direction) {
        case N:
            return W;
        case S:
            return E;
        case E:
            return S;
        case W:
            return N;
    }
}

enum Direction bounce_ne_sw(enum Direction direction);

int move_row(enum Direction direction, int row);

enum Direction bounce_ne_sw(enum Direction direction) {
    switch (direction) {
        case N:
            return E;
        case S:
            return W;
        case E:
            return N;
        case W:
            return S;
    }
}

int move_col(enum Direction direction, int col);

int split_n_s(struct Grid *pGrid, int row, int col, enum Direction direction);

int continue_empty(struct Grid *pGrid, int row, int col, enum Direction direction);

int split_e_w(struct Grid *pGrid, int row, int col, enum Direction direction);

unsigned int get_seen(struct Grid *g, int row, int col) {
    return g->seen[row * g->width + col];
}

void set_seen(struct Grid *g, int row, int col, enum Direction dir) {
    g->seen[row * g->width + col] |= dir;
}

char get_char(struct Grid *g, int row, int col) {
    return g->grid[row * g->width + col];
}

void print(struct Grid *g) {
    for (int row = 0; row < g->height; ++row) {
        for (int col = 0; col < g->width; ++col) {
            printf("%c", get_char(g, row, col));
        }
        printf("\n");
    }
}

void print_energized(struct Grid *g) {
    for (int row = 0; row < g->height; ++row) {
        for (int col = 0; col < g->width; ++col) {
            if (get_seen(g, row, col) != 0) {
                printf("#");
            } else {
                printf(" ");
            }
        }
        printf("\n");
    }
}

int fire_my_lazer(struct Grid *g, enum Direction dir, int row, int col) {
//    printf("pew pew! (%d,%d) @ %d\n", row, col, dir);
//    print_energized(g);
    if (row < 0 || col < 0 || row > g->height - 1 || col > g->width - 1) {
//        printf("fell off the board");
        return 0;
    }
    unsigned int seen_bit_field = get_seen(g, row, col);
    bool seen = seen_bit_field != 0;
    int seen_increment = seen ? 0 : 1;
    bool seen_this_dir = (seen_bit_field & dir) != 0;
//    printf("details  (%d,%d) @ %d. seen_bit_field:%d, seen:%d, seen_this_dir:%d, seen_increment:%d\n", row, col, dir,
//           seen_bit_field, seen, seen_this_dir, seen_increment);
    if (seen_this_dir) {
//        printf("found my tail\n");
        return 0;
    }
    set_seen(g, row, col, dir);

    char tile = get_char(g, row, col);
    switch (tile) {
        case '.': {
//            printf("continue\n");
            return seen_increment + continue_empty(g, row, col, dir);
        }

        case '\\': {
//            printf("bounce_nw_se\n");

            enum Direction bounce_dir = bounce_nw_se(dir);
            return seen_increment + fire_my_lazer(g, bounce_dir, move_row(bounce_dir, row), move_col(bounce_dir, col));
        }
        case '/': {
//            printf("bounce_ne_sw. old dir: %d\n",dir);

            enum Direction bounce_dir = bounce_ne_sw(dir);
//            printf("bounce_ne_sw. new dir: %d\n", bounce_dir);
            return seen_increment + fire_my_lazer(g, bounce_dir, move_row(bounce_dir, row), move_col(bounce_dir, col));
        }
        case '|':
            return seen_increment + split_n_s(g, row, col, dir);
        case '-':
            return seen_increment + split_e_w(g, row, col, dir);
        default: {
//            printf("found an unexpected char%c\n", tile);
            return seen_increment + continue_empty(g, row, col, dir);
        }
    }
}

int split_e_w(struct Grid *g, int row, int col, enum Direction dir) {
//    printf("split_e_w\n");

    switch (dir) {
        case E:
        case W:
            return continue_empty(g, row, col, dir);
        case N:
        case S:
            return continue_empty(g, row, col, E) + continue_empty(g, row, col, W);
    }
}

int continue_empty(struct Grid *g, int row, int col, enum Direction dir);

int split_n_s(struct Grid *g, int row, int col, enum Direction dir) {
//    printf("split_n_s\n");

    switch (dir) {
        case N:
        case S:
            return continue_empty(g, row, col, dir);
        case E:
        case W:
            return continue_empty(g, row, col, S) + continue_empty(g, row, col, N);
    }
}

int move_col(enum Direction direction, int col) {
    switch (direction) {
        case E:
            return col + 1;
        case W:
            return col - 1;
        case N:
        case S:
            return col;
    }
}

int move_row(enum Direction direction, int row) {
    switch (direction) {
        case N:
            return row - 1;
        case S:
            return row + 1;
        case E:
        case W:
            return row;
    }
}

int continue_empty(struct Grid *g, int row, int col, enum Direction dir) {
    return fire_my_lazer(g, dir, move_row(dir, row), move_col(dir, col));
}

int max(int r, int l) {
    if (r < l)
        return l;
    return r;
}

void reset_seen(struct Grid *g) {
    free(g->seen);
    g->seen = calloc(g->width * g->height, sizeof(unsigned int));
}

int main(int argc, char **argv) {
    struct Grid grid = readFile(argv[1]);
    print(&grid);
    int energized = fire_my_lazer(&grid, E, 0, 0);
    printf("energized: %d\n", energized);
    int max_so_far = 0;
//    print_energized(&grid);
    for (int row = 0; row < grid.height; ++row) {
        reset_seen(&grid);
        max_so_far = max(max_so_far, fire_my_lazer(&grid, E, row, 0));
        reset_seen(&grid);
        max_so_far = max(max_so_far, fire_my_lazer(&grid, W, row, grid.width - 1));
    }
    for (int col = 0; col < grid.width; ++col) {
        reset_seen(&grid);
        max_so_far = max(max_so_far, fire_my_lazer(&grid, S, 0, col));
        reset_seen(&grid);
        max_so_far = max(max_so_far, fire_my_lazer(&grid, N, grid.height - 1, col));
    }
    printf("max energized: %d\n", max_so_far);
    return 0;
}

