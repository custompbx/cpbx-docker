Docker-compose file for CPBX

Put `cpbx` binary in `cbpx` folder and run
`docker-compose up -d`

To apply new config or binary - edit `cpbx` folder contents and
`docker-compose stop && docker-compose up -d`

Use https://localhost:8080/cweb to log in