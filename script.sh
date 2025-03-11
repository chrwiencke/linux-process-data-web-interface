#!/bin/bash

generate_metrics() {
    # Get system metrics
    UPTIME=$(awk '{print $1}' /proc/uptime)
    CPUUSAGE=$(top -b -n 1 | awk '/%Cpu/{print $2+$4}' | cut -d. -f1)
    MEMUSAGE=$(free | awk '/Mem/{printf "%.0f", $3/$2 * 100}')
    USER=$(who | wc -l)
    
    # Get top 5 CPU-consuming processes
    TOP_PROCESSES=$(ps -eo pid,%cpu,%mem,comm --sort=-%cpu | head -n 6 | tail -n 5)

    echo "$TOP_PROCESSES" | awk -v uptime="$UPTIME" -v cpu="$CPUUSAGE" -v mem="$MEMUSAGE" -v user="$USER" '
    BEGIN {
        print "<html><head><title>System Status</title>";
        print "<script>";
        print "function updateStats() {";
        print "fetch(\"/index.html\").then(res => res.text()).then(data => {";
        print "let parser = new DOMParser();";
        print "let doc = parser.parseFromString(data, \"text/html\");";
        print "document.getElementById(\"cpu\").innerText = doc.getElementById(\"cpu\").innerText;";
        print "document.getElementById(\"mem\").innerText = doc.getElementById(\"mem\").innerText;";
        print "document.getElementById(\"uptime\").innerText = doc.getElementById(\"uptime\").innerText;";
        print "document.getElementById(\"user\").innerText = doc.getElementById(\"user\").innerText;";
        print "document.getElementById(\"top-processes\").innerHTML = doc.getElementById(\"top-processes\").innerHTML;";
        print "});";
        print "}";
        print "setInterval(updateStats, 1000);";  # Refresh every 1 seconds
        print "</script>";
        print "</head><body>";
        print "<h2>System Usage</h2>";
        print "<p><strong>CPU Usage:</strong> <span id=\"cpu\">" cpu "%</span></p>";
        print "<p><strong>Memory Usage:</strong> <span id=\"mem\">" mem "%</span></p>";
        print "<p><strong>Uptime:</strong> <span id=\"uptime\">" uptime " seconds</span></p>";
        print "<p><strong>Logged-in Users:</strong> <span id=\"user\">" user "</span></p>";
        print "<h2>Top 5 CPU-Consuming Processes</h2>";
        print "<table border=\"1\"><tr><th>PID</th><th>CPU%</th><th>MEM%</th><th>Command</th></tr><tbody id=\"top-processes\">";
    }
    NR>1 { print "<tr><td>" $1 "</td><td>" $2 "%</td><td>" $3 "%</td><td>" $4 "</td></tr>" }
    END { print "</tbody></table></body></html>" }
    ' > /var/www/html/index.html
}

while true; do
    generate_metrics
    sleep 1
done