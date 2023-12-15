#pragma once

class lens {
public:
    std::string label;
    int focal_length;

    lens(std::string label, int focal_length)
            : label(label), focal_length(focal_length) {}
};

