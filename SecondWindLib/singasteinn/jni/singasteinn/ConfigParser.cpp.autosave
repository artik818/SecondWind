#include "ConfigParser.h"
#include <fstream>;
#include <stdio.h>

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.ConfigParser");

ConfigParser::ConfigParser(std::string path){
    std::ifstream is(path.c_str());
    if (!is.good()){
        LOG4CPLUS_ERROR_FMT(logger, "Unable to read file '%s'", path.c_str());
        throw "error";
    }
    std::string buf;
    while(!is.eof()){
        std::getline(is, buf);
        int pos = buf.find_first_of('=');
        if (pos != std::string::npos){
            std::string key = buf.substr(0, pos);
            std::string val = buf.substr(pos + 1);
            LOG4CPLUS_INFO_FMT(logger, "Read value '%s' = '%s'", key.c_str(), val.c_str());
            mValues[key] = val;
        }
    }
}

std::string ConfigParser::get(std::string key, std::string def){
    if (mValues.count(key)){
        return mValues[key];
    }
    LOG4CPLUS_WARN_FMT(logger, "No value for key '%s', using default ('%s')", key.c_str(), def.c_str());
    return def;

}

float ConfigParser::get(std::string key, float def){
    if (mValues.count(key)){
        std::string v = mValues[key];
        float ret;
        if (sscanf(v.c_str(), "%f", &ret))
            return ret;
    }
    LOG4CPLUS_WARN_FMT(logger, "No value for key '%s', using default (%f)", key.c_str(), def);
    return def;
}

bool ConfigParser::isSet(std::string key){
    return mValues.count(key);
}

