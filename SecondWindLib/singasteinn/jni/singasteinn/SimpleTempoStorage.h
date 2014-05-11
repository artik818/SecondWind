#ifndef SIMPLETEMPOSTORAGE_H
#define SIMPLETEMPOSTORAGE_H
#include "ITempoStorage.h"

class SimpleTempoStorage: public ITempoStorage{
    std::string mPath;
    std::string pathForUrl(std::string url);
    bool writeOnly;
public:
    static std::string escapeUrl(std::string url);
    SimpleTempoStorage(std::string path);
    virtual ISongAnalyzer::Result * read(std::string url);
    virtual void save(std::string url, const ISongAnalyzer::Result &data);
    virtual void erase(std::string url);

    void setWriteOnly(bool val){
        writeOnly = val;
    }
};

#endif
