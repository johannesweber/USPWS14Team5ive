#########################
# .gitignore file for Xcode4 and Xcode5 Source projects
#
# Apple bugs, waiting for Apple to fix/respond:
#
#    15564624 - what does the xccheckout file in Xcode5 do? Where's the documentation?
#
# Version 2.3
# For latest version, see: http://stackoverflow.com/questions/49478/git-ignore-file-for-xcode-projects
#
# 2014 updates:
# - appended non-standard items DISABLED by default (uncomment if you use those tools)
# - removed the edit that an SO.com moderator made without bothering to ask me
# - researched CocoaPods .lock more carefully, thanks to Gokhan Celiker
# 2013 updates:
# - fixed the broken "save personal Schemes"
# - added line-by-line explanations for EVERYTHING (some were missing)
#
# NB: if you are storing "built" products, this WILL NOT WORK,
# and you should use a different .gitignore (or none at all)
# This file is for SOURCE projects, where there are many extra
# files that we want to exclude
#
#########################
 
#####
# OS X temporary files that should never be committed
#
# c.f. http://www.westwind.com/reference/os-x/invisibles.html
 
.DS_Store
 
# c.f. http://www.westwind.com/reference/os-x/invisibles.html
 
.Trashes
 
# c.f. http://www.westwind.com/reference/os-x/invisibles.html
 
*.swp
 
#
# *.lock - this is used and abused by many editors for many different things.
#    For the main ones I use (e.g. Eclipse), it should be excluded 
#    from source-control, but YMMV.
#   (lock files are usually local-only file-synchronization on the local FS that should NOT go in git)
# c.f. the "OPTIONAL" section at bottom though, for tool-specific variations!
 
*.lock
 
 
#
# profile - REMOVED temporarily (on double-checking, I can't find it in OS X docs?)
#profile
 
 
####
# Xcode temporary files that should never be committed
# 
# NB: NIB/XIB files still exist even on Storyboard projects, so we want this...
 
*~.nib
 
 
####
# Xcode build files -
#
# NB: slash on the end, so we only remove the FOLDER, not any files that were badly named "DerivedData"
 
DerivedData/
 
# NB: slash on the end, so we only remove the FOLDER, not any files that were badly named "build"
 
build/
 
 
#####
# Xcode private settings (window sizes, bookmarks, breakpoints, custom executables, smart groups)
#
# This is complicated:
#
# SOMETIMES you need to put this file in version control.
# Apple designed it poorly - if you use "custom executables", they are
#  saved in this file.
# 99% of projects do NOT use those, so they do NOT want to version control this file.
#  ..but if you're in the 1%, comment out the line "*.pbxuser"
 
# .pbxuser: http://lists.apple.com/archives/xcode-users/2004/Jan/msg00193.html
 
*.pbxuser
 
# .mode1v3: http://lists.apple.com/archives/xcode-users/2007/Oct/msg00465.html
 
*.mode1v3
 
# .mode2v3: http://lists.apple.com/archives/xcode-users/2007/Oct/msg00465.html
 
*.mode2v3
 
# .perspectivev3: http://stackoverflow.com/questions/5223297/xcode-projects-what-is-a-perspectivev3-file
 
*.perspectivev3
 
#    NB: also, whitelist the default ones, some projects need to use these
!default.pbxuser
!default.mode1v3
!default.mode2v3
!default.perspectivev3
 
 
####
# Xcode 4 - semi-personal settings
#
#
# OPTION 1: ---------------------------------
#     throw away ALL personal settings (including custom schemes!
#     - unless they are "shared")
#
# NB: this is exclusive with OPTION 2 below
xcuserdata
 
# OPTION 2: ---------------------------------
#     get rid of ALL personal settings, but KEEP SOME OF THEM
#     - NB: you must manually uncomment the bits you want to keep
#
# NB: this *requires* git v1.8.2 or above; you may need to upgrade to latest OS X,
#    or manually install git over the top of the OS X version
# NB: this is exclusive with OPTION 1 above
#
#xcuserdata/**/*
 
#     (requires option 2 above): Personal Schemes
#
#!xcuserdata/**/xcschemes/*
 
####
# XCode 4 workspaces - more detailed
#
# Workspaces are important! They are a core feature of Xcode - don't exclude them :)
#
# Workspace layout is quite spammy. For reference:
#
# /(root)/
#   /(project-name).xcodeproj/
#     project.pbxproj
#     /project.xcworkspace/
#       contents.xcworkspacedata
#       /xcuserdata/
#         /(your name)/xcuserdatad/
#           UserInterfaceState.xcuserstate
#     /xcsshareddata/
#       /xcschemes/
#         (shared scheme name).xcscheme
#     /xcuserdata/
#       /(your name)/xcuserdatad/
#         (private scheme).xcscheme
#         xcschememanagement.plist
#
#
 
####
# Xcode 4 - Deprecated classes
#
# Allegedly, if you manually "deprecate" your classes, they get moved here.
#
# We're using source-control, so this is a "feature" that we do not want!
 
*.moved-aside
 
####
# OPTIONAL: Some well-known tools that people use side-by-side with Xcode / iOS development
#
# NB: I'd rather not include these here, but gitignore's design is weak and doesn't allow
#     modular gitignore: you have to put EVERYTHING in one file.
#
# COCOAPODS:
#
# c.f. http://guides.cocoapods.org/using/using-cocoapods.html#what-is-a-podfilelock
# c.f. http://guides.cocoapods.org/using/using-cocoapods.html#should-i-ignore-the-pods-directory-in-source-control
#
#!Podfile.lock
#
# RUBY:
#
# c.f. http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/
#
#!Gemfile.lock
#
# IDEA:
#
#.idea
#
# TEXTMATE:
#
# -- UNVERIFIED: c.f. http://stackoverflow.com/a/50283/153422
#
#tm_build_errors
 
####
# UNKNOWN: recommended by others, but I can't discover what these files are
#
# Community suggestions (unverified, no evidence available - DISABLED by default)
#
# 1. Xcode 5 - VCS file
#
# "The data in this file not represent state of your project.
# If you'll leave this file in git - you will have merge conflicts during 
# pull your cahnges to other's repo"
#
#*.xccheckout
