#!/usr/bin/env bash

# ============================================================
# run_ibex_questa.sh
#
# Purpose:
#   Run Ibex UVM test on QuestaSim.
#
# Modes:
#   --batch : run simulation automatically in command-line mode.
#   --gui   : load design in Questa GUI, stop before simulation,
#             let user add waves manually, then user runs simulation
#             in GUI. Terminal still captures logs through tee.
#
# Assumption:
#   Environment variables are already exported from ~/.bashrc:
#     QUESTA_HOME
#     RISCV_GCC
#     RISCV_OBJCOPY
#     SPIKE_PATH
#     PKG_CONFIG_PATH
#     LM_LICENSE_FILE
#
# ============================================================

set -u

# ----------------------------
# Resolve paths from script location
# ----------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_IBEX="$SCRIPT_DIR"
IBEX_ROOT="$(cd "$CORE_IBEX/../../.." && pwd)"

# ----------------------------
# Default options
# ----------------------------
TEST_NAME="riscv_machine_mode_rand_test"
SEED="123"
ITERATIONS="1"
IBEX_CONFIG="small"
SIMULATOR="questa"
ISS="spike"
COSIM="1"
DO_CLEAN="1"
VERBOSE="1"

# GUI / waveform options
RUN_MODE="batch"       # batch | gui
DO_PATCH_YAML="1"      # patch rtl_simulation.yaml before running
DO_REBUILD_COSIM="0"   # rebuild libibex_cosim.so before running

# ----------------------------
# Parse arguments
# ----------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --test)
      TEST_NAME="$2"
      shift 2
      ;;
    --seed)
      SEED="$2"
      shift 2
      ;;
    --iterations)
      ITERATIONS="$2"
      shift 2
      ;;
    --config)
      IBEX_CONFIG="$2"
      shift 2
      ;;
    --cosim)
      COSIM="$2"
      shift 2
      ;;
    --batch)
      RUN_MODE="batch"
      shift
      ;;
    --gui)
      RUN_MODE="gui"
      shift
      ;;
    --patch-yaml)
      DO_PATCH_YAML="1"
      shift
      ;;
    --no-patch-yaml)
      DO_PATCH_YAML="0"
      shift
      ;;
    --rebuild-cosim)
      DO_REBUILD_COSIM="1"
      shift
      ;;
    --no-clean)
      DO_CLEAN="0"
      shift
      ;;
    --verbose)
      VERBOSE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage:"
      echo "  ./run_ibex_questa.sh [options]"
      echo
      echo "Basic options:"
      echo "  --test TEST_NAME          Default: riscv_machine_mode_rand_test"
      echo "  --seed SEED               Default: 123"
      echo "  --iterations N            Default: 1"
      echo "  --config CONFIG           Default: small"
      echo "  --cosim 0|1               Enable/disable Spike cosim. Default: 1"
      echo "  --no-clean                Skip cleaning out/work before running"
      echo "  --verbose 0|1             Default: 1"
      echo
      echo "GUI / waveform modes:"
      echo "  --batch                   Batch regression mode. Questa runs with -c,"
      echo "                            executes run -a, then quits automatically."
      echo "                            Use this for normal pass/fail regression."
      echo
      echo "  --gui                     Interactive debug mode. Questa opens with -gui,"
      echo "                            loads the design, opens Transcript/Objects/Signals/Wave,"
      echo "                            then stops before running simulation."
      echo "                            You can add any waves manually, then run simulation"
      echo "                            from GUI using Run -All or Transcript command: run -a"
      echo "                            Questa is kept open after simulation finishes."
      echo "                            The terminal still logs make/vsim output through tee."
      echo
      echo "Patch/build helper options:"
      echo "  --patch-yaml              Patch yaml/rtl_simulation.yaml before run. Default."
      echo "  --no-patch-yaml           Do not patch yaml/rtl_simulation.yaml."
      echo "  --rebuild-cosim           Rebuild questa_dpi/libibex_cosim.so before run."
      echo
      echo "Generated files to check after a run:"
      echo "  out/run/tests/<TEST>.<SEED>/rtl_sim.log"
      echo "  out/run/tests/<TEST>.<SEED>/rtl_sim_stdstreams.log"
      echo "  out/run/tests/<TEST>.<SEED>/trace_core_00000000.log"
      echo "  out/run/tests/<TEST>.<SEED>/trr.yaml"
      echo "  out/run/tests/<TEST>.<SEED>/vsim.wlf"
      echo "  run_logs/questa_<TEST>_<SEED>_<timestamp>.log"
      echo
      echo "Examples:"
      echo "  # Normal batch run with Spike cosim"
      echo "  ./run_ibex_questa.sh --batch --cosim 1"
      echo
      echo "  # GUI debug: load design, add waves manually, then run from GUI"
      echo "  ./run_ibex_questa.sh --gui --cosim 1"
      echo
      echo "  # GUI debug with another seed"
      echo "  ./run_ibex_questa.sh --gui --cosim 1 --seed 456"
      echo
      echo "  # Rebuild cosim library, then run GUI"
      echo "  ./run_ibex_questa.sh --rebuild-cosim --gui --cosim 1"
      echo
      echo "Notes:"
      echo "  --gui intentionally does NOT run simulation automatically."
      echo "  --gui intentionally does NOT quit Questa automatically."
      echo "  In GUI, after adding waves, click Run -All or type: run -a"
      echo "  After simulation finishes, close Questa manually to let make collect results."
      exit 0
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      echo "Run with --help for usage."
      exit 1
      ;;
  esac
