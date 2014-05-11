#include <Python/Python.h>
#include "PySongAnalyzer.h"

#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.PySongAnalyzer");



const ISongAnalyzer::Result PySongAnalyzer::analyze(std::string fn){
    LOG4CPLUS_ERROR_FMT(logger, "processing file: %s", fn.c_str());

    Py_Initialize();

    PyObject * pPath = PyString_FromString("/Users/vvs/PycharmProjects/singasteinn-py/main.py");
    PyObject * pModule = PyImport_Import(pPath);
    Py_DECREF(pPath);

    if (pModule){

    }
    else{
        LOG4CPLUS_ERROR(logger, "unable to import module");
        PyErr_Print();
    }

    Py_Finalize();
    LOG4CPLUS_ERROR(logger, "end");
    abort();
    return Result();
}
