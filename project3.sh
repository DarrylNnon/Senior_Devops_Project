### **Project: Continuous Monitoring System with Prometheus and Grafana**

This project focuses on setting up a robust **Continuous Monitoring System** using **Prometheus** for metric collection and **Grafana** for visualization and alerting. By the end of this project, you’ll have a system capable of real-time monitoring, alerting on critical events, and providing insightful dashboards. This will be presented in a way that your team can understand and replicate.

---

### **Goal**
To set up a continuous monitoring solution for your infrastructure that:
1. Collects metrics using Prometheus.
2. Visualizes metrics on Grafana dashboards.
3. Alerts on critical thresholds.
4. Is well-documented for future scalability.

---

### **Step-by-Step Implementation**

---

### **Step 1: Install Prometheus for Metric Collection**

#### **Step 1.1: Set Up a Linux Server**
- Use any cloud provider (AWS, GCP, or Azure) or an on-premises Linux server.
- Example: Launch an Ubuntu 22.04 instance.
  
#### **Step 1.2: Install Prometheus**
1. Update your server:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
2. Download and extract Prometheus:
   ```bash
   wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
   tar -xvzf prometheus-2.45.0.linux-amd64.tar.gz
   cd prometheus-2.45.0.linux-amd64
   ```
3. Move binaries to `/usr/local/bin`:
   ```bash
   sudo mv prometheus /usr/local/bin/
   sudo mv promtool /usr/local/bin/
   ```
4. Configure Prometheus:
   - Edit the `prometheus.yml` file:
     ```yaml
     global:
       scrape_interval: 15s

     scrape_configs:
       - job_name: "linux"
         static_configs:
           - targets: ["localhost:9100"]
     ```
5. Start Prometheus:
   ```bash
   ./prometheus --config.file=prometheus.yml
   ```

#### **Step 1.3: Install Node Exporter**
1. Download Node Exporter:
   ```bash
   wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
   tar -xvzf node_exporter-1.5.0.linux-amd64.tar.gz
   cd node_exporter-1.5.0.linux-amd64
   ```
2. Move the binary:
   ```bash
   sudo mv node_exporter /usr/local/bin/
   ```
3. Start Node Exporter:
   ```bash
   node_exporter &
   ```

---

### **Step 2: Create Custom Grafana Dashboards**

#### **Step 2.1: Install Grafana**
1. Add the Grafana repository:
   ```bash
   sudo apt-get install -y software-properties-common
   wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
   echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
   sudo apt-get update
   ```
2. Install Grafana:
   ```bash
   sudo apt-get install grafana -y
   ```
3. Start Grafana:
   ```bash
   sudo systemctl start grafana-server
   sudo systemctl enable grafana-server
   ```

#### **Step 2.2: Configure Grafana**
1. Access Grafana:
   - Open your browser and go to `http://<server-ip>:3000`.
   - Default login: `admin` / `admin`.
2. Add Prometheus as a data source:
   - Navigate to **Configuration > Data Sources > Add Data Source**.
   - Choose **Prometheus** and enter:
     ```
     URL: http://localhost:9090
     ```
3. Import Dashboards:
   - Navigate to **Dashboards > Import**.
   - Use a template ID from the [Grafana Dashboard Library](https://grafana.com/grafana/dashboards/).

#### **Step 2.3: Create Custom Dashboards**
1. Navigate to **Create > Dashboard**.
2. Add panels for metrics like:
   - **CPU Usage**:
     Query:
     ```promql
     rate(node_cpu_seconds_total{mode!="idle"}[5m])
     ```
   - **Memory Usage**:
     ```promql
     node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100
     ```
   - **Disk Usage**:
     ```promql
     node_filesystem_avail_bytes / node_filesystem_size_bytes * 100
     ```
3. Save the dashboard with a meaningful name (e.g., "System Health Dashboard").

---

### **Step 3: Set Up Alerts for Critical Metrics**

#### **Step 3.1: Configure Alertmanager**
1. Download Alertmanager:
   ```bash
   wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
   tar -xvzf alertmanager-0.25.0.linux-amd64.tar.gz
   cd alertmanager-0.25.0.linux-amd64
   ```
2. Configure `alertmanager.yml`:
   ```yaml
   global:
     smtp_smarthost: 'smtp.gmail.com:587'
     smtp_from: 'your-email@gmail.com'
     smtp_auth_username: 'your-email@gmail.com'
     smtp_auth_password: 'your-email-password'

   route:
     receiver: 'email-alert'

   receivers:
     - name: 'email-alert'
       email_configs:
         - to: 'recipient-email@gmail.com'
   ```
3. Start Alertmanager:
   ```bash
   ./alertmanager --config.file=alertmanager.yml
   ```

#### **Step 3.2: Add Alerts in Prometheus**
1. Add alert rules to `prometheus.yml`:
   ```yaml
   rule_files:
     - "alerts.yml"
   ```

2. Create `alerts.yml`:
   ```yaml
   groups:
   - name: node_alerts
     rules:
     - alert: HighCPUUsage
       expr: rate(node_cpu_seconds_total{mode!="idle"}[5m]) > 0.85
       for: 2m
       labels:
         severity: warning
       annotations:
         summary: "High CPU usage detected"
         description: "CPU usage is above 85% for more than 2 minutes."
   ```

3. Reload Prometheus:
   ```bash
   curl -X POST http://localhost:9090/-/reload
   ```

---

### **Step 4: Document Monitoring Setup**

1. **Write Documentation**:
   - Use markdown to document:
     - Installation steps for Prometheus, Node Exporter, and Grafana.
     - Configuration details (e.g., IPs, ports, queries).
     - Alert thresholds and actions.
     - Dashboard URLs.

2. **Create Runbooks**:
   - Include troubleshooting steps for:
     - Prometheus failures.
     - Grafana dashboard issues.
     - Alerts not being triggered.

3. **Organize Files**:
   - Create a Git repository with the following structure:
     ```
     /monitoring-project
     ├── prometheus/
     │   ├── prometheus.yml
     │   ├── alerts.yml
     ├── grafana/
     │   ├── dashboards.json
     ├── alertmanager/
     │   ├── alertmanager.yml
     └── README.md
     ```

---

### **Final Notes**

By completing this project:
- You'll demonstrate expertise in continuous monitoring and proactive alerting.
- You'll implement best practices for infrastructure observability.
- Your documentation and runbooks will ensure the system is scalable and maintainable.

Train your team by providing hands-on practice with:
1. Creating their own dashboards.
2. Configuring alerts.
3. Using and troubleshooting the system.
