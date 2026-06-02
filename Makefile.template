SRCS = $(wildcard *.sv)

.PHONY: help all clean verdi
help:
	@echo "make           编译所有 .sv"
	@echo "make sim_xxx  编译 xxx.sv（如 make sim_2）"
	@echo "make run_xxx  运行仿真（如 make run_2）"
	@echo "make wave_xxx 运行并打开 Verdi（如 make wave_2）"
	@echo "make verdi    看波形"
	@echo "make clean    清理 build/ 目录"

define SIM_RULE
sim_$(1): $(1).sv
	@mkdir -p build
	vcs -full64 -sverilog -lca -debug_access+all -Mdir=build/csrc $$< -o build/$(1).sim
endef
$(foreach s,$(basename $(SRCS)),$(eval $(call SIM_RULE,$(s))))

all: $(addprefix sim_,$(basename $(SRCS)))

run_%:
	cd build && ./$*.sim
	@mv -f ucli.key build/ 2>/dev/null || true

wave_%:
	cd build && ./$*.sim
	cd build && verdi -sv $(addprefix ../,$(SRCS)) $(addprefix -ssf ,$(wildcard *.fsdb *.vcd)) &

verdi:
	cd build && verdi -sv $(addprefix ../,$(SRCS)) $(addprefix -ssf ,$(wildcard *.fsdb *.vcd)) &

clean:
	rm -rf build
