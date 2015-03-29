#!/bin/bash
set -e
mkdir -p pages/
sqlite3 sueddeutsche.de.sqlite < initialiseDatabase.sql