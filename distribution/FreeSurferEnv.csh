#############################################################################
# Name:    FreeSurferEnv.csh
# Purpose: Setup the environment to run FreeSurfer/FS-FAST (and FSL)
# Usage:   See help section below  
#
# $Id: FreeSurferEnv.csh,v 1.18 2005/07/12 21:45:20 nicks Exp $
#############################################################################

set VERSION = '$Id: FreeSurferEnv.csh,v 1.18 2005/07/12 21:45:20 nicks Exp $'

## Print help if --help or -help is specified
if (("$1" == "--help") || ("$1" == "-help")) then
    echo "FreeSurferEnv.csh"
    echo ""
    echo "Purpose: Setup the environment to run FreeSurfer and FS-FAST"
    echo ""
    echo "Usage:"
    echo ""
    echo "1. Create an environment variable called FREESURFER_HOME and"
    echo "   set it to the directory in which FreeSurfer is installed."
    echo "2. From a csh or tcsh shell or (.login): "
    echo '       source $FREESURFER_HOME/FreeSurferEnv.csh'
    echo "3. There are environment variables that should point to locations"
    echo "   of software or data used by FreeSurfer. If set prior to"
    echo "   sourcing, they will not be changed, but will otherwise be"
    echo "   set to default locations:"
    echo "       FSFAST_HOME"
    echo "       SUBJECTS_DIR"
    echo "       FUNCTIONALS_DIR"
    echo "       MINC_BIN_DIR"
    echo "       MINC_LIB_DIR"
    echo "       FSL_DIR"
    echo "4. If NO_MINC is set (to anything), "
    echo "   then all the MINC stuff is ignored."
    echo "5. If NO_FSFAST is set (to anything), "
    echo "   then the startup.m stuff is ignored."
    echo "6. The script will print the final settings for the above "
    echo "   variables as well as any warnings about missing directories."
    echo "   If FS_FREESURFERENV_NO_OUTPUT is set, then no normal output"
    echo "   will be made (only error messages)."
    echo ""
    echo "The most convenient way to use this script is to write another"
    echo "script that sets FREESURFER_HOME and possibly SUBJECTS_DIR for"
    echo "your set-up, as well as NO_MINC, NO_FSFAST, or"
    echo "FS_FREESURFERENV_NO_OUTPUT as appropriate, and then source this"
    echo "script.  See SetUpFreeSurfer.csh for an example."
    exit 0;
endif

## Get the name of the operating system
set os = `uname -s`
setenv OS $os

## Set this environment variable to suppress the output.
if( $?FS_FREESURFERENV_NO_OUTPUT ) then
    set output = 0
else
    set output = 1
endif
if($?USER == 0 || $?prompt == 0) then
    set output = 0
endif

if( $output ) then
    echo "Setting up environment for FreeSurfer/FS-FAST (and FSL)"
    if (("$1" == "--version") || \
        ("$1" == "--V") || \
        ("$1" == "-V") || \
        ("$1" == "-v")) then
        echo $VERSION
    endif
endif

## Check if FREESURFER_HOME variable exists, then check if the actual
## directory exists.
if(! $?FREESURFER_HOME) then
    echo "ERROR: environment variable FREESURFER_HOME is not defined"
    echo "       Run the command 'setenv FREESURFER_HOME <FreeSurferHome>'"
    echo "       where <FreeSurferHome> is the directory where FreeSurfer"
    echo "       is installed."
    exit 1;
endif

if(! -e $FREESURFER_HOME) then
    echo "ERROR: $FREESURFER_HOME "
    echo "       does not exist. Check that this value is correct.";
    exit 1;
endif

## Now we'll set directory locations based on FREESURFER_HOME for use
## by other programs and scripts.

## Set up the path. They should probably already have one, but set a
## basic one just in case they don't. Then add one with all the
## directories we just set.  Additions are made along the way in this
## script.
if(! $?path ) then
    set path = ( ~/bin /bin /usr/bin /usr/local/bin )
endif

