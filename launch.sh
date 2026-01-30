#!/bin/bash
# Pack Magik Due Diligence Presentation Launcher

PORT=8889
DIR="$(cd "$(dirname "$0")" && pwd)"

# Kill any existing server on this port
lsof -ti :$PORT | xargs kill 2>/dev/null

echo "🎴 Starting Pack Magik Due Diligence Presentation..."
echo "📁 Serving from: $DIR"

# Start server in background
cd "$DIR"
python3 -m http.server $PORT &>/dev/null &
SERVER_PID=$!

# Wait for server to start
sleep 1

# Open in default browser
if [[ "$OSTYPE" == "darwin"* ]]; then
    open "http://localhost:$PORT"
elif command -v xdg-open &>/dev/null; then
    xdg-open "http://localhost:$PORT"
else
    echo "Open http://localhost:$PORT in your browser"
fi

echo ""
echo "✅ Presentation running at: http://localhost:$PORT"
echo "   Press Ctrl+C to stop"
echo ""
echo "Navigation:"
echo "   ← → Arrow keys or click dots"
echo "   Space bar = next slide"
echo ""

# Wait for user to stop
trap "kill $SERVER_PID 2>/dev/null; echo ''; echo 'Server stopped.'" EXIT
wait $SERVER_PID
