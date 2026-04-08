{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs)
    stdenv lib gtk3 gdk-pixbuf atk pango cairo glib
    libxkbcommon fontconfig freetype expat zlib gsettings-desktop-schemas python3
    makeWrapper gobject-introspection mesa;

  inherit (pkgs.xorg)
    libX11 libXxf86vm libxcb libXcursor libXrandr libXrender libXext libXi libXdamage
    libXfixes libXcomposite libXtst;

  srcRoot = ./.;

  selectLocalFile = { fileName, name }:
    let
      storeDir = builtins.path {
        inherit name;
        path = srcRoot;
        filter = path: type:
          if type == "directory"
          then path == srcRoot
          else builtins.baseNameOf path == fileName;
      };
    in
    builtins.toPath "${storeDir}/${fileName}";

  installer = selectLocalFile {
    name = "freefilesync-14.9-donation-installer";
    fileName = "FreeFileSync_14.9_[Donation_Edition]_Install.run";
  };

  donationLicense = selectLocalFile {
    name = "freefilesync-14.9-donation-license";
    fileName = "FreeFileSync_14.9_[Donation_Edition]_Install.license";
  };

  runtimeLibs = [
    atk
    cairo
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libX11
    libxcb
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXcomposite
    libXi
    libXrandr
    libXrender
    libXxf86vm
    libxkbcommon
    libXtst
    mesa
    pango
    stdenv.cc.cc.lib
    zlib
  ];

  libraryPath = lib.makeLibraryPath runtimeLibs;

  gtkSchemaDirs = [
    "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    "${gtk3}/share/gsettings-schemas/${gtk3.name}"
  ];

  xdgDataDirs = lib.concatStringsSep ":" (
    gtkSchemaDirs ++ [
      "${gtk3}/share"
      "${gsettings-desktop-schemas}/share"
      "${gdk-pixbuf}/share"
    ]
  );

  gioModules = lib.makeSearchPath "lib/gio/modules" [
    gtk3
    glib
  ];

  giTypelibPath = lib.makeSearchPath "lib/girepository-1.0" [
    gtk3
    gobject-introspection
  ];

  gdkPixbufModuleFile = "${gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
  gdkPixbufModuleDir = "${gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders";

in

stdenv.mkDerivation rec {
  pname = "freefilesync";
  version = "14.9-donation";

  src = installer;

  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  buildInputs = [
    atk
    cairo
    expat
    fontconfig
    freetype
    gdk-pixbuf
    gsettings-desktop-schemas
    glib
    gtk3
    libX11
    libxcb
    libXxf86vm
    libxkbcommon
    pango
    zlib
    gobject-introspection
    mesa
    stdenv.cc.cc.lib
  ];

  dontUnpack = true;
  dontPatchELF = true;
  dontStrip = true;
  dontShrinkRPaths = true;

  fixupPhase = ''
    runHook preFixup
    runHook postFixup
  '';

  installPhase = ''
    runHook preInstall

    payloadOffset=$(
      python3 - "$src" <<'PY'
import pathlib
import sys
path = pathlib.Path(sys.argv[1])
data = path.read_bytes()
needle = b'ustar  '
pos = data.find(needle)
if pos == -1:
    raise SystemExit("failed to find tar payload marker")
print(pos - 257)
PY
    )

    echo "installer payload offset: $payloadOffset bytes"

    stage="$TMPDIR/freefilesync-stage"
    mkdir -p "$stage"

    dd if="$src" status=none iflag=skip_bytes skip="$payloadOffset" | tar -xf - -C "$stage"
    tar -xf "$stage/FreeFileSync.tar.gz" -C "$stage"

    appDir="$out/lib/freefilesync"
    mkdir -p "$appDir"

    cp -r "$stage"/{Bin,Resources} "$appDir"/
    install -Dm755 "$stage/FreeFileSync" "$appDir/FreeFileSync"
    install -Dm755 "$stage/RealTimeSync" "$appDir/RealTimeSync"

    install -Dm644 "${donationLicense}" "$appDir/Resources/Registered.dat"

    mkdir -p "$out/bin"

    commonWrapArgs=(
      --prefix LD_LIBRARY_PATH : "${libraryPath}"
      --prefix XDG_DATA_DIRS : "${xdgDataDirs}:$out/share"
      --prefix GIO_EXTRA_MODULES : "${gioModules}"
      --prefix GI_TYPELIB_PATH : "${giTypelibPath}"
      --set GDK_PIXBUF_MODULE_FILE "${gdkPixbufModuleFile}"
      --set GDK_PIXBUF_MODULEDIR "${gdkPixbufModuleDir}"
    )

    makeWrapper "$appDir/FreeFileSync" "$out/bin/FreeFileSync" "''${commonWrapArgs[@]}"
    makeWrapper "$appDir/RealTimeSync" "$out/bin/RealTimeSync" "''${commonWrapArgs[@]}"

    docDir="$out/share/doc/${pname}"
    install -Dm644 "$stage/LICENSE" "$docDir/LICENSE"
    install -Dm644 "$stage/CHANGELOG" "$docDir/CHANGELOG"
    install -Dm644 "$stage/User Manual.pdf" "$docDir/User Manual.pdf"
    install -Dm644 "${donationLicense}" "$docDir/Donation-Edition-License.txt"

    install -Dm644 "$stage/freefilesync-mime.xml" "$out/share/mime/packages/freefilesync.xml"

    for size in 16 24 32 48 64 128 256; do
      install -Dm644 "$stage/FreeFileSync-icon/''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/freefilesync.png"
      install -Dm644 "$stage/RealTimeSync-icon/''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/realtimesync.png"
    done

    install -Dm644 "$stage/FreeFileSync.template.desktop" "$out/share/applications/freefilesync.desktop"
    substituteInPlace "$out/share/applications/freefilesync.desktop" \
      --replace 'Exec="FFS_INSTALL_PATH/FreeFileSync" %F' 'Exec=FreeFileSync %F' \
      --replace 'Icon=FFS_INSTALL_PATH/Resources/FreeFileSync.png' 'Icon=freefilesync'

    install -Dm644 "$stage/RealTimeSync.template.desktop" "$out/share/applications/realtimesync.desktop"
    substituteInPlace "$out/share/applications/realtimesync.desktop" \
      --replace 'Exec="FFS_INSTALL_PATH/RealTimeSync" %F' 'Exec=RealTimeSync %F' \
      --replace 'Icon=FFS_INSTALL_PATH/Resources/RealTimeSync.png' 'Icon=realtimesync'

    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "FreeFileSync Donation Edition";
    homepage = "https://www.freefilesync.org/";
    license = licenses.unfree;
    maintainers = [ ];
    mainProgram = "FreeFileSync";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