## If FS_OVERRIDE is set, this script will automatically assign
## defaults to all locations. Otherwise, it will only do so if the
## variable isn't already set
if(! $?FS_OVERRIDE) then
    setenv FS_OVERRIDE 0
endif

if(! $?FSFAST_HOME || $FS_OVERRIDE) then
    setenv FSFAST_HOME $FREESURFER_HOME/fsfast
endif

if(! $?SUBJECTS_DIR  || $FS_OVERRIDE) then
    setenv SUBJECTS_DIR $FREESURFER_HOME/subjects
endif

if(! $?FUNCTIONALS_DIR  || $FS_OVERRIDE) then
    setenv FUNCTIONALS_DIR $FREESURFER_HOME/sessions
endif

if((! $?NO_MINC) && (! $?MINC_BIN_DIR  || $FS_OVERRIDE)) then
    # try to find minc toolkit binaries
    if ( $?MNI_INSTALL_DIR) then
        setenv MINC_BIN_DIR $MNI_INSTALL_DIR/bin
    else if ( -e $FREESURFER_HOME/lib/mni/bin) then
        setenv MINC_BIN_DIR $FREESURFER_HOME/lib/mni/bin
    else if ( -e /usr/pubsw/packages/mni/current/bin) then
        setenv MINC_BIN_DIR /usr/pubsw/packages/mni/current/bin
    else if ( -e /usr/local/mni/bin) then
        setenv MINC_BIN_DIR /usr/local/mni/bin
    else if ( -e $FREESURFER_HOME/minc/bin) then
        setenv MINC_BIN_DIR $FREESURFER_HOME/minc/bin
    endif
endif
if((! $?NO_MINC) && (! $?MINC_LIB_DIR  || $FS_OVERRIDE)) then
    # try to find minc toolkit libraries
    if ( $?MNI_INSTALL_DIR) then
        setenv MINC_LIB_DIR $MNI_INSTALL_DIR/lib
    else if ( -e $FREESURFER_HOME/lib/mni/lib) then
        setenv MINC_LIB_DIR $FREESURFER_HOME/lib/mni/lib
    else if ( -e /usr/pubsw/packages/mni/current/lib) then
        setenv MINC_LIB_DIR /usr/pubsw/packages/mni/current/lib
    else if ( -e /usr/local/mni/lib) then
        setenv MINC_LIB_DIR /usr/local/mni/lib
    else if ( -e $FREESURFER_HOME/minc/lib) then
        setenv MINC_LIB_DIR $FREESURFER_HOME/minc/lib
    endif
endif

if(! $?FSL_DIR  || $FS_OVERRIDE) then
    if ( $?FSLDIR ) then
	setenv FSL_DIR $FSL_DIR
    else if ( -e $FREESURFER_HOME/fsl) then
        setenv FSL_DIR $FREESURFER_HOME/fsl
    else if ( -e /usr/local/fsl) then
        setenv FSL_DIR /usr/local/fsl
    else if ( -e /Users/Shared/fsl) then
        setenv FSL_DIR /Users/Shared/fsl
    else if ( -e /usr/pubsw/packages/fsl/current) then
	setenv FSL_DIR /usr/pubsw/packages/fsl/current
    endif
endif

setenv FREESURFER_HOME  $FREESURFER_HOME
setenv LOCAL_DIR        $FREESURFER_HOME/local

## Make sure these directories exist.
foreach d ($FSFAST_HOME $SUBJECTS_DIR)
    if(! -e $d ) then
        if( $output ) then
            echo "WARNING: $d does not exist"
        endif
    endif
end

if( $output ) then
    echo "FREESURFER_HOME $FREESURFER_HOME"
    echo "FSFAST_HOME     $FSFAST_HOME"
    echo "SUBJECTS_DIR    $SUBJECTS_DIR"
endif
if( $output && $?FUNCTIONALS_DIR ) then
    echo "FUNCTIONALS_DIR $FUNCTIONALS_DIR"
endif

## Talairach subject in anatomical database.
setenv FS_TALAIRACH_SUBJECT talairach


