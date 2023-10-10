#!/bin/bash
source userhost.bash
source transcom.bash
source dirent.bash
dirent $*

mensaje "Inicia transferencia"
eok
transfer "$ARGS"
mensaje "Termina transferencia"
eok

