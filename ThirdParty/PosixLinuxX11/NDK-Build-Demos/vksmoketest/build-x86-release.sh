#!/bin/bash

cd "$(dirname "$(readlink -f "${0}")")"

target_name="vksmoketest"
int_dir="libs/x86"
out_dir="../../../../Binary/x86/Release"

# glslang
rm -rf Smoke.push_constant.vert.inc
rm -rf Smoke.vert.inc
rm -rf Smoke.frag.inc
../../glibc-glslang/bin/glslangValidator -V Smoke.push_constant.vert -x -o Smoke.push_constant.vert.inc
../../glibc-glslang/bin/glslangValidator -V Smoke.vert -x -o Smoke.vert.inc
../../glibc-glslang/bin/glslangValidator -V Smoke.frag -x -o Smoke.frag.inc

# build by ndk
# rm -rf obj/local/x86
# rm -rf libs/x86
ndk-build APP_DEBUG:=false APP_ABI:=x86 NDK_PROJECT_PATH:=null NDK_OUT:=obj NDK_LIBS_OUT:=libs NDK_APPLICATION_MK:=Application.mk APP_BUILD_SCRIPT:=LinuxX11.mk 

# before execute change the rpath to \$ORIGIN  
chrpath -r '$ORIGIN' ${int_dir}/${target_name}

# mkdir the out dir if necessary
mkdir -p ${out_dir}

# copy the striped so to out dir
rm -rf ${out_dir}/${target_name}
cp -f ${int_dir}/${target_name} ${out_dir}/

# change to cwd   
cd ${out_dir}
  
# execute the generated a.out  
./${target_name} # --validate