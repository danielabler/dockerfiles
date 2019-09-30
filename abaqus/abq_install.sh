# This shell script downloads and installs Abaqus 2019 from tar archives accessible via ssh.
# It depends on the configuration file `abq_choices_custom.xml` for `silent installation` of Abaqus,
# which in turn assumes the directory
# /home/abquser/software
# to exist on the installation system.
# Changing the installation location requires modification of this path in `abq_choices_custom.xml` and
# of the variable PATH_ABQ_INSTALL.

# After installation, the script
# - modifies the PATH variable and defines `abqcae` as alias
# - updates license information (server, type of license)
# - configure abaqus to use gfortran as compiler

# This script is based on various instructions for installing Abaqus on Linux
# - http://coquake.eu/wp-content/uploads/2019/02/Abaqus18_on_Ubuntu18.04LTS.pdf
# - https://github.com/Kevin-Mattheus-Moerman/Abaqus-Installation-Instructions-for-Ubuntu
# - https://imechanica.org/node/13804


# CONFIGURATION OPTIONS
USERNAME=abler                # ssh username for login to server, you will be prompted for the password
HOME_DIR=/home/abquser        # home dir of installation system
BASE_DIR=/shared              # Directory where files are to be copied to and will be extracted.
                              # This can be a shared directory

### GET ABQ FILES FROM SERVER
ABQ_YEAR_VERSION=2019
ABQ_LOC_ON_BRAIN=/BRAIN/utils/SOFTWARE/Mathematical_Software/Abaqus/Abaqus_${ABQ_YEAR_VERSION}

FILE_ABQ_TAR_1=${ABQ_YEAR_VERSION}.AM_SIM_Abaqus_Extend.AllOS.1-5.tar
FILE_ABQ_TAR_2=${ABQ_YEAR_VERSION}.AM_SIM_Abaqus_Extend.AllOS.2-5.tar
FILE_ABQ_TAR_3=${ABQ_YEAR_VERSION}.AM_SIM_Abaqus_Extend.AllOS.3-5.tar
FILE_ABQ_TAR_4=${ABQ_YEAR_VERSION}.AM_SIM_Abaqus_Extend.AllOS.4-5.tar
FILE_ABQ_TAR_5=${ABQ_YEAR_VERSION}.AM_SIM_Abaqus_Extend.AllOS.5-5.tar

# Copy ABQ files
PATH_ABQ_TARS=${BASE_DIR}/ABQ_TARS
PATH_ABQ_EXTR=${BASE_DIR}/ABQ_EXTR
mkdir ${PATH_ABQ_TARS}
mkdir ${PATH_ABQ_EXTR}

scp ${USERNAME}@brain.artorg.unibe.ch:${ABQ_LOC_ON_BRAIN}/\{${FILE_ABQ_TAR_1},${FILE_ABQ_TAR_2},${FILE_ABQ_TAR_3},${FILE_ABQ_TAR_4},${FILE_ABQ_TAR_5}\} ${PATH_ABQ_TARS}

# Extract Files
tar -C ${PATH_ABQ_EXTR} -xvf ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_1}
rm ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_1}
tar -C ${PATH_ABQ_EXTR} -xvf ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_2}
rm ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_2}
tar -C ${PATH_ABQ_EXTR} -xvf ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_3}
rm ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_3}
tar -C ${PATH_ABQ_EXTR} -xvf ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_4}
rm ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_4}
tar -C ${PATH_ABQ_EXTR} -xvf ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_5}
rm ${PATH_ABQ_TARS}/${FILE_ABQ_TAR_5}

### MODIFY FILES FOR INSTALLATION ON UBUNTU
# Installation on Ubuntu is not officially supported by Abaqus
# Need to modify some config files to get the install started
# see https://github.com/Kevin-Mattheus-Moerman/Abaqus-Installation-Instructions-for-Ubuntu for more details

for f in $(find ${PATH_ABQ_EXTR} -name "Linux.sh" -type f); do
         echo "Modifying file $f"
         sed -i '9s/.*/DSY_OS_Release="CentOS"/' $f
         sed -i '$a export DSY_Skip_CheckPrereq=1' $f
done


### RUN INSTALLATION
PATH_ABQ_CHOICES=${BASE_DIR}/abq_choices_custom.xml
PATH_ABQ_START=${PATH_ABQ_EXTR}/AM_SIM_Abaqus_Extend.AllOS/1/StartTUI.sh

/bin/ksh ${PATH_ABQ_START} --silent ${PATH_ABQ_CHOICES}

### POST INSTALLATION
PATH_ABQ_INSTALL=/home/abquser/software
PATH_ABQ_COMMANDS=${PATH_ABQ_INSTALL}/DassaultSystemes/SIMULIA/Commands
PATH_ABQ_CUSTOM=${PATH_ABQ_INSTALL}/DassaultSystemes/SimulationServices/V6R2019x/linux_a64/SMA/site

# Make abaqus command globally available
echo "PATH=\${PATH}:${PATH_ABQ_COMMANDS}" >> ${HOME_DIR}/.bashrc
echo "alias abqcae='XLIB_SKIP_ARGB_VISUALS=1 abaqus cae -mesa'" >> ${HOME_DIR}/.bashrc

# Set Licence Information
PATH_TO_ENV_CUSTOM=${PATH_ABQ_CUSTOM}/custom_v6.env
rm ${PATH_TO_ENV_CUSTOM}
touch ${PATH_TO_ENV_CUSTOM}
echo "doc_root='file:////${PATH_ABQ_INSTALL}/DassaultSystemes/SIMULIA2019doc/English'" >> ${PATH_TO_ENV_CUSTOM}
sed -i '$a license_server_type=FLEXNET' ${PATH_TO_ENV_CUSTOM}
sed -i '$a abaquslm_license_file="@130.92.125.156"' ${PATH_TO_ENV_CUSTOM}
sed -i '$a academic=RESEARCH' ${PATH_TO_ENV_CUSTOM}

# Set Fortran Compiler
PATH_TO_ENV_CUSTOM=${PATH_ABQ_CUSTOM}/lnx86_64.env

# set gfortran
sed -i '11s/ifort/gfortran/' ${PATH_TO_ENV_CUSTOM}
 
# replace compile command
sed -i '28s/compile_fortran/compile_fortran_old/' ${PATH_TO_ENV_CUSTOM}
sed -i '84icompile_fortran = [fortCmd,"-c", "-fPIC", "-extend_source","-Warray-bounds", "-I%I"]' ${PATH_TO_ENV_CUSTOM}
 
# replace link command
sed -i '73s/link_sl/link_sl_old/' ${PATH_TO_ENV_CUSTOM}
sed -i '85ilink_sl = [fortCmd,"-fPIC", "-pthread", "-shared","%E",  "-Wl,-soname,%U" , "-o", "%U", "%F", "%A", "%L", "%B","-Wl,-Bdynamic","-lifport", "-lifcoremt"]' ${PATH_TO_ENV_CUSTOM}

sed -i '$a del link_sl_old' ${PATH_TO_ENV_CUSTOM}
sed -i '$a del compile_fortran_old' ${PATH_TO_ENV_CUSTOM}
