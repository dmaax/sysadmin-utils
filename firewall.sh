# Variables
CLOUDFLAREIPS="173.245.48.0/20,103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,141.101.64.0/18,108.162.192.0/18,190.93.240.0/20,188.114.96.0/20,197.234.240.0/22,198.41.128.0/17,162.158.0.0/15,104.16.0.0/13,104.24.0.0/14,172.64.0.0/13,131.0.72.0/22"

# Clear ALL iptables settings
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

# Drop all connections by default
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Local network
iptables -A INPUT -i lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow SSH access
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# Allow access to Bungeecord proxy
iptables -A INPUT -p tcp -m multiport --dports 25565 -j ACCEPT

# Allow https traffic from Cloudflare proxy
iptables -A INPUT -p tcp -s $CLOUDFLAREIPS --dport 443 -j ACCEPT

# If using docker on your system, you need to restart docker every time a new firewall rule is added. Uncomment the line below if you use docker.
# sudo systemctl restart docker
echo "Done :)"
