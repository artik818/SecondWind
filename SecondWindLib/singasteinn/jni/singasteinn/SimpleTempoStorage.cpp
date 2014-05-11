#include "SimpleTempoStorage.h"
#include <stdio.h>
#include "logging.h"
#include <sys/stat.h>

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.SimpleTempoStorage");
const static std::string HEADER = "TEMPO\n";

SimpleTempoStorage::SimpleTempoStorage(std::string path):
    mPath(path),
    writeOnly(false)
{
    struct stat s;
    LOGDF("Initializing FS tempo cache: '%s'", path.c_str());
    assert(!lstat(path.c_str(), &s));
    assert((s.st_mode & S_IFDIR) == S_IFDIR);
    
        

}

std::string SimpleTempoStorage::escapeUrl(std::string url){
    const int len = url.length();
    char ret[len];
    memcpy(ret, url.c_str(), len);
    for (int i = 0; i<len; i++){
        switch (ret[i]){
        case '/':
        case '\\': // do we really need to support that strange platforms?
            ret[i] = '_';
        }
    }
    return std::string(ret, len);
}

std::string SimpleTempoStorage::pathForUrl(std::string url){
    return mPath + "/" + escapeUrl(url);
}

void SimpleTempoStorage::save(std::string url, const ISongAnalyzer::Result &data){
    std::string path = pathForUrl(url);
    FILE * f = fopen(path.c_str(), "w");
    if (!f){
        LOGEF("Unable to open file: %s", path.c_str());
        return;
    }

    fwrite(HEADER.c_str(), HEADER.length(), 1, f);
    for (int i=0; i< data.mTimeMarks.size(); i++){
        fprintf(f, "%.7f %.7f\n", data.mTimeMarks[i], data.mValues[i]);
    }

    fclose(f);
}

ISongAnalyzer::Result * SimpleTempoStorage::read(std::string url){
    if (writeOnly){
        LOGW("Cache reading is forbidden");
        return 0;
    }
    std::string path = pathForUrl(url);
    FILE * f = fopen(path.c_str(), "r");
    if (!f){
        LOGEF("Unable to open file: %s", path.c_str());
        return 0;
    }

    char headerBuf[HEADER.length()];

    fread(headerBuf, 1, HEADER.length(), f);
    if (std::string(headerBuf, HEADER.length()) != HEADER){
        LOGE("File header does not match");
        return 0;
    }
    ISongAnalyzer::Result * res = new ISongAnalyzer::Result();
    while (true){
        float t, v;
        if (fscanf(f, "%f %f", &t, &v)!=2){
            break;
        }
        res->put(t, v);
    }
    fclose(f);
    LOGDF("Tempo read, values count: %d", res->mTimeMarks.size());
    return res;
}

void SimpleTempoStorage::erase(std::string url){

}