done

# ----------------------------
# Helper functions
# ----------------------------
check_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[ERROR] Command not found: $cmd"
    return 1
  fi
  echo "[OK] $cmd = $(command -v "$cmd")"
  return 0
}

check_env() {
  local name="$1"
  local value="${!name:-}"

  if [[ -z "$value" ]]; then
    echo "[ERROR] Environment variable is not set: $name"
    return 1
  fi

  echo "[OK] $name = $value"
  return 0
}

flow_log() {
  echo "$@"
  if [[ -n "${LOG_FILE:-}" ]]; then
    echo "$@" >> "$LOG_FILE"
  fi
}

flow_blank() {
  echo
  if [[ -n "${LOG_FILE:-}" ]]; then
    echo >> "$LOG_FILE"
  fi
}

flow_stage() {
  local id="$1"
  local name="$2"
  local action="$3"
  local tools="$4"
  local inputs="$5"
  local outputs="$6"
  local next_step="$7"

  flow_blank
  flow_log "------------------------------------------------------------"
  flow_log "[FLOW][$id] $name"
  flow_log "  Action      : $action"
  flow_log "  Tools       : $tools"
  flow_log "  Inputs      : $inputs"
  flow_log "  Outputs     : $outputs"
  flow_log "  Next step   : $next_step"
  flow_log "------------------------------------------------------------"
}

print_flow_overview() {
  cat <<FLOW_OVERVIEW
============================================================
Verification flow overview
============================================================
Purpose:
  Verify Ibex RTL with a UVM/SystemVerilog testbench on QuestaSim.

Required tools and libraries:
  - QuestaSim: vmap, vlog, vsim
  - GNU make: top-level flow scheduler
  - Python virtualenv: metadata.py, compile_tb.py, compile_test.py,
    run_instr_gen.py, run_rtl.py, check_logs.py
  - RISC-V toolchain: RISCV_GCC, RISCV_OBJCOPY
  - Spike/cosim packages: riscv-riscv, riscv-disasm, riscv-fdt,
    riscv-fesvr through pkg-config
  - DPI shared library: questa_dpi/libibex_cosim.so when COSIM=1

Spatial model:
  Test selection
    riscv_dv_extension/testlist.yaml
    directed_tests/directed_testlist.yaml
    directed_tests/custom_testlist.yaml
        |
        v
  Python metadata and build scripts
        |
        v
  RISC-V program image: test.bin
        |
        v
  Questa UVM testbench + Ibex RTL + optional Spike DPI cosim
        |
        v
  Logs, traces, trr.yaml, regr.log, optional waveform database

UVM environment model:
  core_ibex_base_test
    -> core_ibex_env
       -> memory/IRQ/cosim agents
       -> monitors, scoreboard, coverage hooks
       -> Ibex DUT in core_ibex_tb_top
       -> Spike reference model through DPI when COSIM=1

Runtime selection:
  TEST=$TEST_NAME
  SEED=$SEED
  ITERATIONS=$ITERATIONS
  IBEX_CONFIG=$IBEX_CONFIG
  SIMULATOR=$SIMULATOR
  ISS=$ISS
  COSIM=$COSIM
  RUN_MODE=$RUN_MODE
============================================================
FLOW_OVERVIEW
}

