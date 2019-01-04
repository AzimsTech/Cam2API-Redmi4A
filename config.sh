##########################################################################################
#
# Magisk Module Template Config Script
# by topjohnwu
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure the settings in this file (config.sh)
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Configs
##########################################################################################

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print "****************************************"
  ui_print "This should enable Camera API2 on MIUI10"
  ui_print "    Stock MIUI Camera won't work !!!   "
  ui_print "****************************************"
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  # Only some special files require specific permissions
  # The default permissions should be good enough for most cases

  # Here are some examples for the set_perm functions:

  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH/system/lib       0       0       0755            0644

  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0       0644

  # The following is default permissions, DO NOT remove
  set_perm_recursive  $MODPATH  0  0  0755  0644
#  set_perm_recursive  $MODPATH/system/bin	0	2000	0755	0755
}

##########################################################################################
# Custom Functions
##########################################################################################

# This file (config.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.

#Checking for supported device and firmware. Thx @Didgeridoohan for this function.
device_fn() {
# Variables
DEVFND=0
DEVICES="
santoni_V10.1.1.0.NAMMIFI
"
# Device check
for ITEM in $DEVICES; do
  if [ $(getprop ro.product.name) == "$(echo $ITEM | cut -f 1 -d '_')" ] && [ $(getprop ro.build.version.incremental) == "$(echo $ITEM | cut -f 2 -d '_')" ] ; then
    ui_print "- $(echo $ITEM | cut -f 1 -d '_') detected, MIUI $(echo $ITEM | cut -f 2 -d '_')."
    mkdir -p $MODPATH/system
    cp -afr $INSTALLER/common/$(echo $ITEM | cut -f 1 -d '_') $MODPATH/system/priv-app
    DEVFND=1
    break
  fi
done
# Abort if no match
if [ $DEVFND == 0 ]; then
  abort "Unsupported device or modified build.prop"
fi
}
