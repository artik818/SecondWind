#ifndef SINGASTEINN_LOGGING_H
#define SINGASTEINN_LOGGING_H

#include <log4cplus/loggingmacros.h>
#include <log4cplus/logger.h>

#define LOGE(fmt) LOG4CPLUS_ERROR(logger, fmt)
#define LOGEF(fmt, ...) LOG4CPLUS_ERROR_FMT(logger, fmt, __VA_ARGS__)

#define LOGW(fmt) LOG4CPLUS_WARN(logger, fmt)
#define LOGWF(fmt, ...) LOG4CPLUS_WARN_FMT(logger, fmt, __VA_ARGS__)

#define LOGI(fmt) LOG4CPLUS_INFO(logger, fmt)
#define LOGIF(fmt, ...) LOG4CPLUS_INFO_FMT(logger, fmt, __VA_ARGS__)

#define LOGD(fmt) LOG4CPLUS_DEBUG(logger, fmt)
#define LOGDF(fmt, ...) LOG4CPLUS_DEBUG_FMT(logger, fmt, __VA_ARGS__)

#define LOGGER(name) static log4cplus::Logger logger = log4cplus::Logger::getInstance( name )

#endif
