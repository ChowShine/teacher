cmake_minimum_required(VERSION 3.4.1)

#set(lib_folder G:/cppinclude/001_lib_prebuilt/)
set(lib_folder $ENV{THIRD_PATH}/001_lib_prebuilt/)
#message(STATUS "lib_folder: ${lib_folder}")

#####################################################################################

file(GLOB_RECURSE SRC_FOLD_CC "${CMAKE_SOURCE_DIR}/../../src/*.cc")
file(GLOB_RECURSE SRC_FOLD "${CMAKE_SOURCE_DIR}/../../src/*.cpp")

file(GLOB_RECURSE JNI_FOLD_CC "${CMAKE_SOURCE_DIR}/jni/*.cc")
file(GLOB_RECURSE JNI_FOLD "${CMAKE_SOURCE_DIR}/jni/*.cpp")

file(GLOB_RECURSE PLUG_FOLD_CC "${CMAKE_SOURCE_DIR}/../../plugins/*.cc")
file(GLOB_RECURSE PLUG_FOLD "${CMAKE_SOURCE_DIR}/../../plugins/*.cpp")

add_library(videochat_cpp_plugin
             SHARED
             ${SRC_FOLD}
             ${SRC_FOLD_CC}
			       ${JNI_FOLD}
             ${JNI_FOLD_CC}
			       ${PLUG_FOLD}
             ${PLUG_FOLD_CC}
            )

#####################################################################################
add_definitions(-fexceptions -frtti -fsigned-char -DNO_LOCALE_SUPPORT -DX_STRUCT)

add_library( libjson_static STATIC IMPORTED )
set_target_properties( libjson_static
                           PROPERTIES
                           IMPORTED_LOCATION ${lib_folder}libjson/prebuilt/android/${ANDROID_ABI}/libjson.a)

#####################################################################################
add_library(videochat_cpp SHARED IMPORTED )
set_target_properties( videochat_cpp
                           PROPERTIES
                           IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/../../plugins_libs/${ANDROID_ABI}/libvideochat_cpp.so)

#####################################################################################

target_include_directories( videochat_cpp_plugin PRIVATE
								${CMAKE_SOURCE_DIR}/../../include/
                ${CMAKE_SOURCE_DIR}/../../plugins/
                ${CMAKE_SOURCE_DIR}/../../plugins/wsfunction
								${lib_folder}libpub/include
								${lib_folder}libjson/include
								${lib_folder}x2struct
								)


#####################################################################################

target_link_libraries( videochat_cpp_plugin
						libjson_static
                        videochat_cpp
                        z
                        log
						            android
                        )