print_runtime_stage_map() {
  flow_blank
  flow_log "============================================================"
  flow_log "Time-ordered verification stages"
  flow_log "============================================================"
  flow_log "00. Pre-flight: print intent, selected test, seed, Ibex config."
  flow_log "01. Environment check: validate env vars and required commands."
  flow_log "02. Python setup: activate .venv for Ibex DV scripts."
  flow_log "03. Cosim setup: validate or rebuild Spike DPI library."
  flow_log "04. Simulator config: create GUI do file and patch rtl_simulation.yaml."
  flow_log "05. Workspace prep: clean old out/work/transcript artifacts if enabled."
  flow_log "06. Metadata: metadata.py reads riscv-dv, directed, and custom testlists."
  flow_log "07. Core config: render riscv_core_setting.sv for IBEX_CONFIG."
  flow_log "08. TB compile: compile RTL, UVM TB, DPI hooks with vlog."
  flow_log "09. Program build: generate/compile test.S or directed source to test.bin."
  flow_log "10. RTL simulation: run vsim with UVM_TESTNAME and +bin=<test.bin>."
  flow_log "11. Result check: check_logs.py creates trr.yaml and regr.log."
  flow_log "12. Summary: print pass/fail, important logs, traces, waveform path."
  flow_log "============================================================"
}

print_make_pipeline_detail() {
  flow_blank
  flow_log "============================================================"
  flow_log "Make pipeline detail"
  flow_log "============================================================"
  flow_log "metadata.py"
  flow_log "  Function : create RegressionMetadata and per-test TestRunResult."
  flow_log "  Reads    : riscv_dv_extension/testlist.yaml,"
  flow_log "             directed_tests/directed_testlist.yaml,"
  flow_log "             directed_tests/custom_testlist.yaml if present,"
  flow_log "             ibex_configs.yaml."
  flow_log "  Produces : out/metadata/metadata.yaml, out/metadata/*.pickle,"
  flow_log "             out/run/tests/<TEST>.<SEED>/trr.yaml."
  flow_log ""
  flow_log "render_config_template.py"
  flow_log "  Function : map IBEX_CONFIG to riscv-dv core setting."
  flow_log "  Produces : riscv_dv_extension/riscv_core_setting.sv."
  flow_log ""
  flow_log "compile_tb.py"
  flow_log "  Function : build UVM/SystemVerilog simulation image."
  flow_log "  Calls    : vmap, vlog."
  flow_log "  Produces : out/build/tb/top.list, compile_tb.log."
  flow_log ""
  flow_log "run_instr_gen.py / compile_test.py"
  flow_log "  Function : create or compile the RISC-V software payload."
  flow_log "  Calls    : riscv-dv run.py for random tests, RISCV_GCC,"
  flow_log "             RISCV_OBJCOPY for directed/custom tests."
  flow_log "  Produces : out/run/tests/<TEST>.<SEED>/test.bin."
  flow_log ""
  flow_log "run_rtl.py"
  flow_log "  Function : launch RTL simulation."
  flow_log "  Calls    : vsim."
  flow_log "  Inputs   : top.list, test.bin, RTL params, UVM_TESTNAME,"
  flow_log "             Spike DPI library when COSIM=1."
  flow_log "  Produces : rtl_sim.log, rtl_sim_stdstreams.log, trace_core_*.log,"
  flow_log "             vsim.wlf."
  flow_log ""
  flow_log "check_logs.py / collect_results.py"
  flow_log "  Function : classify PASS/FAIL, extract UVM errors and cosim status."
  flow_log "  Produces : trr.yaml, regr.log, final terminal summary."
  flow_log "============================================================"
}

# ----------------------------
# Prepare log directory early so FLOW sections are captured too
# ----------------------------
mkdir -p "$CORE_IBEX/run_logs"
LOG_FILE="$CORE_IBEX/run_logs/questa_${TEST_NAME}_${SEED}_$(date +%Y%m%d_%H%M%S).log"

# ----------------------------
# Print header
# ----------------------------
echo "============================================================"
echo "Ibex QuestaSim Runner"
echo "============================================================"
echo "SCRIPT_DIR      = $SCRIPT_DIR"
echo "IBEX_ROOT       = $IBEX_ROOT"
echo "CORE_IBEX       = $CORE_IBEX"
echo "TEST            = $TEST_NAME"
echo "SEED            = $SEED"
echo "ITERATIONS      = $ITERATIONS"
echo "IBEX_CONFIG     = $IBEX_CONFIG"
echo "SIMULATOR       = $SIMULATOR"
echo "ISS             = $ISS"
echo "COSIM           = $COSIM"
echo "RUN_MODE        = $RUN_MODE"
echo "DO_CLEAN        = $DO_CLEAN"
echo "DO_PATCH_YAML   = $DO_PATCH_YAML"
echo "DO_REBUILD_COSIM= $DO_REBUILD_COSIM"
echo "VERBOSE         = $VERBOSE"
echo "LOG_FILE        = $LOG_FILE"
echo "============================================================"

