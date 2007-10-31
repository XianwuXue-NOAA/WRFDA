dnl
dnl Definitions for creating shared libraries
dnl
dnl The purpose of these definitions is to provide common support for 
dnl shared libraries, with *or without* the use of the GNU Libtool package.
dnl For many of our important platforms, the Libtool approach is overkill,
dnl and can be particularly painful for developers.
dnl
dnl To use libtool, you need macros that are defined by libtool for libtool
dnl Don't even think about the consequences of this for updating and for
dnl using user-versions of libtool :(
dnl 
dnl !!!!!!!!!!!!!!!!!!!!!
dnl libtool requires ac 2.50 !!!!!!!!!!!!!!!!!
dnl 
dnl builtin(include,libtool.m4)
dnl
dnl/*D
dnl PAC_ARG_SHAREDLIBS - Add --enable-sharedlibs=kind to configure.
dnl 
dnl Synopsis:
dnl PAC_ARG_SHAREDLIBS
dnl
dnl Output effects:
dnl Adds '--enable-sharedlibs=kind' to the command line.  If this is enabled,
dnl then based on the value of 'kind', programs are selected for the 
dnl names 'CC_SHL' and 'CC_LINK_SHL' that configure will substitute for in
dnl 'Makefile.in's.  These symbols are generated by 'simplemake' when
dnl shared library support is selected.
dnl The variable 'C_LINKPATH_SHL' is set to the option to specify the 
dnl path to search at runtime for libraries (-rpath in gcc/GNU ld).
dnl The variable 'SHLIB_EXT' is set to the extension used by shared 
dnl libraries; under most forms of Unix, this is 'so'; under Mac OS/X, this
dnl is 'dylib', and under Windows (including cygwin), this is 'dll'.
dnl
dnl Supported values of 'kind' include \:
dnl+    gcc - Use gcc to create both shared objects and libraries
dnl.    osx-gcc - Use gcc on Mac OS/X to create both shared objects and
dnl               libraries
dnl.    solaris-cc - Use native Solaris cc to create shared objects and 
dnl               libraries
dnl.    cygwin-gcc - Use gcc on Cygwin to create shared objects and libraries
dnl-    none - The same as '--disable-sharedlibs'
dnl
dnl Others will be added as experience dictates.  Likely names are
dnl + libtool - For general GNU libtool
dnl - linux-pgcc - For Portland group under Linux
dnl
dnl Notes:
dnl Shared libraries are only partially implemented.  Additional symbols
dnl will probably be defined, including symbols to specify how shared library
dnl search paths are specified and how shared library names are set.
dnl D*/
AC_DEFUN(PAC_ARG_SHAREDLIBS,[
AC_ARG_ENABLE(sharedlibs,
[--enable-sharedlibs=kind - Enable shared libraries.  kind may be
    gcc     - Standard gcc and GNU ld options for creating shared libraries
    osx-gcc - Special options for gcc needed only on OS/X
    solaris-cc - Solaris native (SPARC) compilers for 32 bit systems
    cygwin-gcc - Special options for gcc needed only for cygwin
    none    - same as --disable-sharedlibs
Only gcc, osx-gcc, and solaris-cc are currently supported],
,enable_sharedlibs=none;enable_shared=no)
dnl
CC_SHL=true
C_LINK_SHL=true
SHLIB_EXT=unknown
SHLIB_FROM_LO=no
SHLIB_INSTALL='$(INSTALL_PROGRAM)'
case "$enable_sharedlibs" in 
    no|none)
    ;;
    gcc-osx|osx-gcc)
    AC_MSG_RESULT([Creating shared libraries using GNU for Mac OSX])
    C_LINK_SHL='${CC} -dynamiclib -undefined suppress -single_module -flat_namespace'
    CC_SHL='${CC} -fPIC'
    # No way in osx to specify the location of the shared libraries at link
    # time (see the code in createshlib in mpich2/src/util)
    C_LINKPATH_SHL=""
    SHLIB_EXT="dylib"
    enable_sharedlibs="osx-gcc"
    ;;
    gcc)
    AC_MSG_RESULT([Creating shared libraries using GNU])
    # Not quite right yet.  See mpich/util/makesharedlib
    # Use syntax that works in both Make and the shell
    #C_LINK_SHL='${CC} -shared -Wl,-r'
    C_LINK_SHL='${CC} -shared'
    # For example, include the libname as ${LIBNAME_SHL}
    #C_LINK_SHL='${CC} -shared -Wl,-h,<finallibname>'
    # May need -fPIC 
    CC_SHL='${CC} -fpic'
    C_LINKPATH_SHL="-Wl,-rpath -Wl,"
    SHLIB_EXT=so
    # We need to test that this isn't osx.  The following is a 
    # simple hack
    osname=`uname -s`
    case $osname in 
        *Darwin*|*darwin*)
	AC_MSG_ERROR([You must specify --enable-sharedlibs=osx-gcc for Mac OS/X])
        ;;	
        *CYGWIN*|*cygwin*)
	AC_MSG_ERROR([You must specify --enable-sharedlibs=cygwin-gcc for Cygwin])
	;;
	*SunOS*)
	AC_MSG_ERROR([You must specify --enable-sharedlibs=solaris-gcc for Solaris with gcc])
	;;
    esac
    ;;

    cygwin|cygwin-gcc|gcc-cygwin)
    AC_MSG_RESULT([Creating shared libraries using GNU under CYGWIN])
    C_LINK_SHL='${CC} -shared'
    CC_SHL='${CC}'
    # DLL Libraries need to be in the user's path (!)
    C_LINKPATH_SHL=""
    SHLIB_EXT="dll"
    enable_sharedlibs="cygwin-gcc"
    ;;	

    libtool)
    AC_MSG_ERROR([Creating shared libraries using libtool not yet supported])