######## --------- Functional Analysis Stuff ----------- #######
if( ! $?NO_FSFAST) then
    setenv FMRI_ANALYSIS_DIR $FSFAST_HOME # backwards compatability
    set SUF = ~/matlab/startup.m
    if(! -e $SUF) then
        echo "INFO: $SUF does not exist ... creating"
        mkdir -p ~/matlab
        touch $SUF
        
        echo "%------------ FreeSurfer FAST ------------------------%" >> $SUF
        echo "fsfasthome = getenv('FSFAST_HOME');"                     >> $SUF
        echo "fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);"       >> $SUF
        echo "path(path,fsfasttoolbox);"                               >> $SUF
        echo "clear fsfasthome fsfasttoolbox;"                         >> $SUF
        echo "%-----------------------------------------------------%" >> $SUF
    endif

    set tmp1 = `grep FSFAST_HOME $SUF       | wc -l`;
    set tmp2 = `grep FMRI_ANALYSIS_DIR $SUF | wc -l`;
  
    if($tmp1 == 0 && $tmp2 == 0) then
            if( $output ) then
            echo ""
            echo "WARNING: The $SUF file does not appear to be";
            echo "         configured correctly. You may not be able"
            echo "         to run the FS-FAST programs";
            echo "Try adding the following three lines to $SUF"
            echo "----------------cut-----------------------"
            echo "fsfasthome = getenv('FSFAST_HOME');"         
            echo "fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);"
            echo "path(path,fsfasttoolbox);"                        
            echo "clear fsfasthome fsfasttoolbox;"
            echo "----------------cut-----------------------"
            echo ""
            endif
    endif
endif

### ----------- MINC Stuff -------------- ####
if( $output && $?MINC_BIN_DIR ) then
    echo "MINC_BIN_DIR    $MINC_BIN_DIR"
endif
if( $output && $?MINC_LIB_DIR ) then
    echo "MINC_LIB_DIR    $MINC_LIB_DIR"
endif
if(! $?NO_MINC) then
    if( $?MINC_BIN_DIR) then
        if (! -d $MINC_BIN_DIR) then
            if( $output ) then
                echo "WARNING: MINC_BIN_DIR '$MINC_BIN_DIR' does not exist.";
            endif
        endif
    else
        if( $output ) then
            echo "WARNING: MINC_BIN_DIR not defined."
            echo "         'nu_correct' and other MINC tools"
            echo "         are used by some Freesurfer utilities."
            echo "         Set NO_MINC to suppress this warning."
        endif
    endif
    if( $?MINC_LIB_DIR) then
        if (! -d $MINC_LIB_DIR) then
            if( $output ) then
                echo "WARNING: MINC_LIB_DIR '$MINC_LIB_DIR' does not exist.";
            endif
        endif
    else
        if( $output ) then
            echo "WARNING: MINC_LIB_DIR not defined."
            echo "         Some Freesurfer utilities rely on the"
            echo "         MINC toolkit libraries."
            echo "         Set NO_MINC to suppress this warning."
        endif
    endif
    ## Set Load library path ##
    if(! $?LD_LIBRARY_PATH ) then
        if ( $?MINC_LIB_DIR) then
            setenv LD_LIBRARY_PATH  $MINC_LIB_DIR
        endif
    else
        if ( $?MINC_LIB_DIR) then        
            setenv LD_LIBRARY_PATH  "$LD_LIBRARY_PATH":"$MINC_LIB_DIR"
        endif
    endif
    ## nu_correct and other MINC tools require a path to perl
    if (! $?PERL5LIB) then
        if ( -e $MINC_LIB_DIR/../System/Library/Perl/5.8.6 ) then
            # Max OS X Tiger default:
            setenv PERL5LIB       "$MINC_LIB_DIR/../System/Library/Perl/5.8.6"
        else if ( -e $MINC_LIB_DIR/../System/Library/Perl/5.8.1 ) then
            # Max OS X Panther default:
            setenv PERL5LIB       "$MINC_LIB_DIR/../System/Library/Perl/5.8.1"
        else if ( -e $MINC_LIB_DIR/perl5/5.8.5) then
            # Linux default:
            setenv PERL5LIB       "$MINC_LIB_DIR/perl5/5.8.5"
        else if ( -e $MINC_LIB_DIR/perl5/site_perl/5.8.3) then
            # Linux default:
            setenv PERL5LIB       "$MINC_LIB_DIR/perl5/site_perl/5.8.3"
        endif
    endif
    if( $output && $?PERL5LIB ) then
        echo "PERL5LIB        $PERL5LIB"
    endif
