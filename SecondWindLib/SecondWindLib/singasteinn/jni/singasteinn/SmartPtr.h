#ifndef SMARTPTR_H
#define SMARTPTR_H

#include <exception>
#include <string>
//#include <tr1/memory>
#include <memory>

/**
 * Simple reference counting container.
 * Don't forget to keep an instance while working with the wrapped pointer.
 * Nullable, will throw an exception in case of null pointer dereference attempt
 */
//typedef  ::shared_ptr SmartPtr;
using std::shared_ptr;
using std::dynamic_pointer_cast;
/*
template<class T>
class SmartPtr{
    struct Envelope{
        Envelope(T* p):
            ptr(p), cnt(0){}

        T* ptr;
        int cnt;
    };
    Envelope * env;
    void dropRef(){
        if (env){
            env->cnt--;
            if (!env->cnt){
                delete env->ptr;
                delete env;
                env = 0;
            }
        }
    }
    void setRef(Envelope * e){
        env = e;
        if (e){
            e->cnt++;
        }
    }

public:
    class NullPointerException: public std::exception{
        std::string mMsg;
    public:
        virtual const char * what() const throw(){
            return "Null pointer!";
        }
        virtual ~NullPointerException() throw(){}
    };

    SmartPtr():env(0){}
    SmartPtr(T*p){setRef(new Envelope(p));}
    SmartPtr(const SmartPtr<T> &other){setRef(other.env);}
    ~SmartPtr(){dropRef();}

    T& operator*() throw (NullPointerException){
        if (!env)
            throw NullPointerException();
        return *env->ptr;
    }

    const T& operator*() const throw (NullPointerException){
        if (!env)
            throw NullPointerException();
        return *env->ptr;
    }

    T* operator->() throw (NullPointerException){
        if (!env)
            throw NullPointerException();
        return env->ptr;
    }

    const T* operator->() const throw (NullPointerException){
        if (!env)
            throw NullPointerException();
        return env->ptr;
    }


    const SmartPtr<T> & operator=(T* p){
        dropRef();
        setRef(new Envelope(p));
        return *this;
    }
    const SmartPtr<T> & operator=(const SmartPtr<T>& other) {
        dropRef();
        setRef(other.env);
        return *this;
    }

    
    bool operator== (const SmartPtr<T>&other) const{
        return env == other.env;
    }

    operator bool() const{
        return env && env->ptr;
    }
};
*/

#endif