dnl     dnl Using libtool requires a heavy-weight process to test for 
dnl     dnl various stuff that libtool needs.  Without this, you'll get a
dnl     dnl bizarre error message about libtool being unable to find
dnl     dnl configure.in or configure.ac (!)
dnl     AC_PROG_LIBTOOL
dnl     # Likely to be
dnl     # either CC or CC_SHL is libtool $cc
dnl     CC_SHL='${LIBTOOL} --mode=compile ${CC}'
dnl     # CC_LINK_SHL includes the final installation path
dnl     # For many systems, the link may need to include *all* libraries
dnl     # (since many systems don't allow any unsatisfied dependencies)
dnl     # We need to give libtool the .lo file, not the .o files
dnl     SHLIB_FROM_LO=yes
dnl     # We also need to add -no-undefined when the compiler is gcc and
dnl     # we are building under cygwin
dnl     sysname=`uname -s | tr abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ`
dnl     isCygwin=no
dnl     case "$sysname" in 
dnl 	*CYGWIN*) isCygwin=yes;;
dnl     esac
dnl     if test "$isCygwin" = yes ; then
dnl         C_LINK_SHL='${LIBTOOL} --mode=link ${CC} -no-undefined -rpath ${libdir}'
dnl     else
dnl         C_LINK_SHL='${LIBTOOL} --mode=link ${CC} -rpath ${libdir}'
dnl     fi
dnl     C_LINKPATH_SHL="-rpath "
dnl     # We also need a special install process with libtool.  Note that this
dnl     # will also install the static libraries
dnl     SHLIB_INSTALL='$(LIBTOOL) --mode=install $(INSTALL_PROGRAM)'
dnl     # Note we may still need to add
dnl     #'$(LIBTOOL) --mode=finish $(libdir)'
    ;;
dnl
dnl Other, such as solaris-cc
    solaris|solaris-cc)
    AC_MSG_RESULT([Creating shared libraries using Solaris])
    # pic32 is appropriate for both 32 and 64 bit Solaris
    C_LINK_SHL='${CC} -G -xcode=pic32'
    CC_SHL='${CC} -xcode=pic32'
    C_LINKPATH_SHL="-R"
    SHLIB_EXT=so
    enable_sharedlibs="solaris-cc"
    ;;

    solaris-gcc)
    # This is the same as gcc, except for the C_LINKPATH_SHL
    AC_MSG_RESULT([Creating shared libraries using Solaris with gcc])
    C_LINK_SHL='${CC} -shared'
    CC_SHL='${CC} -fPIC'
    C_LINKPATH_SHL="-R"
    SHLIB_EXT=so
    enable_sharedlibs="solaris-gcc"
    ;;

    linuxppc-xlc)
    # This is only the beginning of xlc support, thanks to andy@vpac.org
    CC_SHL='${CC} -qmkshrobj'
    C_LINKPATH_SHL="-Wl,-rpath -Wl,"
    C_LINK_SHL='${CC} -shared -qmkshrobj'
    SHLIB_EXT=so
    # Note that the full line should be more like
    # $CLINKER -shared -qmkshrobj -Wl,-h,$libbase.$slsuffix -o ../shared/$libbase.$slsuffix *.o $OtherLibs
    # for the appropriate values of $libbase and $slsuffix
    # The -h name sets the name of the object; this is necessary to
    # ensure that the dynamic linker can find the proper shared library.
    ;;

    *)
    AC_MSG_ERROR([Unknown value $enable_sharedlibs for enable-sharedlibs.  Values should be gcc or osx-gcc])
    enable_sharedlibs=no
    ;;  
