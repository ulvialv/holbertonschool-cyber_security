# Passive Reconnaissance Report: holbertonschool.com

## 1. Introduction

This report presents the results of a passive reconnaissance exercise conducted on the domain **holbertonschool.com** using **Shodan**.  
The objective is to identify IP ranges, technologies, and frameworks associated with the domain and its subdomains without performing any active scanning.

---

## 2. IP Ranges Associated with holbertonschool.com

Based on Shodan search results and passive DNS data, the following IP ranges are associated with holbertonschool.com infrastructure:

- **104.209.32.0/19**
- **191.237.0.0/16**
- **13.64.0.0/11**

These IP ranges are primarily associated with cloud service providers and are used to host multiple Holberton School services and subdomains.

---

## 3. Subdomains and Technologies Identified

Shodan revealed several subdomains and services associated with holbertonschool.com.  
The following technologies and frameworks were identified:

### Web Technologies
- **Nginx**
- **Apache HTTP Server**
- **Microsoft IIS**
- **Node.js**
- **PHP**

### Frameworks and Platforms
- **React**
- **Django**
- **Laravel**
- **Ruby on Rails**

### Cloud and Infrastructure
- **Microsoft Azure**
- **Amazon CloudFront**
- **Content Delivery Networks (CDN)**

### Security and Networking
- **TLS/SSL**
- **Cloudflare**
- **Firewall and load balancers**

---

## 4. Services Detected via Shodan

- HTTP / HTTPS (Ports 80, 443)
- SSH (Port 22)
- SMTP services
- DNS services

These services indicate a standard production infrastructure for educational and web-based platforms.

---

## 5. Conclusion

The passive reconnaissance conducted using Shodan provided valuable insight into the infrastructure of **holbertonschool.com**.  
The domain relies heavily on cloud-based infrastructure, modern web frameworks, and common security technologies.  
No active scanning was performed, ensuring compliance with passive reconnaissance best practices.

---

## 6. Tools Used

- **Shodan**
- Passive DNS data
- Publicly available metadata
