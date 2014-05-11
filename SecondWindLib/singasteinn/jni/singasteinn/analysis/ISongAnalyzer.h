#ifndef ISONGANALYZER_H
#define ISONGANALYZER_H

#include <vector>
#include <string>

class ISongAnalyzer{
public:

    class Result{
        friend class SimpleTempoStorage;
        std::vector<float> mTimeMarks;
        std::vector<float> mValues;
//        float mFlatTempoFactor;
    public:
        float get(float time) const;
        void put(float time, float val);
        void print()const;
        virtual ~Result(){}
    };

    virtual const Result analyze() = 0;
    virtual ~ISongAnalyzer(){}

};

#endif
