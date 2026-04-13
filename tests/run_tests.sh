#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  DevSphere — Live Currency Converter Task
#  Test Suite  (tests/run_tests.sh)
#
#  Checks that participants have:
#    1. Defined the ExchangeRateResponse data model
#    2. Implemented the fetchExchangeRates() function
#    3. Connected the ViewModel / ObservableObject to the View
#    4. Used async/await & URLSession for the API call
#    5. Handled errors (catch / URLError / no-network guard)
#    6. Exposed a convertedAmount binding/state to the UI
#    7. Used .onChange or Combine to react to amount/currency changes
#    8. Shown a loading state (ProgressView / isLoading flag)
#    9. Did NOT hard-code an API key in source (basic secret hygiene)
#   10. Kept read-only skeleton files intact (ContentView structure)
# ─────────────────────────────────────────────────────────────

set -euo pipefail

PASS=0
FAIL=0
ERRORS=()

# ── helpers ──────────────────────────────────────────────────
pass() { echo "  ✅  $1"; ((PASS++)) || true; }
fail() { echo "  ❌  $1"; ((FAIL++)) || true; ERRORS+=("$1"); }

grep_swift() {
  # grep_swift <pattern> <description> [file-glob]
  local pattern="$1" desc="$2" glob="${3:-*.swift}"
  if grep -riqE "$pattern" --include="$glob" . 2>/dev/null; then
    pass "$desc"
  else
    fail "$desc"
  fi
}

not_grep_swift() {
  local pattern="$1" desc="$2" glob="${3:-*.swift}"
  if grep -rqE "$pattern" --include="$glob" . 2>/dev/null; then
    fail "$desc"
  else
    pass "$desc"
  fi
}

echo ""
echo "════════════════════════════════════════════════════════"
echo "  DevSphere — Live Currency Converter  |  Test Suite"
echo "════════════════════════════════════════════════════════"
echo ""

# ── 1. Data model ─────────────────────────────────────────────
echo "▸ [1] Data Model"
grep_swift \
  'Codable' \
  "Codable struct for API response defined"

grep_swift \
  'rates|conversion_rates' \
  "rates dictionary/property present in model"

# ── 2. fetchExchangeRates implementation ─────────────────────
echo ""
echo "▸ [2] fetchExchangeRates() Implementation"
grep_swift \
  'fetch.*rates' \
  "fetchExchangeRates() function exists"

grep_swift \
  'URLSession' \
  "URLSession used for network call"

grep_swift \
  'decode|JSONDecoder' \
  "JSON decoding present"

grep_swift \
  'async|await' \
  "async/await used"

# ── 3. ViewModel / State management ──────────────────────────
echo ""
echo "▸ [3] ViewModel / State"
grep_swift \
  '@Published|ObservableObject|@Observable|@MainActor' \
  "Observable state management used (ObservableObject / @Observable)"

grep_swift \
  'convertedAmount|converted|result' \
  "convertedAmount or result state variable present"

grep_swift \
  'isLoading|loading|progress' \
  "Loading state variable present"

# ── 4. UI dynamic updates ─────────────────────────────────────
echo ""
echo "▸ [4] Dynamic UI Updates"
grep_swift \
  '\.onChange|\.onReceive|Combine|sink|Task|await' \
  "UI reacts to input changes (.onChange / Combine)"

grep_swift \
  'Task|await|\.task' \
  "Async task launched from UI (Task { } or .task modifier)"

# ── 5. Error handling ────────────────────────────────────────
echo ""
echo "▸ [5] Error Handling"
grep_swift \
  'catch|URLError|error|Error' \
  "catch block present for error handling"

grep_swift \
  'URLError|network|connection|internet|notConnected' \
  "Network / connectivity error handled or surfaced to UI"

# ── 6. Loading state shown in View ───────────────────────────
echo ""
echo "▸ [6] Loading State in View"
grep_swift \
  'ProgressView|progress|loading' \
  "ProgressView shown during fetch"

# ── 7. Converted amount displayed ────────────────────────────
echo ""
echo "▸ [7] Result Displayed"
grep_swift \
  'convertedAmount|Converted|result' \
  "Converted amount displayed in ContentView"

# ── 8. Logic NOT entirely inside ContentView (separation) ────
echo ""
echo "▸ [8] Separation of Concerns"
if [[ -f "Currency/logic.swift" || -f "logic.swift" ]]; then
  LOGIC_FILE=$(find . -name "logic.swift" | head -1)
  if grep -qE 'URLSession|fetch|decode|JSONDecoder' "$LOGIC_FILE" 2>/dev/null; then
    pass "Network logic implemented in logic.swift (not only in ContentView)"
  else
    fail "logic.swift exists but API logic not implemented inside it"
  fi
else
  # Accept a ViewModel file as an alternative
  if find . -name "*ViewModel*" -o -name "*Model*" | grep -qE '\.swift$'; then
    pass "Separate ViewModel/Model file used for business logic"
  else
    fail "No logic.swift or ViewModel file found — logic must be outside ContentView"
  fi
fi

# ── 9. No hard-coded API key ──────────────────────────────────
echo ""
echo "▸ [9] Secret Hygiene"
not_grep_swift \
  '"[a-f0-9]{24,}"' \
  "No obvious hard-coded API key string (long hex literal)"

not_grep_swift \
  'apiKey[[:space:]]*=[[:space:]]*"[^"]{8,}"|api_key[[:space:]]*=[[:space:]]*"[^"]{8,}"|appid[[:space:]]*=[[:space:]]*"[^"]{8,}"' \
  "API key not hard-coded in source as plain string literal"

# ── 10. ContentView structure intact ─────────────────────────
echo ""
echo "▸ [10] Read-Only Skeleton Integrity"
CONTENT_VIEW=$(find . -name "ContentView.swift" | head -1)
if [[ -z "$CONTENT_VIEW" ]]; then
  fail "ContentView.swift not found"
else
  if grep -qE 'Live Currency Converter' "$CONTENT_VIEW" 2>/dev/null; then
    pass "ContentView title text intact"
  else
    fail "ContentView title text was removed or changed"
  fi

  if grep -qE '"Enter Amount"' "$CONTENT_VIEW" 2>/dev/null; then
    pass "ContentView amount TextField placeholder intact"
  else
    fail "ContentView amount TextField placeholder was removed or changed"
  fi
fi

# ── Summary ───────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════"
echo "  Results:  ✅ $PASS passed   ❌ $FAIL failed"
echo "════════════════════════════════════════════════════════"

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo ""
  echo "Failed checks:"
  for e in "${ERRORS[@]}"; do
    echo "  • $e"
  done
fi

echo ""
[[ $FAIL -eq 0 ]]   # exits 0 on full pass, 1 on any failure
