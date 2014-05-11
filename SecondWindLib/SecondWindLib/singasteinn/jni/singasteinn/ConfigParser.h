#ifndef CONFIG_PARSER_H
#define CONFIG_PARSER_H
#include <map>

class ConfigParser{
    std::map<std::string,std::string> mValues;
public:
    ConfigParser(std::string path);
    std::string get(std::string key, std::string def);
    //int get(std::string key, int def);
    float get(std::string key, float def);
    bool isSet(std::string key);
};

#endif