print_flow_overview | tee -a "$LOG_FILE"

# ----------------------------
# Environment checks
# ----------------------------
flow_stage \
  "01" \
  "Environment and tool discovery" \
  "Check shell environment variables, executable tools, and RISC-V toolchain paths." \
  "bash, command -v, vsim, vlog, vmap, make, python, gcc, g++" \
  "QUESTA_HOME, RISCV_GCC, RISCV_OBJCOPY, SPIKE_PATH, PKG_CONFIG_PATH, LM_LICENSE_FILE" \
  "Validated paths or immediate error message." \
  "Activate Python virtualenv and move into core_ibex."

echo
echo "[INFO] Checking environment from ~/.bashrc..."

check_env QUESTA_HOME || exit 1
check_env RISCV_GCC || exit 1
check_env RISCV_OBJCOPY || exit 1
check_env SPIKE_PATH || exit 1
check_env PKG_CONFIG_PATH || exit 1

# LM_LICENSE_FILE is important for Questa, but in some shells it may be empty.
if [[ -z "${LM_LICENSE_FILE:-}" ]]; then
  echo "[WARNING] LM_LICENSE_FILE is empty."
else
  echo "[OK] LM_LICENSE_FILE = $LM_LICENSE_FILE"
fi

echo
echo "[INFO] Checking required commands..."

check_cmd vsim || exit 1
check_cmd vlog || exit 1
check_cmd vmap || exit 1
check_cmd make || exit 1
check_cmd python || true
check_cmd python3 || true
check_cmd gcc || exit 1
check_cmd g++ || exit 1

if [[ -x "$RISCV_GCC" ]]; then
  echo "[OK] RISCV_GCC exists: $RISCV_GCC"
else
  echo "[ERROR] RISCV_GCC does not exist or is not executable: $RISCV_GCC"
  exit 1
fi

if [[ -x "$RISCV_OBJCOPY" ]]; then
  echo "[OK] RISCV_OBJCOPY exists: $RISCV_OBJCOPY"
else
  echo "[ERROR] RISCV_OBJCOPY does not exist or is not executable: $RISCV_OBJCOPY"
  exit 1
fi

if command -v spike >/dev/null 2>&1; then
  echo "[OK] spike = $(command -v spike)"
else
  echo "[WARNING] spike command not found in PATH."
  echo "          Current SPIKE_PATH = $SPIKE_PATH"
fi

# ----------------------------
# Activate Python virtual environment
# ----------------------------
flow_stage \
  "02" \
  "Python DV environment" \
  "Activate the repository virtualenv so Python DV scripts use the expected packages." \
  "source, python" \
  "$IBEX_ROOT/.venv" \
  "Selected python executable and version." \
  "Locate Questa DPI headers and prepare cosim."

echo
echo "[INFO] Activating Python virtual environment..."

cd "$IBEX_ROOT" || exit 1

if [[ ! -d "$IBEX_ROOT/.venv" ]]; then
  echo "[ERROR] Python venv not found:"
  echo "        $IBEX_ROOT/.venv"
  exit 1
fi

# shellcheck disable=SC1091
source "$IBEX_ROOT/.venv/bin/activate"

hash -r

echo "[OK] python = $(command -v python)"
python --version

# ----------------------------
# Go to core_ibex directory
# ----------------------------
cd "$CORE_IBEX" || exit 1

# ----------------------------
# Find Questa svdpi.h
# ----------------------------
flow_stage \
  "03" \
  "Questa DPI header discovery" \
  "Find svdpi.h for compiling or validating DPI-based cosimulation support." \
  "find, dirname" \
  "$QUESTA_HOME/questasim" \
  "QUESTA_INC exported to the environment." \
  "Check or rebuild Spike cosim shared library."

QUESTA_INC="$(dirname "$(find "$QUESTA_HOME/questasim" -name svdpi.h | head -n 1)")"
if [[ -z "$QUESTA_INC" || ! -f "$QUESTA_INC/svdpi.h" ]]; then
  echo "[ERROR] Cannot find svdpi.h under $QUESTA_HOME/questasim"
  exit 1
fi
export QUESTA_INC

echo "[OK] QUESTA_INC = $QUESTA_INC"

