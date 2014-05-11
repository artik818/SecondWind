#ifndef ISOUNDSTREAM_H
#define ISOUNDSTREAM_H

#include <exception>
#include <string>

class BasicException: public std::exception{
    std::string mMsg;
public:
    BasicException(std::string msg){
        mMsg = msg;
    }
    virtual ~BasicException() throw(){}
    virtual const char* what() const throw(){
        return mMsg.c_str();
    }
};

// The exception is to be thrown only when no samples are read
class EOFException: public BasicException{
public:
    EOFException(std::string msg= "eof"):
        BasicException(msg){}
};

class ISoundSource{
public:
    typedef short SampleType;
    virtual int getSampleRate() = 0;
    virtual int read(SampleType * buf, int len) = 0;
    virtual bool isEOF() = 0;
    virtual ~ISoundSource(){}
};

class ISeekable {
public:
    virtual float tellSec() = 0;
    virtual void seekSec(float pos) = 0;
};

#endif
