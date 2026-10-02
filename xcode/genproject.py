#!/usr/bin/env python
# genproject.py - writes TubeFixLegacy.xcodeproj (Xcode 4.6 format,
# objectVersion 46) listing the project's sources in the navigator and one
# aggregate target, "TubeFixLegacy", whose only build phase runs
# xcode/build.sh. Re-run after adding or removing files:
#     python xcode/genproject.py
# Works with Python 2.7 and 3.x.

import hashlib
import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
NAME = 'TubeFixLegacy'

# directories shown file by file (anything else listed below is a folder reference)
EXPANDED_DIRS = ['googleapp', 'classic', 'common', 'common-google', 'base64', 'preferences', 'xcode']
SKIP_DIRS = set(['srcheaders', 'generated', 'logos', 'proto', '.theos', 'build', 'packages', '.git'])
FOLDER_REFS = ['layout', 'lib', 'googleapp/srcheaders', 'common/SABR/proto', 'xcode/logos', 'xcode/generated']
TOP_FILES = ['README.md', 'control', 'Makefile', 'LICENSE', 'NOTES.md']
SOURCE_EXT = ('.x', '.xm', '.m', '.mm', '.c', '.h', '.plist', '.js', '.html', '.png', '.sh', '.py', '.txt', '.md', '.pch', 'Makefile')

FILE_TYPES = {
    '.m': 'sourcecode.c.objc', '.x': 'sourcecode.c.objc', '.mm': 'sourcecode.cpp.objcpp', '.xm': 'sourcecode.cpp.objcpp',
    '.c': 'sourcecode.c.c', '.h': 'sourcecode.c.h', '.plist': 'text.plist.xml', '.js': 'sourcecode.javascript',
    '.html': 'text.html', '.png': 'image.png', '.sh': 'text.script.sh', '.py': 'text.script.python',
    '.txt': 'text', '.md': 'net.daringfireball.markdown', '.pch': 'sourcecode.c.h',
}

objects = {}


def oid(*parts):
    return hashlib.md5('/'.join(parts).encode('utf-8')).hexdigest()[:24].upper()


def q(value):
    return '"%s"' % str(value).replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')


def file_ref(relpath):
    key = oid('file', relpath)
    name = os.path.basename(relpath)
    ext = os.path.splitext(name)[1] if name != 'Makefile' else ''
    ftype = FILE_TYPES.get(ext, 'text')
    kind = 'explicitFileType' if ext in ('.x', '.xm') else 'lastKnownFileType'
    objects[key] = '{isa = PBXFileReference; %s = %s; path = %s; sourceTree = "<group>"; }' % (kind, q(ftype), q(name))
    return key


def folder_ref(relpath):
    key = oid('folder', relpath)
    objects[key] = '{isa = PBXFileReference; lastKnownFileType = folder; path = %s; sourceTree = "<group>"; }' % q(os.path.basename(relpath))
    return key


def group(relpath, name=None):
    key = oid('group', relpath)
    children = []
    full = os.path.join(ROOT, relpath)
    entries = sorted(os.listdir(full), key=lambda s: s.lower())
    for entry in entries:
        rel = os.path.join(relpath, entry)
        if entry.startswith('.'):
            continue
        if rel in FOLDER_REFS:
            children.append(folder_ref(rel))
        elif os.path.isdir(os.path.join(ROOT, rel)):
            if entry in SKIP_DIRS:
                continue
            children.append(group(rel))
        elif entry.endswith(SOURCE_EXT) and not entry.endswith('signinpolyfil.h'):
            children.append(file_ref(rel))
    objects[key] = '{isa = PBXGroup; children = (%s); %spath = %s; sourceTree = "<group>"; }' % (
        ''.join(c + ', ' for c in children), ('name = %s; ' % q(name)) if name else '', q(os.path.basename(relpath)))
    return key


