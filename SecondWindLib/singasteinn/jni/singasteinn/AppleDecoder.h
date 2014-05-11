//
//  AppleDecoder.h
//  singasteinn
//
//  Created by Во on 12.11.2013.
//
//

// C part
//extern "C" {
//#endif

//extern void * afdecoderCreate(const char * url);
extern int afdecoderRead(void *self, short* buffer, int len);
extern int afdecoderIsEOF(void * self);
extern int afdecoderGetSampleRate(void * self);
extern void afdecoderDestroy(void * self);
//#ifdef __cplusplus
//}
//
//#endif

//#ifdef __cplusplus
#include "logging.h"
#include "ISoundStream.h"
#include <string>


class AppleDecoder: public ISoundSource, public ISeekable{
    void * obj;
public:
    AppleDecoder(): obj(0){
        
    }
    virtual ~AppleDecoder(){
        afdecoderDestroy(obj);
    }
    virtual void open(std::string url);
    virtual int read(short * buffer, int len)
    {
        if (isEOF()){
            throw EOFException();
        }
        return afdecoderRead(obj, buffer, len);
    }
    virtual int getSampleRate(){
        return afdecoderGetSampleRate(obj);
    }
    virtual bool isEOF(){
        return afdecoderIsEOF(obj);
    }
    
    virtual float tellSec(){
        return 0; // TODO implement
    }

    virtual void seekSec(float pos){
        // TODO implement
    }

    
};

//#endif

