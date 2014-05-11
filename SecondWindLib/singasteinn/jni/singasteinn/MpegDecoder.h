//
//  MpegDecoder.h
//  singasteinn
//
//  Created by Во on 16.07.2013.
//
//

#ifndef __singasteinn__MpegDecoder__
#define __singasteinn__MpegDecoder__
#include <string>
#include <exception>
#include "mpg123.h"
#include "ISoundStream.h"

#include <iostream>



class IUrlDecoder{

};

class MpegDecoder: public ISoundSource, public ISeekable{
    static bool mpg123Initialized;

    mpg123_handle *mHandle;
    void checkError(int retcode);
    int encoding, channels;
    long sampleRate;
    bool mEOF;
public:
    MpegDecoder();
    virtual ~MpegDecoder();
    void open(std::string fn);
    int tell();
    long len();
    std::string error();
    int seek(int sample);
    virtual int read(SampleType * buf, int len);
    virtual int getSampleRate(){
        if (!sampleRate)
            getFormat();
        return sampleRate;
    }
    void getFormat();

    virtual float tellSec();
    virtual void seekSec(float pos);
    virtual bool isEOF();

};

class DecoderException: public std::exception{
    std::string mMsg;
    
public:
    DecoderException(std::string msg){mMsg = msg;}
    virtual ~DecoderException() throw(){}
    virtual const char * what(){
        return mMsg.c_str();
    }
};




#endif /* defined(__singasteinn__MpegDecoder__) */
