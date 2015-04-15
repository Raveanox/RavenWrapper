#!/usr/bin/env python
# Raven Wrapper v0.3 by Raveanox
from screenutils import list_screens, Screen
from multiprocessing import Process
from config import *
import datetime
import time
import os

def start_server():
	time.sleep(1)
	os.system("screen -d -S " + screenName +" -m " + startScript)
def main_loop():
	hasStartedBefore=False
	screen = Screen(screenName)
	while True:
		if screen.exists:
			print("Server Stable...")
		else:
			if hasStartedBefore == False:
				print("Starting the server...")
				start_server()
				hasStartedBefore = True
			else:
				timenow = datetime.datetime.now()
                        	if timenow.strftime('%H:%M') == restartTime:
					print("The server restarted, starting back.")
				else:
					print("The server crashed! Restarting...")
				start_server()

		#Sleep X seconds before re-running the main loop.
		time.sleep(sleepTime)

def clock_loop():
	screen = Screen(screenName)
	count = 0

	while True:
		if screen.exists:
			if autoSave:
				#If time for an auto save...
				if count == saveX:
					#Send the save-all command to the Minecraft server...
					print("Autosaving...")
					screen.send_commands("save-all")
					#Reset the counter...
					count=0
				else:
					#Increse the counter by one
					count += 1
			if autoRestart:
				timenow = datetime.datetime.now()
				if timenow.strftime('%H:%M') == restartTime:
					screen.send_commands("say Server restarting in five seconds...")
					screen.send_commands("save-all")
					time.sleep(5)
					screen.send_commands("kick @a Server restarting... come back in 45 seconds...")
					screen.send_commands("stop")
					count = 0
					time.sleep(60)
			time.sleep(1)

if __name__ == '__main__':
    Process(target=main_loop).start()
    Process(target=clock_loop).start()
