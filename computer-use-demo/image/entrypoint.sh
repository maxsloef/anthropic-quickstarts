#!/bin/bash
set -e

./start_all.sh
./novnc_startup.sh

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh" && \
    # Download and install Node.js:
    nvm install 22 && \
    npm install -g live-server

python http_server.py > /tmp/server_logs.txt 2>&1 &

STREAMLIT_SERVER_PORT=8501 python -m streamlit run computer_use_demo/streamlit.py > /tmp/streamlit_stdout.log &

echo "✨ Computer Use Demo is ready!"
echo "➡️  Open http://localhost:8080 in your browser to begin"

cd /home/computeruse/computer_use_demo/p5_editor
live-server --port=8081 &

# Set the DISPLAY variable and launch browser
export DISPLAY=:1
x-www-browser http://localhost:8081 &

# Keep the container running
tail -f /dev/null
