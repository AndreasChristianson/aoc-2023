#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>

std::vector<std::string> split (const std::string &s, char delim) {
    std::vector<std::string> result;
    std::stringstream ss (s);
    std::string item;

    while (getline (ss, item, delim)) {
        result.push_back (item);
    }

    return result;
}

int main(int argc, char *argv[]) {
    std::cout << "Hello World!\n";
    std::ifstream file(argv[1]);
    std::string str;
    if (file.is_open() && file.good()) {
        file >> str;
    }
    file.close();
    printf("%s", str.c_str());
    return 0;
}