endif
if(! $?NO_MINC) then
    if ( $?MINC_BIN_DIR) then
        set path = ( $MINC_BIN_DIR $path )
    endif
endif


### ----------- FSL ------------ ####
if ( $?FSL_DIR ) then
    setenv FSLDIR $FSL_DIR
    setenv FSL_BIN $FSL_DIR/bin
    if(! -d $FSL_BIN) then
        if( $output ) then
            echo "WARNING: $FSL_BIN does not exist.";
        endif
    endif
endif
if ( $?FSL_BIN ) then
    set path = ( $FSL_BIN $path )
endif
if( $output && $?FSL_DIR ) then
    echo "FSL_DIR         $FSL_DIR"
endif
if ( -e ${FSLDIR}/etc/fslconf/fsl.csh ) then
    source ${FSLDIR}/etc/fslconf/fsl.csh
endif


### ----------- Qt (scuba2 support libraries)  ------------ ####
if ( ! $?QTDIR ) then
    # look for Qt in common NMR locations
    if ( -e $FREESURFER_HOME/lib/qt) then
        setenv QTDIR    $FREESURFER_HOME/lib/qt
    else if ( -e /usr/pubsw/packages/qt/current) then
        setenv QTDIR    /usr/pubsw/packages/qt/current
    endif
endif
if ( $?QTDIR ) then
    setenv PATH     $QTDIR/bin:$PATH
    if (! $?MANPATH) then
        setenv MANPATH    $QTDIR/doc/man
    else
        setenv MANPATH    $QTDIR/doc/man:$MANPATH
    endif
    if (! $?LD_LIBRARY_PATH) then
        setenv LD_LIBRARY_PATH  $QTDIR/lib
    else
        setenv LD_LIBRARY_PATH  $QTDIR/lib:$LD_LIBRARY_PATH
    endif
    if (! $?DYLD_LIBRARY_PATH) then
        setenv DYLD_LIBRARY_PATH  $QTDIR/lib
    else
        setenv DYLD_LIBRARY_PATH  $QTDIR/lib:$DYLD_LIBRARY_PATH
    endif
endif
if( $output && $?QTDIR ) then
    echo "QTDIR           $QTDIR"
endif

### ----------- Freesurfer Support Libraries  ------------ ####
if ( -e $FREESURFER_HOME/lib/misc ) then
    source $FREESURFER_HOME/lib/misc/SetupLibsEnv.csh
endif

### ----------- Freesurfer Bin and  Lib Paths  ------------ ####
set path = ( $FSFAST_HOME/bin     \
             $FREESURFER_HOME/bin/noarch      \
             $FREESURFER_HOME/bin/         \
             $path \
            )
## Add path to OS-specific static and dynamic libraries.
if(! $?LD_LIBRARY_PATH ) then
    setenv LD_LIBRARY_PATH  $FREESURFER_HOME/lib/
else
    setenv LD_LIBRARY_PATH  "$LD_LIBRARY_PATH":"$FREESURFER_HOME/lib/"
endif
if(! $?DYLD_LIBRARY_PATH ) then
    setenv DYLD_LIBRARY_PATH  $FREESURFER_HOME/lib/
else
    setenv DYLD_LIBRARY_PATH  "$DYLD_LIBRARY_PATH":"$FREESURFER_HOME/lib/"
endif

rehash;

exit 0;
####################################################################
