#ifndef ITEMPOSTORAGE_H
#define ITEMPOSTORAGE_H
#include "analysis/ISongAnalyzer.h"

class ITempoStorage{
public:
    virtual ~ITempoStorage(){};
    virtual ISongAnalyzer::Result * read(std::string url) = 0;
    virtual void save(std::string url, const ISongAnalyzer::Result & data) = 0;
    virtual void erase(std::string url) = 0;
};



#endif
