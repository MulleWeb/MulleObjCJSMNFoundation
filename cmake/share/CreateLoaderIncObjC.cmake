### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

# can be included multiple times
# define OBJC_LOADER_INC
#        CREATE_OBJC_LOADER_INC
#        LIBRARY_NAME for multiple libraries
#

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

# this is the second part, the option is in DefineLoaderIncObjC.cmake

# need this outside of the if
if( NOT LIBRARY_NAME)
   set( LIBRARY_NAME "${PROJECT_NAME}")
endif()

if( NOT OBJC_LOADER_INC)
   set( OBJC_LOADER_INC "${CMAKE_CURRENT_SOURCE_DIR}/src/reflect/objc-loader.inc")
endif()

#
# tricky: this file can only be installed during link phase.
#         Used by optimization. For musl and cosmopolitan where we don't do
#         shared libraries, we can not produce this, but we can copy an
#         existing file.
if( LINK_PHASE)
   install( FILES "${OBJC_LOADER_INC}"
            DESTINATION "include/${LIBRARY_NAME}"
            OPTIONAL)
endif()


if( CREATE_OBJC_LOADER_INC)
   include( StringCase)

   if( NOT LIBRARY_IDENTIFIER)
      snakeCaseString( "${LIBRARY_NAME}" LIBRARY_IDENTIFIER)
   endif()
   if( NOT LIBRARY_UPCASE_IDENTIFIER)
      string( TOUPPER "${LIBRARY_IDENTIFIER}" LIBRARY_UPCASE_IDENTIFIER)
   endif()
   if( NOT LIBRARY_DOWNCASE_IDENTIFIER)
      string( TOLOWER "${LIBRARY_IDENTIFIER}" LIBRARY_DOWNCASE_IDENTIFIER)
   endif()

   #
   # Create src/objc-loader.inc for Objective-C projects. This contains a
   # list of all the classes and categories, contained in a library.
   #
   # runs in build dir
   if( NOT MULLE_OBJC_LOADER_TOOL)
      message( FATAL_ERROR "Executable \"mulle-objc-loader-tool\" not found")
   endif()


# installed "manually" below
#   # add to headers being installed, not part of project headers though
#   # because it is too late here
#   set( PUBLIC_HEADERS
#      ${PUBLIC_HEADERS}
#      ${OBJC_LOADER_INC}
#   )
   message( STATUS "OBJC_LOADER_INC is \"${OBJC_LOADER_INC}\"")

   if( INHERITED_OBJC_LOADERS)
     list( REMOVE_DUPLICATES INHERITED_OBJC_LOADERS)
   endif()

   message( STATUS "INHERITED_OBJC_LOADERS is \"${INHERITED_OBJC_LOADERS}\"")


   # The preferred way:
   #
   # _1_MulleObjCJSMNFoundation is an object library (a collection of files).
   # _2_MulleObjCJSMNFoundation is the loader with OBJC_LOADER_INC.
   #
   # Produce a static library _3_MulleObjCJSMNFoundation from _1_MulleObjCJSMNFoundation
   # to feed into MULLE_OBJC_LOADER_TOOL.
   #
   # The static library is, so that the commandline doesn't overflow for
   # many .o files.
   # In the end OBJC_LOADER_INC will be generated, which will be
   # included by the Loader.
   #
   if( TARGET "_2_${LIBRARY_NAME}")
      set( LIBRARY_STAGE3_TARGET "_3_${LIBRARY_NAME}")
      add_library( ${LIBRARY_STAGE3_TARGET} STATIC
         $<TARGET_OBJECTS:_1_${LIBRARY_NAME}>
      )
      set( OBJC_LOADER_LIBRARY "$<TARGET_FILE:${LIBRARY_STAGE3_TARGET}>")

      set_target_properties( ${LIBRARY_STAGE3_TARGET}
         PROPERTIES
            CXX_STANDARD 11
#            DEFINE_SYMBOL "${LIBRARY_UPCASE_IDENTIFIER}_SHARED_BUILD"
      )
      target_compile_definitions( ${LIBRARY_STAGE3_TARGET} PRIVATE "${LIBRARY_UPCASE_IDENTIFIER}_BUILD")

# installed "manually" below
#      set( STAGE2_HEADERS
#         ${STAGE2_HEADERS}
#         ${OBJC_LOADER_INC}
#      )
   else()
      if( TARGET "_1_${LIBRARY_NAME}")
         message( FATAL_ERROR "_1_${LIBRARY_NAME} is defined, but _2_${LIBRARY_NAME} is missing.
   Maybe MulleObjCLoader+${LIBRARY_NAME}.h not part of STAGE2_SOURCES ?
   Tip: Check if \"$ENV{PROJECT_SOURCE_DIR}/MulleObjCLoader+${LIBRARY_NAME}.m\" (sic) exists")
      endif()
      set( OBJC_LOADER_LIBRARY "$<TARGET_FILE:${LIBRARY_NAME}>")
   endif()

   #
   # on windows we lose the PATH due to the cmake windows bounce
   # therefore push this in via .bat
   #
   if( MSVC)
      set( TMP_MULLE_BIN_DIR "~/.mulle/${LIBRARY_NAME}.var/env/bin")
   else()
      set( TMP_MULLE_BIN_DIR "")
   endif()

   # TODO: $ENV{MULLE_OBJC_LOADER_TOOL_FLAGS} are implicitly double quote 
   # protected by cmake it seems, which trips up settings like "-vvv -ld" 
   add_custom_command(
      OUTPUT ${OBJC_LOADER_INC}
      COMMAND ${MULLE_OBJC_LOADER_TOOL}
                 $ENV{MULLE_OBJC_LOADER_TOOL_FLAGS}
                 -p "${TMP_MULLE_BIN_DIR}"
                 -c "${CMAKE_BUILD_TYPE}"
                 -o "${OBJC_LOADER_INC}"
                 ${OBJC_LOADER_LIBRARY}
                 ${INHERITED_OBJC_LOADERS}
      DEPENDS ${OBJC_LOADER_LIBRARY}
              ${ALL_LOAD_DEPENDENCY_LIBRARIES}
      COMMENT "Create: ${OBJC_LOADER_INC}"
      VERBATIM
   )

   #
   # if set to true, than a make clean/ninja clean removes it's
   # which we don't want... Doesn't help though...
   #
   # set_source_files_properties( "${OBJC_LOADER_INC}"
   #    PROPERTIES GENERATED FALSE
   # )

   add_custom_target( "${LIBRARY_NAME}__objc_loader_inc__"
      DEPENDS ${OBJC_LOADER_INC}
      COMMENT "Target to build \"${OBJC_LOADER_INC}\""
   )

   if( TARGET "_2_${LIBRARY_NAME}")
      add_dependencies( "_2_${LIBRARY_NAME}" "${LIBRARY_NAME}__objc_loader_inc__")
   else()
      add_dependencies( "${LIBRARY_NAME}" "${LIBRARY_NAME}__objc_loader_inc__")
   endif()

   # seemingly needed
   foreach( TMP_STAGE2_SOURCE in STAGE2_SOURCES)
      set_property( SOURCE ${TMP_STAGE2_SOURCE} APPEND PROPERTY OBJECT_DEPENDS ${OBJC_LOADER_INC})
   endforeach()

endif()

include( CreateLoaderIncAuxObjC OPTIONAL)
