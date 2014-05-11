
cmake_minimum_required(VERSION 2.8)
if (ANDROID)
    add_definitions (-DOPT_ARM -DREAL_IS_FIXED -DHAVE_CONFIG_H -DPIC)
    set_property(SOURCE synth_arm.S PROPERTY LANGUAGE C)

    add_library(mpg123_java SHARED
       wrapper.cpp 
    )
    target_link_libraries(mpg123_java mpg123)
else()
    add_definitions (-DOPT_GENERIC -DREAL_IS_FIXED -DHAVE_CONFIG_H -DPIC)
endif()
add_library(mpg123 SHARED
   libmpg123.c 
   compat.c 
   dct64.c 
   equalizer.c 
   feature.c 
   format.c 
   frame.c 
   icy.c 
   icy2utf8.c 
   id3.c 
   index.c 
   layer1.c 
   layer2.c 
   layer3.c 
   lfs_alias.c 
   ntom.c 
   optimize.c 
   parse.c 
   readers.c 
   tabinit.c 
   stringbuf.c 
   synth.c 
   synth_8bit.c 
   synth_arm.S
)
target_link_libraries(mpg123 m)

include_directories(..)
