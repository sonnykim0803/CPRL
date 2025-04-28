#!/bin/bash

# 사용법: extract_molden <qchem_output_file.out>

if [ "$#" -ne 1 ]; then
    echo "Usage: extract_molden <qchem_output_file.out>"
    exit 1
fi

OUTPUT_FILE="$1"
BASENAME="${OUTPUT_FILE%.out}"
MOLDEN_FILE="${BASENAME}.molden"

START_TAG="======= MOLDEN-FORMATTED INPUT FILE FOLLOWS ======="
END_TAG="======= END OF MOLDEN-FORMATTED INPUT FILE ======="

if [ ! -f "$OUTPUT_FILE" ]; then
    echo "[-] Output file $OUTPUT_FILE not found."
    exit 1
fi

# 마지막 MOLDEN 블록만 추출 (lines는 문자열 변수로 처리)
awk -v start="$START_TAG" -v end="$END_TAG" '
    $0 ~ start {block=1; buffer=""; next}
    $0 ~ end && block {
        block=0
        last_block = buffer
        next
    }
    block {buffer = buffer $0 ORS}
    END {
        if (last_block) {
            printf "%s", last_block
        }
    }
' "$OUTPUT_FILE" > "$MOLDEN_FILE"

# 결과 확인
if [ -s "$MOLDEN_FILE" ]; then
    echo "[+] Molden file saved as: $MOLDEN_FILE"
else
    echo "[-] Molden section not found. Removing empty file."
    rm -f "$MOLDEN_FILE"
fi

