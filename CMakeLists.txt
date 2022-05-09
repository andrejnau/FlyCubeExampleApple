cmake_minimum_required(VERSION 3.15)
project(FlyCubeExampleApple)

set(CMAKE_CXX_STANDARD 17)
add_definitions(-DUSE_EXTERNAL_AUTORELEASEPOOL=1)
add_subdirectory(3rdparty/FlyCube)

list(APPEND headers
   Application/AAPLAppDelegate.h
   Application/AAPLConfig.h
   Application/AAPLView.h
   Application/AAPLViewController.h
   Renderer/AAPLRenderer.h
)

list(APPEND sources
   Application/AAPLAppDelegate.mm
   Application/AAPLView.mm
   Application/AAPLViewController.mm
   Application/main.mm
   Renderer/AAPLRenderer.mm
)

list(APPEND resources
   Renderer/PixelShader.spv
   Renderer/VertexShader.spv
)

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

add_executable(FlyCubeExampleApple MACOSX_BUNDLE
   ${headers}
   ${sources}
   ${resources}
)

target_include_directories(FlyCubeExampleApple PUBLIC
   Renderer
   Application
)

target_compile_options(FlyCubeExampleApple PUBLIC "-fobjc-arc")

target_link_libraries(FlyCubeExampleApple
   Instance
   "-framework Metal"
   "-framework QuartzCore"
)

if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
   target_compile_definitions(FlyCubeExampleApple PUBLIC -DTARGET_IOS=1)
   target_link_libraries(FlyCubeExampleApple "-framework UIKit")
   target_include_directories(FlyCubeExampleApple PUBLIC Application/UIKit)
   set_target_properties(FlyCubeExampleApple PROPERTIES
      MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Application/UIKit/iOS/Info.plist"
   )
elseif (CMAKE_SYSTEM_NAME STREQUAL "tvOS")
   target_compile_definitions(FlyCubeExampleApple PUBLIC -DTARGET_TVOS=1)
   target_link_libraries(FlyCubeExampleApple "-framework UIKit")
   target_include_directories(FlyCubeExampleApple PUBLIC Application/UIKit)
   set_target_properties(FlyCubeExampleApple PROPERTIES
      MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Application/UIKit/tvOS/Info.plist"
   )
else()
   target_compile_definitions(FlyCubeExampleApple PUBLIC -DTARGET_MACOS=1)
   target_link_libraries(FlyCubeExampleApple "-framework AppKit")
   target_include_directories(FlyCubeExampleApple PUBLIC Application/AppKit)
   set_target_properties(FlyCubeExampleApple PROPERTIES
      MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Application/AppKit/macOS/Info.plist"
   )
endif()