def main():
    main_children = [file_ref(f) for f in TOP_FILES if os.path.exists(os.path.join(ROOT, f))]
    for d in EXPANDED_DIRS:
        main_children.append(group(d))
    for d in ('layout', 'lib'):
        main_children.append(folder_ref(d))
    main_group = oid('group', '<main>')
    objects[main_group] = '{isa = PBXGroup; children = (%s); sourceTree = "<group>"; }' % ''.join(c + ', ' for c in main_children)

    script = ('# builds all three binaries for armv7 + armv7s and packs the .deb into ./packages\n'
              '/bin/bash "$PROJECT_DIR/xcode/build.sh"\n')
    phase = oid('phase', 'build')
    objects[phase] = ('{isa = PBXShellScriptBuildPhase; buildActionMask = 2147483647; files = (); inputPaths = (); '
                      'name = %s; outputPaths = (); runOnlyForDeploymentPostprocessing = 0; shellPath = /bin/bash; '
                      'shellScript = %s; showEnvVarsInLog = 0; }') % (q('Build TubeFixLegacy .deb'), q(script))

    settings = ('ARCHS = "armv7 armv7s"; IPHONEOS_DEPLOYMENT_TARGET = 5.0; SDKROOT = iphoneos; '
                'PRODUCT_NAME = %s; SUPPORTED_PLATFORMS = iphoneos; ' % q(NAME))
    target_configs = []
    project_configs = []
    for conf in ('Debug', 'Release'):
        t = oid('tconf', conf)
        objects[t] = '{isa = XCBuildConfiguration; buildSettings = {%s}; name = %s; }' % (settings, conf)
        target_configs.append(t)
        p = oid('pconf', conf)
        objects[p] = '{isa = XCBuildConfiguration; buildSettings = {%s}; name = %s; }' % (settings, conf)
        project_configs.append(p)
    tlist = oid('tconflist')
    objects[tlist] = '{isa = XCConfigurationList; buildConfigurations = (%s); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }' % ''.join(c + ', ' for c in target_configs)
    plist_ = oid('pconflist')
    objects[plist_] = '{isa = XCConfigurationList; buildConfigurations = (%s); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }' % ''.join(c + ', ' for c in project_configs)

    target = oid('target', NAME)
    objects[target] = ('{isa = PBXAggregateTarget; buildConfigurationList = %s; buildPhases = (%s, ); dependencies = (); '
                       'name = %s; productName = %s; }') % (tlist, phase, q(NAME), q(NAME))

    project = oid('project')
    objects[project] = ('{isa = PBXProject; attributes = {LastUpgradeCheck = 0460; ORGANIZATIONNAME = "LegacyReborn Project"; }; '
                        'buildConfigurationList = %s; compatibilityVersion = "Xcode 3.2"; developmentRegion = English; '
                        'hasScannedForEncodings = 0; knownRegions = (en, ); mainGroup = %s; projectDirPath = ""; '
                        'projectRoot = ""; targets = (%s, ); }') % (plist_, main_group, target)

    out_dir = os.path.join(ROOT, NAME + '.xcodeproj')
    if not os.path.isdir(out_dir):
        os.makedirs(out_dir)
    lines = ['// !$*UTF8*$!', '{', '\tarchiveVersion = 1;', '\tclasses = {', '\t};', '\tobjectVersion = 46;', '\tobjects = {', '']
    for key in sorted(objects):
        lines.append('\t\t%s = %s;' % (key, objects[key]))
    lines += ['\t};', '\trootObject = %s;' % project, '}', '']
    open(os.path.join(out_dir, 'project.pbxproj'), 'w').write('\n'.join(lines))

    # shared scheme, so the target shows up ready to build on "iOS Device"
    scheme_dir = os.path.join(out_dir, 'xcshareddata', 'xcschemes')
    if not os.path.isdir(scheme_dir):
        os.makedirs(scheme_dir)
    ref = ('<BuildableReference BuildableIdentifier = "primary" BlueprintIdentifier = "%s" BuildableName = "%s" '
           'BlueprintName = "%s" ReferencedContainer = "container:%s.xcodeproj"></BuildableReference>') % (target, NAME, NAME, NAME)
    scheme = '''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion = "0460" version = "1.3">
   <BuildAction parallelizeBuildables = "YES" buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry buildForTesting = "YES" buildForRunning = "YES" buildForProfiling = "YES" buildForArchiving = "YES" buildForAnalyzing = "YES">
            %s
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv = "YES" buildConfiguration = "Debug">
      <Testables></Testables>
   </TestAction>
   <LaunchAction selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" launchStyle = "0" useCustomWorkingDirectory = "NO" buildConfiguration = "Release" ignoresPersistentStateOnLaunch = "NO" debugDocumentVersioning = "YES" allowLocationSimulation = "YES">
      <AdditionalOptions></AdditionalOptions>
   </LaunchAction>
   <ProfileAction shouldUseLaunchSchemeArgsEnv = "YES" savedToolIdentifier = "" useCustomWorkingDirectory = "NO" buildConfiguration = "Release" debugDocumentVersioning = "YES"></ProfileAction>
   <AnalyzeAction buildConfiguration = "Release"></AnalyzeAction>
   <ArchiveAction buildConfiguration = "Release" revealArchiveInOrganizer = "YES"></ArchiveAction>
</Scheme>
''' % ref
    open(os.path.join(scheme_dir, NAME + '.xcscheme'), 'w').write(scheme)
    print('wrote %s (%d objects)' % (out_dir, len(objects)))


if __name__ == '__main__':
    main()
