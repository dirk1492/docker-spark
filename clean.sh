#!/bin/sh
kubectl delete pod $(kubectl get pods -l spark-role=executor --field-selector=status.phase!=Running -o=jsonpath={.items[*].metadata.name})
