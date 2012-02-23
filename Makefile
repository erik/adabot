PROJECT := adabot.gpr

all: ada-irc
	gnatmake -P $(PROJECT)

clean:
	gnatclean -P $(PROJECT)
