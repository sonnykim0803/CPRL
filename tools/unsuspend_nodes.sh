#!/bin/bash

# qstat -f 실행 후, 's' 상태인 노드 목록 추출
nodes=$(qstat -f | awk '$NF == "s" {print $1}')

# 노드 활성화 (unsuspend)
for node in $nodes; do
    echo "Activating $node..."
    qmod -us "$node"
done

echo "All suspended nodes have been activated."

