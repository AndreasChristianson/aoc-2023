#include <iostream>
#include <fstream>
#include <string>
#include "lib/split.h"
#include "lib/hash.h"
#include "class/lens.h"
#include <vector>
#include <map>
#include <tuple>
#include <algorithm>


int main(int argc, char *argv[]) {
    std::cout << "Hello World!\n";
    std::ifstream file(argv[1]);
    std::string str;
    if (file.is_open() && file.good()) {
        file >> str;
    }
    file.close();
    printf("%s\n", str.c_str());
    const std::vector<std::string> &instructions = split(str, ',');
    int sum = 0;
    for (const std::string &instruction: instructions) {
        printf("||%s|| = %d\n", instruction.c_str(), hash(instruction));
        sum += hash(instruction);
    }

    printf("sum: %d\n", sum);

    std::map<int, std::vector<lens> > map;

    for (int box = 0; box < 256; box++) {
        map[box] = std::vector<lens>();
    }

    for (std::string instruction: instructions) {
        printf("instruction: %s\n", instruction.c_str());
        switch (instruction.back()) {
            case '-': {
                const std::vector<std::string> &split_instruction = split(instruction, '-');
                const std::string label = split_instruction[0];
                const int box = hash(label);
                printf("- ||%s||, %d\n", label.c_str(), box);
                std::vector<lens> lenses = map[box];
//                printf("- %zu\n", lenses.size());
//                auto test = std::find_if(
//                        lenses.begin(),
//                        lenses.end(),
//                        [&label](const lens &l) {
//                            return l.label == label;
//                        }
//                );

                lenses.erase(std::remove_if(
                        lenses.begin(),
                        lenses.end(),
                        [&label](const lens &l) {
//                            printf("potential %s:%d\n", l.label.c_str(), l.focal_length);
//                            printf("target %s\n", label.c_str());
//                            printf("comp: %d\n", l.label == label);
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
//                std::replace_if(s.begin(), s.end(),
//                                std::bind(std::less<int>(), std::placeholders::_1, 5), 55);
                const auto found = std::find_if(
                        lenses.begin(),
                        lenses.end(),
                        [&label](const lens &l) {
                            return l.label == label;
                        });
                if (found != lenses.end()) {
//                    const lens f = found[0];
//                    found->focal_length=length;
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
            int lens_power = (1+item.first)*(1+i)*l.focal_length;
            printf("[%s %d (%d)]", l.label.c_str(), l.focal_length, lens_power);
            power+=lens_power;
        }
        printf("\n");
    }
    printf("total power:%d\n", power);

    return 0;
}
