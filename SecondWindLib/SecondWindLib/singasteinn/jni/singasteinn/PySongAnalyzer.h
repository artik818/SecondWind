#ifndef PYSONGANALYZER_H
#define PYSONGANALYZER_H


#include "analysis/ISongAnalyzer.h"

class PySongAnalyzer: public ISongAnalyzer{
public:
    virtual const Result analyze(std::string fn);
};




#endif