# ----------------------------
# Rebuild cosim library when requested
# ----------------------------
build_cosim_lib() {
  echo
  echo "[INFO] Rebuilding libibex_cosim.so..."

  mkdir -p "$CORE_IBEX/questa_dpi"
  rm -f "$CORE_IBEX/questa_dpi/libibex_cosim.so"
  rm -f "$CORE_IBEX/questa_dpi"/*.o 2>/dev/null || true

  gcc -fPIC \
    -I"$QUESTA_INC" \
    -c "$CORE_IBEX/common/date.c" \
    -o "$CORE_IBEX/questa_dpi/date.o"

  if ! nm "$CORE_IBEX/questa_dpi/date.o" | grep -q " get_unix_timestamp"; then
    echo "[ERROR] date.o does not export get_unix_timestamp"
    exit 1
  fi

  g++ -fPIC -std=c++17 \
    -I"$QUESTA_INC" \
    -I"$IBEX_ROOT/dv/cosim" \
    $(pkg-config --cflags riscv-riscv riscv-disasm riscv-fdt riscv-fesvr) \
    -c "$CORE_IBEX/common/ibex_cosim_agent/spike_cosim_dpi.cc" \
    -o "$CORE_IBEX/questa_dpi/spike_cosim_dpi.o"

  g++ -fPIC -std=c++17 \
    -I"$QUESTA_INC" \
    -I"$IBEX_ROOT/dv/cosim" \
    $(pkg-config --cflags riscv-riscv riscv-disasm riscv-fdt riscv-fesvr) \
    -c "$IBEX_ROOT/dv/cosim/cosim_dpi.cc" \
    -o "$CORE_IBEX/questa_dpi/cosim_dpi.o"

  g++ -fPIC -std=c++17 \
    -I"$QUESTA_INC" \
    -I"$IBEX_ROOT/dv/cosim" \
    $(pkg-config --cflags riscv-riscv riscv-disasm riscv-fdt riscv-fesvr) \
    -c "$IBEX_ROOT/dv/cosim/spike_cosim.cc" \
    -o "$CORE_IBEX/questa_dpi/spike_cosim.o"

  g++ -shared \
    "$CORE_IBEX/questa_dpi/date.o" \
    "$CORE_IBEX/questa_dpi/spike_cosim_dpi.o" \
    "$CORE_IBEX/questa_dpi/cosim_dpi.o" \
    "$CORE_IBEX/questa_dpi/spike_cosim.o" \
    -Wl,--no-as-needed \
    $(pkg-config --libs riscv-riscv riscv-disasm riscv-fdt riscv-fesvr) \
    -static-libstdc++ \
    -static-libgcc \
    -o "$CORE_IBEX/questa_dpi/libibex_cosim.so"

  echo "[OK] Built $CORE_IBEX/questa_dpi/libibex_cosim.so"
}

# ----------------------------
# COSIM sanity check
# ----------------------------
if [[ "$COSIM" == "1" ]]; then
  COSIM_LIB="$CORE_IBEX/questa_dpi/libibex_cosim.so"

  flow_stage \
    "04" \
    "Spike cosim DPI setup" \
    "Validate Spike pkg-config packages and DPI shared library symbols." \
    "pkg-config, nm, ldd, optional gcc/g++ rebuild" \
    "questa_dpi/libibex_cosim.so and Spike cosim packages" \
    "Usable DPI library for vsim -sv_lib." \
    "Create GUI collateral and patch simulator YAML."

  echo
  echo "[INFO] COSIM=1 selected."

  if ! command -v pkg-config >/dev/null 2>&1; then
    echo "[ERROR] pkg-config not found."
    exit 1
  fi

  if ! pkg-config --exists riscv-riscv riscv-disasm riscv-fdt riscv-fesvr; then
    echo "[ERROR] pkg-config cannot find Spike cosim packages."
    echo "        PKG_CONFIG_PATH = $PKG_CONFIG_PATH"
    exit 1
  fi

  if [[ "$DO_REBUILD_COSIM" == "1" ]]; then
    build_cosim_lib
  fi

  if [[ ! -f "$COSIM_LIB" ]]; then
    echo "[ERROR] COSIM=1 requires Spike DPI library, but it was not found:"
    echo "        $COSIM_LIB"
    echo
    echo "Run with: ./run_ibex_questa.sh --rebuild-cosim --cosim 1"
    exit 1
  fi

  echo "[INFO] Checking cosim DPI symbols..."

  nm -D --defined-only "$COSIM_LIB" | grep -q " get_unix_timestamp" || {
    echo "[ERROR] Missing DPI symbol: get_unix_timestamp"
    exit 1
  }
  nm -D --defined-only "$COSIM_LIB" | grep -q " spike_cosim_init" || {
    echo "[ERROR] Missing DPI symbol: spike_cosim_init"
    exit 1
  }
  nm -D --defined-only "$COSIM_LIB" | grep -q " spike_cosim_release" || {
    echo "[ERROR] Missing DPI symbol: spike_cosim_release"
    exit 1
  }
  nm -D --defined-only "$COSIM_LIB" | grep -q " riscv_cosim_step" || {
    echo "[ERROR] Missing DPI symbol: riscv_cosim_step"
    exit 1
  }

  if ldd "$COSIM_LIB" | grep -q "not found"; then
    ldd "$COSIM_LIB"
    echo "[ERROR] Cosim library has missing shared libraries."
    exit 1
  fi

  echo "[OK] Found and checked Spike DPI library: $COSIM_LIB"
else
  flow_stage \
    "04" \
    "Spike cosim DPI setup skipped" \
    "COSIM=0 selected; simulation will not compare each retired instruction against Spike." \
    "none" \
    "COSIM=$COSIM" \
    "No DPI cosim library is required for this run." \
    "Create GUI collateral and patch simulator YAML."
fi

# ----------------------------
# Create Questa GUI load-only do file
# ----------------------------
flow_stage \
  "05" \
  "GUI collateral generation" \
  "Create a Questa do file that loads useful debug windows in GUI mode." \
  "bash heredoc" \
  "RUN_MODE=$RUN_MODE" \
  "$CORE_IBEX/questa_gui_load.do" \
  "Patch yaml/rtl_simulation.yaml for batch or GUI run mode."

GUI_DO_FILE="$CORE_IBEX/questa_gui_load.do"

cat > "$GUI_DO_FILE" <<'GUI_EOF'
# ============================================================
# Questa GUI load-only script for Ibex
# ============================================================

# Keep GUI open when simulation reaches $finish.
onfinish stop

# Open useful GUI windows.
view transcript
view objects
view signals
view wave

# Do not add waves automatically here.
# User should add desired signals manually before running.

echo ""
echo "============================================================"
echo "Ibex design loaded in Questa GUI."
echo "Next steps:"
echo "  1. Add waves manually from Objects/Signals window."
echo "  2. Run simulation from GUI: click Run -All, or type: run -a"
echo "  3. After simulation finishes, inspect waveform/logs."
echo "  4. Close Questa manually to let make collect results."
echo "============================================================"
echo ""
GUI_EOF

# ----------------------------
# Patch yaml/rtl_simulation.yaml
# ----------------------------
patch_yaml() {
  local yaml_file="$CORE_IBEX/yaml/rtl_simulation.yaml"

  if [[ ! -f "$yaml_file" ]]; then
    echo "[ERROR] Cannot find $yaml_file"
    exit 1
  fi

  local backup="$yaml_file.bak_run_ibex_questa_$(date +%Y%m%d_%H%M%S)"
  cp "$yaml_file" "$backup"
  echo "[INFO] Backed up yaml to $backup"

  RUN_MODE_PY="$RUN_MODE" COSIM_PY="$COSIM" CORE_IBEX_PY="$CORE_IBEX" python3 - <<'PY_EOF'
import os
import re
from pathlib import Path

p = Path("yaml/rtl_simulation.yaml")
s = p.read_text()

run_mode = os.environ["RUN_MODE_PY"]
cosim = os.environ["COSIM_PY"]
core_ibex = os.environ["CORE_IBEX_PY"]

svlib = f"-sv_lib {core_ibex}/questa_dpi/libibex_cosim"
gui_do = f"{core_ibex}/questa_gui_load.do"

mode_token = "vsim -64 -gui" if run_mode == "gui" else "vsim -64 -c"

# Normalize simulator mode. The upstream YAML can spell this either on one line
# or split across folded YAML lines, so normalize whitespace first for the first
# Questa command.
s = re.sub(r"vsim\s+-64\s+-(?:gui|c)", mode_token, s, count=1)

# Make sure GCC path is present for DPI auto compile.
if "-dpicpppath /usr/bin/gcc" not in s:
    s = s.replace(mode_token, mode_token + " -dpicpppath /usr/bin/gcc", 1)

# Normalize suppress options. Remove old occurrences first to avoid duplication.
s = re.sub(r"\s+-suppress\s+8323,12126", "", s)
s = re.sub(r"\s+-suppress\s+8323", "", s)
s = re.sub(r"\s+-suppress\s+12126", "", s)
s = s.replace(mode_token, mode_token + " -suppress 8323,12126", 1)

# Normalize WLF option.
s = re.sub(r"\s+-wlf\s+\S+", "", s)
s = s.replace(mode_token, mode_token + " -wlf vsim.wlf", 1)

# Normalize cosim library option.
s = re.sub(r"\s+-sv_lib\s+\S*libibex_cosim", "", s)
if cosim == "1":
    s = s.replace("-suppress 8323,12126", f"-suppress 8323,12126 {svlib}", 1)

# Normalize -do command.
# Batch mode should run and quit automatically.
# GUI mode should only load design and stop before run.
s = re.sub(r"-do\s+'run -a; quit -f'", "__DO_PLACEHOLDER__", s)
s = re.sub(r'-do\s+"run -a; quit -f"', "__DO_PLACEHOLDER__", s)
s = re.sub(r"-do\s+\S*questa_gui[^\s]*\.do", "__DO_PLACEHOLDER__", s)

new_do = f"-do {gui_do}" if run_mode == "gui" else "-do 'run -a; quit -f'"

if "__DO_PLACEHOLDER__" in s:
    # IMPORTANT: replace ALL placeholders, not just the first one.
    # rtl_simulation.yaml can contain more than one -do field/template.
    s = s.replace("__DO_PLACEHOLDER__", new_do)
else:
    if "+designfile" in s:
        s = s.replace("+designfile", f"{new_do} +designfile", 1)
    else:
        s = s.replace(mode_token, f"{mode_token} {new_do}", 1)

# Safety check: never leave an internal placeholder in the YAML.
if "__DO_PLACEHOLDER__" in s:
    raise SystemExit("[ERROR] Internal __DO_PLACEHOLDER__ leaked into rtl_simulation.yaml")

# Defensive: GUI mode must not contain quit/quit -f in the RTL simulation command.
# Batch mode intentionally keeps quit -f.
if run_mode == "gui":
    s = s.replace("; quit -f", "")
    s = s.replace("; quit", "")

p.write_text(s)
print(f"[OK] Patched yaml/rtl_simulation.yaml for RUN_MODE={run_mode}, COSIM={cosim}")
PY_EOF

  grep -n "vsim -64\|suppress\|sv_lib\|libibex_cosim\|wlf\|questa_gui_load\|quit -f" "$yaml_file" || true
}

if [[ "$DO_PATCH_YAML" == "1" ]]; then
  flow_stage \
    "06" \
    "Simulator command patch" \
    "Normalize Questa command options for mode, WLF, DPI path, suppressions, and -do command." \
    "python3, grep" \
    "yaml/rtl_simulation.yaml, RUN_MODE=$RUN_MODE, COSIM=$COSIM" \
    "Patched rtl_simulation.yaml plus timestamped backup." \
    "Create run log and prepare workspace."

  echo
  echo "[INFO] Patching yaml/rtl_simulation.yaml..."
  patch_yaml
else
  flow_stage \
    "06" \
    "Simulator command patch skipped" \
    "--no-patch-yaml selected; use yaml/rtl_simulation.yaml as-is." \
    "none" \
    "Existing yaml/rtl_simulation.yaml" \
    "No YAML edits." \
    "Create run log and prepare workspace."

  echo
  echo "[INFO] Skip yaml patch because --no-patch-yaml was selected."
fi

# ----------------------------
# Prepare log directory
# ----------------------------
echo
echo "[INFO] Run log:"
echo "       $LOG_FILE"

print_runtime_stage_map

# ----------------------------
# Optional clean
# ----------------------------
if [[ "$DO_CLEAN" == "1" ]]; then
  flow_stage \
    "07" \
    "Workspace cleanup" \
    "Remove old generated build/run artifacts so this run starts from a clean state." \
    "make clean, rm" \
    "out, work, transcript, vsim.wlf, temporary DPI files" \
    "Clean build and run directories." \
    "Launch make-driven verification pipeline."

  echo
  echo "[INFO] Cleaning previous outputs..."
  make clean || true
  rm -rf out
  rm -rf work
  rm -rf /tmp/*_dpi_* 2>/dev/null || true
  rm -f transcript vsim.wlf
else
  flow_stage \
    "07" \
    "Workspace cleanup skipped" \
    "--no-clean selected; reuse existing generated artifacts when Make considers them valid." \
    "make dependency checks" \
    "Existing out/work directories" \
    "Incremental build state preserved." \
    "Launch make-driven verification pipeline."

  echo
  echo "[INFO] Skip clean because --no-clean was selected."
fi

# ----------------------------
# Run make
# ----------------------------
flow_stage \
  "08" \
  "Make-driven verification pipeline" \
  "Run metadata creation, core config rendering, TB compile, program build, simulation, and log checks." \
  "make, Python DV scripts, RISCV_GCC, RISCV_OBJCOPY, vmap, vlog, vsim" \
  "TEST=$TEST_NAME, SEED=$SEED, ITERATIONS=$ITERATIONS, IBEX_CONFIG=$IBEX_CONFIG" \
  "test.bin, rtl_sim.log, traces, trr.yaml, regr.log, optional vsim.wlf" \
  "Print result summary and debug pointers."

print_make_pipeline_detail

echo
echo "============================================================"
echo "[INFO] Starting QuestaSim run..."
echo "============================================================"

echo "make \\"
echo "  TEST=$TEST_NAME \\"
echo "  ITERATIONS=$ITERATIONS \\"
echo "  SEED=$SEED \\"
echo "  SIMULATOR=$SIMULATOR \\"
echo "  ISS=$ISS \\"
echo "  COSIM=$COSIM \\"
echo "  IBEX_CONFIG=$IBEX_CONFIG \\"
echo "  VERBOSE=$VERBOSE"
echo

if [[ "$RUN_MODE" == "gui" ]]; then
  echo "[INFO] GUI mode selected."
  echo "[INFO] Questa will load the design and stop before simulation."
  echo "[INFO] Add waves manually, then click Run -All or type: run -a"
  echo "[INFO] After simulation finishes, close Questa manually to let make collect results."
  echo
fi

make \
  TEST="$TEST_NAME" \
  ITERATIONS="$ITERATIONS" \
  SEED="$SEED" \
  SIMULATOR="$SIMULATOR" \
  ISS="$ISS" \
  COSIM="$COSIM" \
  IBEX_CONFIG="$IBEX_CONFIG" \
  VERBOSE="$VERBOSE" \
  2>&1 | tee -a "$LOG_FILE"

MAKE_STATUS="${PIPESTATUS[0]}"

# ----------------------------
# Result summary
# ----------------------------
flow_stage \
  "09" \
  "Result collection and report" \
  "Summarize make exit status, UVM pass/fail messages, cosim status, and generated artifacts." \
  "grep, head, find, tail on failure" \
  "rtl_sim.log, trr.yaml, regr.log, run log" \
  "Human-readable pass/fail summary and debug commands." \
  "Exit with the Make status code."

echo
echo "============================================================"
echo "[INFO] make exit code = $MAKE_STATUS"
echo "============================================================"

TEST_DIR="$CORE_IBEX/out/run/tests/${TEST_NAME}.${SEED}"
RTL_LOG="$TEST_DIR/rtl_sim.log"
TRR_YAML="$TEST_DIR/trr.yaml"

echo
echo "[INFO] Useful result files:"
echo "  Run log      : $LOG_FILE"
echo "  RTL log      : $RTL_LOG"
echo "  TRR yaml     : $TRR_YAML"
echo "  Test dir     : $TEST_DIR"
echo "  Wave database: $TEST_DIR/vsim.wlf"
echo

if [[ -f "$RTL_LOG" ]]; then
  echo "[INFO] RTL quick summary:"
  grep -n "RISC-V UVM TEST PASSED\|RISC-V UVM TEST FAILED\|Co-simulation matched\|UVM_ERROR\|UVM_FATAL\|Fatal\|Error loading design" "$RTL_LOG" || true
else
  echo "[WARNING] RTL log not found: $RTL_LOG"
fi

echo
if [[ -f "$TRR_YAML" ]]; then
  echo "[INFO] TRR summary:"
  head -n 25 "$TRR_YAML"
else
  echo "[WARNING] TRR YAML not found: $TRR_YAML"
fi

echo
if find "$CORE_IBEX/out" -name "regr.log" -print -quit 2>/dev/null | grep -q .; then
  echo "[INFO] Regression log:"
  find "$CORE_IBEX/out" -name "regr.log" -print -exec cat {} \;
else
  echo "[WARNING] regr.log not found. If GUI is still open, close it after simulation finishes."
fi

echo
if [[ "$MAKE_STATUS" -ne 0 ]]; then
  echo "[FAIL] QuestaSim run failed."
  echo
  echo "[INFO] Last 80 lines of run log:"
  tail -n 80 "$LOG_FILE"
  echo
  echo "[INFO] Useful debug commands:"
  echo "  tail -n 200 $RTL_LOG"
  echo "  tail -n 200 $TEST_DIR/rtl_sim_stdstreams.log"
  echo "  cat $TRR_YAML | head -n 40"
  exit "$MAKE_STATUS"
fi

echo "[PASS] QuestaSim run finished successfully."
echo "============================================================"

exit 0
