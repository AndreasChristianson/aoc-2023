#include <iostream>
#include <fstream>
#include <string>
#include "lib/split.h"
#include "lib/hash.h"
#include "class/lens.h"
#include <vector>
#include <map>


int main(int argc, char *argv[]) {
    std::ifstream file(argv[1]);
    std::string str;
    if (file.is_open() && file.good()) {
        file >> str;
    }
    file.close();
    const std::vector<std::string> &instructions = split(str, ',');
    int sum = 0;
    for (const std::string &instruction: instructions) {
        sum += hash(instruction);
    }

    printf("sum: %d\n", sum);

    std::map<int, std::vector<lens> > map;

    for (int box = 0; box < 256; box++) {
        map[box] = std::vector<lens>();
    }

    for (std::string instruction: instructions) {
        switch (instruction.back()) {
            case '-': {
                const std::vector<std::string> &split_instruction = split(instruction, '-');
                const std::string label = split_instruction[0];
                const int box = hash(label);
                std::vector<lens> lenses = map[box];
                lenses.erase(std::remove_if(
                        lenses.begin(),
                        lenses.end(),
                        [&label](const lens &l) {
                            return l.label == label;
                        }
                ), lenses.end());
                map[box] = lenses;
            }
                break;
            default: {
                const std::vector<std::string> &split_instruction = split(instruction, '=');
                const std::string label = split_instruction[0];
                const int length = std::stoi(split_instruction[1]);
                const int box = hash(label);
                auto lenses = map[box];
                const auto new_lens = new lens(label, length);
                const auto found = std::find_if(
                        lenses.begin(),
                        lenses.end(),
                        [&label](const lens &l) {
                            return l.label == label;
                        });
                if (found != lenses.end()) {
                    *found = *new_lens;
                } else {
                    lenses.push_back(*new_lens);
                }
                map[box] = lenses;
            }
        }

    }
    int power = 0;
    for (auto &&item: map) {
        if (item.second.empty()) continue;
        printf("%d: ", item.first);
        for (int i = 0; i < item.second.size(); i++) {
            lens l = item.second[i];
            int lens_power = (1 + item.first) * (1 + i) * l.focal_length;
            printf("[label: %s focal: %d power: %d]", l.label.c_str(), l.focal_length, lens_power);
            power += lens_power;
        }
        printf("\n");
    }
    printf("total power: %d\n", power);

    return 0;
}
