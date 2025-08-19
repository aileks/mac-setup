#!/usr/bin/env bash

function __icon_map() {
    case "$1" in
    "Activity Monitor")
        icon_result=":activity_monitor:"
        ;;
    "App Eraser" | "AppCleaner")
        icon_result=":app_eraser:"
        ;;
    "App Store")
        icon_result=":app_store:"
        ;;
    "Brave Browser")
        icon_result=":brave_browser:"
        ;;
    "Calculator")
        icon_result=":calculator:"
        ;;
    "Calendar")
        icon_result=":calendar:"
        ;;
    "Color Picker")
        icon_result=":color_picker:"
        ;;
    "Deezer")
        icon_result=":deezer:"
        ;;
    "Element")
        icon_result=":element:"
        ;;
    "FaceTime")
        icon_result=":face_time:"
        ;;
    "Finder")
        icon_result=":finder:"
        ;;
    "Freeform")
        icon_result=":freeform:"
        ;;
    "System Preferences" | "System Settings")
        icon_result=":gear:"
        ;;
    "Ghostty")
        icon_result=":ghostty:"
        ;;
    "iPhone Mirroring")
        icon_result=":iphone_mirroring:"
        ;;
    "Keynote")
        icon_result=":keynote:"
        ;;
    "Maps")
        icon_result=":maps:"
        ;;
    "Messages")
        icon_result=":messages:"
        ;;
    "Music")
        icon_result=":music:"
        ;;
    "Notes" | "Notesnook")
        icon_result=":notes:"
        ;;
    "Numbers")
        icon_result=":numbers:"
        ;;
    "Pages")
        icon_result=":pages:"
        ;;
    "Passwords")
        icon_result=":passwords:"
        ;;
    "Preview")
        icon_result=":pdf:"
        ;;
    "Photos")
        icon_result=":photos:"
        ;;
    "Podcasts")
        icon_result=":podcasts:"
        ;;
    "Proton Mail" | "Proton Mail Bridge")
        icon_result=":proton_mail:"
        ;;
    "Proton VPN" | "ProtonVPN")
        icon_result=":proton_vpn:"
        ;;
    "Reminders")
        icon_result=":reminders:"
        ;;
    "RStudio")
        icon_result=":drafts:"
        ;;
    "Safari")
        icon_result=":safari:"
        ;;
    "SF Symbols")
        icon_result=":sf_symbols:"
        ;;
    "Signal")
        icon_result=":signal:"
        ;;
    "Spotlight")
        icon_result=":spotlight:"
        ;;
    "Terminal")
        icon_result=":terminal:"
        ;;
    "TextEdit")
        icon_result=":textedit:"
        ;;
    "TG Pro")
        icon_result=":gear:"
        ;;
    "Weather")
        icon_result=":weather:"
        ;;
    "Xcode")
        icon_result=":xcode:"
        ;;
    "Zed")
        icon_result=":zed:"
        ;;
    "Zen")
        icon_result=":zen_browser:"
        ;;
    *)
        icon_result=":default:"
        ;;
    esac
}
