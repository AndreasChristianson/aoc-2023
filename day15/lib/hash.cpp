#include <string>

int hash(const std::string &instruction) {
    int hash = 0;

    for (char c: instruction) {
        hash += int(c);
        hash *= 17;
        hash = hash % 256;
    }

    return hash;
}

