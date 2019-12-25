#!/bin/bash
# Wait until FreeSwitch started and listens on port 8021.
until $(nc -z 127.0.0.1 8021); do { printf '.'; sleep 1; }; done
# Wait until PostgreSQL started and listens on port 5432.
until $(nc -z db 5432); do { printf '.'; sleep 1; }; done

# Start CPBX
chmod +x /opt/cpbx
cd /opt
./cpbx