esac
# Check for the shared-library extension
PAC_CC_SHLIB_EXT
dnl
AC_SUBST(CC_SHL)
AC_SUBST(C_LINK_SHL)
AC_SUBST(C_LINKPATH_SHL)
AC_SUBST(SHLIB_EXT)
AC_SUBST(SHLIB_FROM_LO)
AC_SUBST(SHLIB_INSTALL)
])

dnl /*D
dnl PAC_xx_SHAREDLIBS - Get compiler and linker for shared libraries
dnl These routines may be used to determine the compiler and the
dnl linker to be used in creating shared libraries
dnl Rather than set predefined variable names, they set an argument 
dnl (if provided)
dnl
dnl Synopsis
dnl PAC_CC_SHAREDLIBS(type,CCvar,CLINKvar)
dnl D*/
AC_DEFUN(PAC_CC_SHAREDLIBS,
[
pac_kinds=$1
ifelse($1,,[
    pac_prog=""
    AC_CHECK_PROG(pac_prog,gcc,yes,no)
    if test "$pac_prog" = yes ; then pac_kinds=gcc ; fi
    pac_prog=""
    AC_CHECK_PROG(pac_prog,libtool,yes,no)
    if test "$pac_prog" = yes ; then pac_kinds="$pac_kinds libtool" ; fi
])
for pac_arg in $pac_kinds ; do
    case $pac_arg in 
    gcc)
    # For example, include the libname as ${LIBNAME_SHL}
    #C_LINK_SHL='${CC} -shared -Wl,-h,<finallibname>'
    pac_cc_sharedlibs='gcc -shared -fpic'
    pac_clink_sharedlibs='gcc -shared'
    ;;
    libtool)
    AC_CHECK_PROGS(LIBTOOL,libtool,false)
    if test "$LIBTOOL" = "false" ; then
	AC_MSG_WARN([Could not find libtool])
    else
        # Likely to be
        # either CC or CC_SHL is libtool $cc
        pac_cc_sharedlibs'${LIBTOOL} -mode=compile ${CC}'
        pac_clink_sharedlibs='${LIBTOOL} -mode=link ${CC} -rpath ${libdir}'
    fi
    ;;
    *)
    ;;
    esac
    if test -n "$pac_cc_sharedlibs" ; then break ; fi
done
if test -z "$pac_cc_sharedlibs" ; then pac_cc_sharedlibs=true ; fi
if test -z "$pac_clink_sharedlibs" ; then pac_clink_sharedlibs=true ; fi
ifelse($2,,CC_SHL=$pac_cc_sharedlibs,$2=$pac_cc_sharedlibs)
ifelse($3,,C_LINK_SHL=$pac_clink_sharedlibs,$3=$pac_clink_sharedlibs)
])
dnl
dnl
dnl This macro ensures that all of the necessary substitutions are 
dnl made by any subdirectory configure (which may simply SUBST the
dnl necessary values rather than trying to determine them from scratch)
dnl This is a more robust (and, in the case of libtool, only 
dnl managable) method.
AC_DEFUN(PAC_CC_SUBDIR_SHLIBS,[
	AC_SUBST(CC_SHL)
        AC_SUBST(C_LINK_SHL)
        AC_SUBST(LIBTOOL)
        AC_SUBST(ENABLE_SHLIB)
	if test "$ENABLE_SHLIB" = "libtool" ; then
	    if test -z "$LIBTOOL" ; then
		AC_MSG_WARN([libtool selected for shared library support but LIBTOOL is not defined])
            fi
	fi
])
dnl
dnl
dnl PAC_CC_SHLIB_EXT - get the extension for shared libraries
dnl Set the variable SHLIB_EXT if it is other than unknown.
dnl
AC_DEFUN([PAC_CC_SHLIB_EXT],[
# Not all systems use .so as the extension for shared libraries (cygwin
# and OSX are two important examples).  If we did not set the SHLIB_EXT,
# then try and determine it.  We need this to properly implement
# clean steps that look for libfoo.$SHLIB_EXT .
if test "$SHLIB_EXT" = "unknown" ; then
    osname=`uname -s`
    case $osname in 
        *Darwin*|*darwin*) SHLIB_EXT=dylib
        ;;	
        *CYGWIN*|*cygwin*) SHLIB_EXT=dll
        ;;
	*Linux*|*LINUX*|*SunOS*) SHLIB_EXT=so
	;;
   esac
fi
])
