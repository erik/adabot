PROJECT := adabot.gpr

all:
	gnatmake -P $(PROJECT)

clean:
	gnatclean -P $(PROJECT)
