# Homebrew installs LLVM in a place that is not visible to ffigen.
# This explicitly specifies the place where the LLVM dylibs are kept.
llvm_path := if os() == "macos" {
    "--llvm-path /opt/homebrew/opt/llvm"
} else {
    ""
}

default: run
    
so:
    export ANDROID_NDK_HOME="$ANDROID_NDK"
    cd native && cargo ndk \
            -t armeabi-v7a -t arm64-v8a \
            -o ../android/app/src/main/jniLibs build --release

# vim:expandtab:sw=4:ts=4

run:
  #!/usr/bin/env sh
  files=()
  names=()
  names2=()
  index=0
  for item in `ls native/src/api_*.rs`; do
    item=${item##*/}
    files[index]=${item%%.*}
    tn=(`echo ${files[index]} | tr '_' ' '`)
    tnn=""
    tnn2=""
    aI=0
    for ti in ${tn[@]}; do
      if [ "$aI" = "0" ];then
        tnn2+=$ti
      else
        tnn2+=`echo $ti | perl -ne 'print s/[-]([a-z])/\u$1/gr' | perl -ne 'print s/^([a-z])/\u$1/gr'`
      fi
      tnn+=`echo $ti | perl -ne 'print s/[-]([a-z])/\u$1/gr' | perl -ne 'print s/^([a-z])/\u$1/gr'`
      aI+=1
    done
    names[index]=$tnn
    names2[index]=$tnn2
    index+=1
  done
  filesArg=`echo ${files[@]}`;
  namesArg=`echo ${names[@]}`;
  names2Arg=`echo ${names2[@]}`;
  just genArgs "${filesArg}" "${namesArg}"
#   filesArg:="${filesA}"


genArgs $files $names:
  #!/usr/bin/env sh
  export REPO_DIR="$PWD";
  rustInput=()
  dartOutput=()
  rustOutput=()
  iosOutput=()
  macOutput=()
  className=()
  index=0
  for item in $files; do
    rustInput[index]="$REPO_DIR/native/src/${item}.rs"
    dartOutput[index]="$REPO_DIR/lib/native/bridge_generated_${item}.dart"
    rustOutput[index]="$REPO_DIR/native/src/generated_${item}.rs"
    iosOutput[index]="$REPO_DIR/ios/Runner/bridge_generated_${item}.rs"
    macOutput[index]="$REPO_DIR/macos/Runner/bridge_generated_${item}.rs"
    className[index]=${names[index]}
    index+=1
  done
  rustInputArg=`echo ${rustInput[@]}`;
  dartOutputArg=`echo ${dartOutput[@]}`;
  rustOutputArg=`echo ${rustOutput[@]}`;
  iosOutputArg=`echo ${iosOutput[@]}`;
  macOutputArg=`echo ${macOutput[@]}`;
  classNameArg=`echo ${className[@]}`;
  just gen "${rustInputArg}" "${dartOutputArg}" "${rustOutputArg}" "${iosOutputArg}" "${macOutputArg}" "${classNameArg}"
  

gen $rustInput $dartOutput $rustOutput $iosOutputArg $macOutputArg $className:
    export REPO_DIR="$PWD"; cd /; flutter_rust_bridge_codegen {{llvm_path}} \
        --rust-input $rustInput \
        --dart-output $dartOutput \
        --rust-output $rustOutput \
        --c-output $iosOutputArg \
        --c-output $macOutputArg \
        --class-name $className
    # Uncomment this line to invoke build_runner as well
    # flutter pub run build_runner build

    just lint


lint:
    cd native && cargo fmt
    dart format .

clean:
    flutter clean
    cd native && cargo clean