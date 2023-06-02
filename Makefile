#!make

ifeq ($(OS), Windows_NT)
	CRAFTOS := craftos-pc
else
	CRAFTOS := craftos
endif

run:
	$(CRAFTOS) \
		--id 42 \
		--mount-ro /=./ \
		--mount-ro /lib/luassert=./submodules/luassert/src \
		--mount-ro /lib/system=./submodules/CC-LuaSystem/system \
		--mount-ro /lib/lfs=./submodules/LuaFileSystem/lfs \
		--mount-ro /lib/pl=./submodules/Penlight/lua/pl \
		--mount-ro /lib/say=./submodules/say/src/say \
		--headless
