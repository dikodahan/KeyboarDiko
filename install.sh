#!/bin/sh
LOG=~/.KeyboarDiko.log
ZOOMRUNNING=0
TEAMSRUNNING=0
WEBEXRUNNING=0
GTMRUNNING=0

clear 
echo "\033[1m-------------------------------------------------------------\033[0m"
echo 
echo "\033[1mThis is the MacOS installer of the KeyboarDiko utility!\033[0m"
echo "\033[1mPlease follow the instruction as listed in the installer.\033[0m"
echo 
echo "\033[1m--------------------------------------------------------------\033[0m"
echo 

# Check if previously installed
if ! test -f ~/.KeyboarDiko.log; then
    # Create initial log file
    touch $LOG
    echo "[0] Automator setup" >> $LOG
    echo "[0] Zoom installed" >> $LOG
    echo "[0] Zoom shortcuts configured" >> $LOG
    echo "[0] Microsoft Teams installed" >> $LOG
    echo "[0] Microsoft Teams shortcuts configured" >> $LOG
    echo "[0] Webex installed" >> $LOG
    echo "[0] Webex shortcuts configured" >> $LOG
    echo "[0] GoToMeeting installed" >> $LOG
    echo "[0] GoToMeeting shortcuts configured" >> $LOG
fi

# Validate if Automator is enabled in the system settings
if grep -q "\[0\] Automator setup" $LOG; then
    echo "Please make sure you completed enabling Automator in your Mac accessibility section before continuing."
    echo "If not completed the installation will fail."
    echo
    echo "\033[7mSystem Preferances > Security & Privacy > Accessibility > Automator [Enabled]\033[0m"
    echo "If not enabled, please make sure you enable it (unlock at the bottom left lock icon to enable it and re-lock when done)."
    echo
    read -p "Have you validated that Automator is enabled (y/n)? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo
        echo "\033[41mCannot continue at this stage. Please run the installation again when ready.\033[0m"
        echo
        exit 1
    fi
    LOGLINE=$(grep -n "Automator setup" $LOG | head -n 1 | cut -d: -f1)
    sed -e "${LOGLINE}"'s/.*/[1] Automator setup/' -i '' $LOG
fi


# Checking if Zoom is installed
echo
echo
if open -Ra "zoom.us" ; then
    if grep -q "\[0\] Zoom shortcuts configured" $LOG; then
        LOGLINE=$(grep -n "Zoom installed" $LOG | head -n 1 | cut -d: -f1)
        sed -e "${LOGLINE}"'s/.*/[1] Zoom installed/' -i '' $LOG
        echo "\033[42mIDENTIFIED: 'Zoom' is installed on your system\033[0m"
        # Checking if Zoom is currently running
        if pgrep -x zoom.us >/dev/null
        then
            ZOOMRUNNING=1
            echo "Your Zoom application is running. You need to close it in order to continue."
            read -p $'\033[1mIs it OK to close the Zoom application now (y/n)? \033[0m' -n 1 -r
            echo 
            if [[ ! $REPLY =~ ^[Yy]$ ]]
            then
                echo
                echo "\033[41mCannot continue at this stage. Please run the installation again when ready.\033[0m"
                echo
                exit 1
            fi
            killall zoom.us     # Close the Zoom app
            echo "Closed Zoom application"
        fi
        # Adding shortcut in settings for Zoom Global Mute (Command + Shift + F12)
        defaults write pbs NSServicesStatus -dict-add '"(null) - Zoom Global Mute - runWorkflowAsService"' '{ "key_equivalent" = "@$\UF70F"; }'
        echo "Added system hook to Zoom mute/unmute functionality"
        # Adding shortcut in settings for Zoom Global Video (Command + Shift + F11)
        defaults write pbs NSServicesStatus -dict-add '"(null) - Zoom Global Video - runWorkflowAsService"' '{ "key_equivalent" = "@$\UF70E"; }'
        echo "Added system hook to Zoom video functionality"
        LOGLINE=$(grep -n "Zoom shortcuts configured" $LOG | head -n 1 | cut -d: -f1)
        sed -e "${LOGLINE}"'s/.*/[1] Zoom shortcuts configured/' -i '' $LOG
    else
        echo "\033[42mZoom application system hooks are already configured!\033[0m"
    fi
else
    echo "\033[32mZoom not installed on your system\033[0m"
fi

# Checking if Microsoft Teams is running
echo
echo
if open -Ra "Microsoft Teams" ; then
    if grep -q "\[0\] Microsoft Teams shortcuts configured" $LOG; then
        LOGLINE=$(grep -n "Microsoft Teams installed" $LOG | head -n 1 | cut -d: -f1)
        sed -e "${LOGLINE}"'s/.*/[1] Microsoft Teams installed/' -i '' $LOG
        echo "\033[42mIDENTIFIED: 'Microsoft Teams' is installed on your system\033[0m"
        # Checking if Microsoft Teams is currently running
        if pgrep -x Teams >/dev/null
        then
            TEAMSRUNNING=1
            echo "Your Microsoft Teams application is running. You need to close it in order to continue."
            read -p $'\033[1mIs it OK to close the Microsoft Teams application now (y/n)? \033[0m' -n 1 -r
            echo 
            if [[ ! $REPLY =~ ^[Yy]$ ]]
            then
                echo
                echo "\033[41mCannot continue at this stage. Please run the installation again when ready.\033[0m"
                echo
                exit 1
            fi
            killall Teams     # Close the Microsoft Teams app
            echo "Closed Microsoft Teams application"
        fi
        # Adding shortcut in settings for Teams Global Mute (Command + Shift + F10)
        defaults write pbs NSServicesStatus -dict-add '"(null) - Teams Global Mute - runWorkflowAsService"' '{ "key_equivalent" = "@$\UF70D"; }'
        echo "Added system hook to Microsoft Teams mute/unmute functionality"
        # Adding shortcut in settings for Teams Global Video (Command + Shift + F9)
        defaults write pbs NSServicesStatus -dict-add '"(null) - Teams Global Video - runWorkflowAsService"' '{ "key_equivalent" = "@$\UF70C"; }'
        echo "Added system hook to Microsoft Teams video functionality"
        LOGLINE=$(grep -n "Microsoft Teams shortcuts configured" $LOG | head -n 1 | cut -d: -f1)
        sed -e "${LOGLINE}"'s/.*/[1] Microsoft Teams shortcuts configured/' -i '' $LOG
    else
        echo "\033[42mMicrosoft Teams application system hooks are already configured!\033[0m"
    fi
else
    echo "\033[32mMicrosoft Teams not installed on your system\033[0m"
fi


# Check if running the application again is required
echo
echo
if [ $ZOOMRUNNING -eq 1 ] || [ $TEAMSRUNNING -eq 1 ] || [ $WEBEXRUNNING -eq 1 ] || [ $GTMRUNNING -eq 1 ]; then
    read -p $'\033[96mWould you like to reopen the applications closed by this installation (y/n)? \033[0m' -n 1 -r
    echo 
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo
        echo "\033[1;44mInstallation complete!\033[0m"
        echo
        exit 1
    else
        if [ $ZOOMRUNNING = 1 ]; then
            open -a "zoom.us"
        fi
        if [ $TEAMSRUNNING = 1 ]; then
            open -a "Microsoft Teams"
        fi
        if [ $GTMRUNNING = 1 ]; then
            open -a "GoToMeeting"
        fi
        echo
        echo "\033[1;44mInstallation complete!\033[0m"
        echo
        exit 1
    fi
fi
echo
echo "\033[1;44mInstallation complete!\033[0m"
echo