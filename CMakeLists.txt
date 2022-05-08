cmake_minimum_required(VERSION 3.15)
project(CustomMetalViewCMake)

list(APPEND headers
   Application/AAPLAppDelegate.h
   Application/AAPLConfig.h
   Application/AAPLView.h
   Application/AAPLViewController.h
   Renderer/AAPLRenderer.h
   Renderer/AAPLShaderTypes.h
)

list(APPEND sources
   Application/AAPLAppDelegate.mm
   Application/AAPLView.mm
   Application/AAPLViewController.mm
   Application/main.mm
   Renderer/AAPLRenderer.mm
)

list(APPEND shaders
   Renderer/AAPLShaders.metal
)
set_source_files_properties(${shaders} PROPERTIES LANGUAGE METAL)

if (CMAKE_SYSTEM_NAME STREQUAL "iOS" OR CMAKE_SYSTEM_NAME STREQUAL "tvOS")
   list(APPEND sources
      Application/UIKit/AAPLUIView.mm
   )
else()
   list(APPEND sources
      Application/AppKit/AAPLNSView.mm
   )
endif()

if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
   list(APPEND resources
      Application/UIKit/iOS/Base.lproj/Main.storyboard
   )
elseif (CMAKE_SYSTEM_NAME STREQUAL "tvOS")
   list(APPEND resources
      Application/UIKit/tvOS/Base.lproj/Main.storyboard
   )
else()
   list(APPEND resources
      Application/AppKit/macOS/Base.lproj/Main.storyboard
   )
endif()

set_source_files_properties(${resources} PROPERTIES
   MACOSX_PACKAGE_LOCATION Resources
)

add_executable(CustomMetalViewCMake MACOSX_BUNDLE
   ${headers}
   ${sources}
   ${shaders}
   ${resources}
)

target_include_directories(CustomMetalViewCMake PUBLIC
   Renderer
   Application
)

target_compile_options(CustomMetalViewCMake PUBLIC "-fobjc-arc")

target_link_libraries(CustomMetalViewCMake
   "-framework Metal"
   "-framework QuartzCore"
)

if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
   target_compile_definitions(CustomMetalViewCMake PUBLIC -DTARGET_IOS=1)
   target_link_libraries(CustomMetalViewCMake "-framework UIKit")
   target_include_directories(CustomMetalViewCMake PUBLIC Application/UIKit)
   set_target_properties(CustomMetalViewCMake PROPERTIES
      MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Application/UIKit/iOS/Info.plist"
   )
elseif (CMAKE_SYSTEM_NAME STREQUAL "tvOS")
   target_compile_definitions(CustomMetalViewCMake PUBLIC -DTARGET_TVOS=1)
   target_link_libraries(CustomMetalViewCMake "-framework UIKit")
   target_include_directories(CustomMetalViewCMake PUBLIC Application/UIKit)
   set_target_properties(CustomMetalViewCMake PROPERTIES
      MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Application/UIKit/tvOS/Info.plist"
   )
else()
   target_compile_definitions(CustomMetalViewCMake PUBLIC -DTARGET_MACOS=1)
   target_link_libraries(CustomMetalViewCMake "-framework AppKit")
   target_include_directories(CustomMetalViewCMake PUBLIC Application/AppKit)
   set_target_properties(CustomMetalViewCMake PROPERTIES
      MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Application/AppKit/macOS/Info.plist"
   )
endif()
