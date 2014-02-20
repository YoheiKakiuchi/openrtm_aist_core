cmake_minimum_required(VERSION 2.8.3)
project(openrtm_aist)

## Find catkin macros and libraries
find_package(catkin REQUIRED mk rostest)

# Compile OpenRTM
# <devel>/lib/<package>/bin/rtcd
# <devel>/lib/libRTC...
# <src>/<package>/share
if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/installed)
  execute_process(
    COMMAND cmake -E chdir ${CMAKE_CURRENT_BINARY_DIR}
    make -f ${PROJECT_SOURCE_DIR}/Makefile.openrtm_aist
    INSTALL_DIR=${CATKIN_DEVEL_PREFIX}
    INSTALL_BIN_DIR=${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}
    INSTALL_DATA_DIR=${PROJECT_SOURCE_DIR}/share
    MK_DIR=${mk_PREFIX}/share/mk
    PATCH_DIR=${PROJECT_SOURCE_DIR}
    MD5SUM_FILE=${PROJECT_SOURCE_DIR}/OpenRTM-aist-1.1.0-RELEASE.tar.gz.md5sum
    VERBOSE=1
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "Compile openrtm_aist failed: ${_make_failed}")
  endif(_make_failed)
endif()

# ###################################
# ## catkin specific configuration ##
# ###################################

# catkin_package
catkin_package(
)

#############
## Install ##
#############

# ## Mark cpp header files for installation
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/
  DESTINATION ${CATKIN_GLOBAL_INCLUDE_DESTINATION})
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib/
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  USE_SOURCE_PERMISSIONS)
install(DIRECTORY test share
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  USE_SOURCE_PERMISSIONS)

# #debug codes
# #get_cmake_property(_variableNames VARIABLES)
# #foreach (_variableName ${_variableNames})
# #  message(STATUS "${_variableName}=${${_variableName}}")
# #endforeach()
# # CODE to fix path in rtm-config and openrtm-aist.pc
 install(CODE
  "execute_process(COMMAND echo \" fix \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION}/rtm-config\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION}/rtm-config) # basic
   execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION}/rtm-config) # basic
   ")


install(CODE
  "execute_process(COMMAND echo \"fix \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/openrtm-aist.pc path ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/openrtm-aist.pc) # basic
   execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/openrtm-aist.pc) # basic
")

add_rostest(test/test_openrtm_aist.test)