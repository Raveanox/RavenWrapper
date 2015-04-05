#!/bin/bash

##############################################################################################################################


#Every X seconds, check if the minecaft server is running? [Default: 60]
sleepTime=60

#Enable AutoSave? ("save-all") [Default: true]
autoSave=true

#AutoSave Every Xth SleepTime? (If sleepTime = 60 Seconds; AutoSave happens every 60x Seconds.) [Default = 5]
saveX=5

#Path to server start script
startScript="/home/user/mcserver/start.sh"

#AutoRestart [Default: True]
autoRestart=true

#AutoRestart Time [Default: "01:00" (1 AM)]
restartTime="01:00"

#Screen Name; If you have multiple servers, make each server have a unique name. [Default: mcserver]
screenName=mcserver


###############################################################################################################################

#DO NOT EDIT THIS VARIBLE:
as=0

#Infinite Loop. CTRL-C To Stop.
while :
do
    if screen -list | grep -q "$screenName"; then

        #echo "$(date +"+%F_%T") Server still online..."

        if [ "$autoSave" = true ] ; then
            if [ $as = $saveX ] ; then
                #Sends a text string to the screen session.
                #echo "AutoSaving"
                screen -S $screenName -p 0 -X stuff "save-all$(printf \\r)"
                #Resets the AS counter (one is added later)
                as=-1
            fi
            #Increase the auto-save varible
            ((as++))
        fi

        if [ "$autoRestart" = true ] ; then
            if [ "$(date +%H:%M)" = $restartTime ] ; then

                #Sends a text string to the screen session.
                echo "Server restart in 2 minutes..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"Server restarting in 2 minutes...\",color:blue} $(printf \\r)"
                sleep 60
                echo "Server restart in 1 minute..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"Server restarting in 1 minute...\",color:blue} $(printf \\r)"
                sleep 55
                echo "Server restart in 5 seconds..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"Server restarting in 5 seconds...\",color:blue} $(printf \\r)"
                sleep 1
                echo "Server restart in 4 seconds..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"Server restarting in 4 seconds...\",color:blue} $(printf \\r)"
                sleep 1
                echo "Server restart in 3 seconds..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"Server restarting in 3 seconds...\",color:blue} $(printf \\r)"
                sleep 1
                echo "Server restart in 2 seconds..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"Server restarting in 2 seconds...\",color:blue} $(printf \\r)"
                sleep 1
                echo "Server restart in 1 second..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"Server restarting in 1 second...\",color:blue} $(printf \\r)"
                sleep 1
                echo "SERVER RESTARTING NOW..."
                screen -S $screenName -p 0 -X stuff "tellraw @a {text:\"THIS SERVER IS RESTARTING...\",color:red} $(printf \\r)"
                screen -S $screenName -p 0 -X stuff "save-all $(printf \\r)"
                sleep 5
                screen -S $screenName -p 0 -X stuff "kick @a The server is restarting. Please reconnect in 30 seconds. $(printf \\r)"
                screen -S $screenName -p 0 -X stuff "stop $(printf \\r)"
            fi
        fi


        #Sleep
        sleep $sleepTime

    else
        echo "$(date +"+%F_%T") Crash or Restart detected. Starting the server."
        screen -d -S $screenName -m $startScript

        #Reset the AutoSave counter
        as=0
        #Sleep
        sleep $sleepTime
    fi
done
