#!/usr/bin/env python

import time, sys, threading
FIFO = "merusuto.fifo"

def printline(line):
  print "%s\r" % line

def main():
  import os, tty, termios
  import subprocess

  fd = sys.stdin.fileno()
  settings = termios.tcgetattr(fd)
  tty.setraw(fd)

  try:
    if not os.access(FIFO, os.R_OK):
      os.mkfifo(FIFO)

    sp = subprocess.Popen(["monkeyrunner", sys.argv[0], "fork"], shell = False)
    fifo = open(FIFO, "w")

    while True:
      ch = sys.stdin.read(1)
      if ord(ch) == 3:
        printline("Exit!")
        sp.kill()
        fifo.close()
        exit()
      fifo.write(ch)
      fifo.flush()

  finally:
    termios.tcsetattr(fd, termios.TCSADRAIN, settings)
    os.unlink(FIFO)

Y1 = 500
Y2 = 550
P1 = 150
P2 = 250
P3 = 350
P4 = 450
P5 = 550

T = 700
U = 850

def monkeyrunner():
  from com.android.monkeyrunner import MonkeyRunner, MonkeyDevice
  device = MonkeyRunner.waitForConnection()

  class Drager(threading.Thread):
    def __init__(self, delay, tpl1, tpl2):
      threading.Thread.__init__(self)
      self.delay = delay
      self.tpl1 = tpl1
      self.tpl2 = tpl2

    def run(self):
      time.sleep(self.delay)
      drag(self.tpl1, self.tpl2)

  def click(tpl):
    device.touch(tpl[0], tpl[1], MonkeyDevice.DOWN_AND_UP)

  def drag(tpl1, tpl2):
    device.drag(tpl1, tpl2, 0.3, 3)

  def swipe(tpl1, tpl2):
    drag(tpl1, tpl2)
    Drager(0.3, tpl2, tpl1).start()

  fifo = open(FIFO, "r")
  printline("Ready!")

  while True:
    ch = fifo.read(1)
    od = ord(ch)
    printline(str(od))

    if od == 49:
      click((P1, Y1))
    elif od == 50:
      click((P2, Y1))
    elif od == 51:
      click((P3, Y1))
    elif od == 52:
      click((P4, Y1))
    elif od == 53:
      click((P5, Y1))
    elif od == 113:
      drag((P1, Y1), (P1, Y2))
    elif od == 119:
      drag((P2, Y1), (P2, Y2))
    elif od == 101:
      drag((P3, Y1), (P3, Y2))
    elif od == 114:
      drag((P4, Y1), (P4, Y2))
    elif od == 116:
      drag((P5, Y1), (P5, Y2))

  fifo.close()

if len(sys.argv) <= 1:
  main()
else:
  monkeyrunner()
