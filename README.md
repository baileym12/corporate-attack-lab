# **Cororate CTF Simulation: Creation Process & Security Analysis**


## **Overview**

This **Enterprise Capture The Flag Simulation** replicates a real-world, multi-stage penetration testing engagement across multiple corporate environments. The simulated enterprise includes:

1. **Pharmaceutical Company** — Web Application Exposure
2. **Shipping Server** — FTP Credential Leak & Binary Reverse Engineering
3. **Hospital Network** — SSH Access & Backup Encryption Weakness
4. **Airport Web Server** — File Upload Vulnerability → Remote Code Execution (RCE)

The primary goal was to simulate full attacker lifecycle activity, including initial access, credential harvesting, privilege escalation, lateral movement, data exfiltration, and remote code execution, while simultaneously identifying and documenting **remediation strategies** and **enterprise security controls** applicable to each scenario.


## **Project Objectives**

* Simulate realistic enterprise security weaknesses across multiple industries.
* Practice offensive penetration testing methodologies.
* Highlight and document real-world remediation techniques.
* Demonstrate an understanding of secure architecture and system hardening.


## **Key Security Competencies Demonstrated**

* **Penetration Testing Methodologies:** Reconnaissance, Exploitation, Privilege Escalation, Lateral Movement.
* **Secure Development Lifecycle:** Secrets management, secure coding, credential handling.
* **Enterprise Infrastructure Hardening:** SSH hardening, FTP deprecation, strong encryption policies.
* **Incident Response & Remediation Planning:** Detailed vulnerability analysis with actionable mitigation steps.
* **Network Security Architecture:** Segmentation, access control, defense-in-depth design.
* **Security Automation:** Continuous integration of static code analysis, secrets scanning, and system auditing.


## **Creation Process & Security Analysis**

### **1. Pharmaceutical Company - Web Application Exposure**

#### **Identified Vulnerability: Insecure Client-Side Credential Exposure**

* FTP credentials were hardcoded directly into JavaScript files on the public web application.
* No input validation or output sanitization was implemented.
* No server-side access control was enforced beyond weak credentials.


#### **Risk and Business Impact**

* **Severity:** High
* **Attack Surface:** Public Internet
* **Impact:** Credential exposure led to unauthorized access to internal file transfer services. In a real-world scenario, this could enable attackers to pivot into internal networks or exfiltrate sensitive proprietary data (e.g., pharmaceutical R\&D intellectual property).


#### **Remediation & Secure Implementation**

**Secure Development Practices:**

* Never embed credentials or sensitive information in client-side code.
* Use secure server-side authentication with session tokens.
* Leverage secrets management platforms (e.g., AWS Secrets Manager, HashiCorp Vault).

**Preventive Security Controls:**

* Implement Web Application Firewall (WAF) rules for input/output sanitization.
* Conduct automated code scanning for accidental credential exposure.
* Integrate Secure Software Development Life Cycle (SSDLC) practices with continuous security testing.


### **2. Shipping Server - FTP Exposure & Binary Credential Leakage**

#### **Identified Vulnerabilities:**

* FTP service exposed internally with weak credential enforcement.
* Binary file (`shipping_helper`) contained hardcoded SSH credentials that were recoverable via reverse engineering.

#### **Risk and Business Impact**

* **Severity:** Critical
* **Attack Surface:** Internal network, developer tools
* **Impact:** Credential leakage allowed privilege escalation and lateral movement into the hospital server network. Poor development practices resulted in static credential reuse and credential reuse across services.


#### **Remediation & Secure Implementation**

**Secure Software Development:**

* Eliminate credential storage in binaries. If unavoidable, use runtime-secured credential injection mechanisms.
* Implement ephemeral API tokens with strict expiration policies.
* Perform static binary analysis as part of CI/CD pipelines to detect hardcoded secrets.

**Infrastructure Hardening:**

* Fully deprecate FTP in favor of encrypted file transfer protocols (SFTP/FTPS).
* Enforce key-based SSH authentication with hardware-backed keys (Yubikeys, HSM).
* Disable all unused services by default ("default deny posture").



### **3. Hospital Network - Weak Backup Encryption**

#### **Identified Vulnerability: Weak Encryption & Poor Key Management**

* Encrypted backups were protected with low-entropy, dictionary-based passwords.
* Backups contained critical patient data and credentials for downstream systems.

#### **Risk and Business Impact**

* **Severity:** Critical
* **Attack Surface:** Internal network, backup storage
* **Impact:** Successful brute-force of backup encryption led to credential theft and sensitive healthcare data compromise. In a regulated environment (e.g. HIPAA), this represents a major compliance violation.


#### **Remediation & Secure Implementation**

**Encryption Standards:**

* Use strong symmetric encryption (AES-256-GCM) combined with high-entropy, randomly generated keys.
* Apply key derivation functions (PBKDF2, scrypt, Argon2) to strengthen password-derived keys.
* Maintain strict separation of encrypted data and key material.

**Backup Security Architecture:**

* Store backups in segmented, access-controlled environments (air-gapped, encrypted cloud buckets).
* Implement access logging and alerting for unauthorized backup access.
* Regularly rotate and revoke encryption keys according to a defined key management policy (NIST SP 800-57).


### **4. Airport Web Server - File Upload Vulnerability Leading to RCE**

#### **Identified Vulnerability: Unrestricted File Upload**

* Web application allowed unrestricted file uploads with no content inspection or validation.
* Attackers were able to upload malicious PHP reverse shells and execute arbitrary code on the server.

#### **Risk and Business Impact**

* **Severity:** Critical
* **Attack Surface:** Public-facing web portal
* **Impact:** Remote code execution led to full server compromise. Attackers could pivot into critical airport infrastructure, placing physical safety and operational control systems at risk.


#### **Remediation & Secure Implementation**

**Secure File Upload Architecture:**

* Whitelist specific file types and strictly validate MIME types.
* Store uploaded files outside the web root in non-executable directories.
* Use indirect object references to access uploaded files safely.
* Perform anti-malware scanning on all uploaded content.

**Application Hardening:**

* Disable dangerous PHP functions (`system`, `exec`, `passthru`, `shell_exec`) at the PHP configuration level.
* Utilize Web Application Firewalls (WAFs) to detect and block anomalous file upload behavior.
* Apply SELinux or AppArmor profiles to enforce strict system call restrictions on web server processes.



## **Future Expansion Opportunities**

* Deploy enterprise-grade **SIEM integration** to monitor all simulated attack stages (e.g., Wazuh, Splunk).
* Build a fully segmented internal network topology to enforce zero-trust principles.
* Implement full automation of system hardening and remediation via **Ansible playbooks**.
* Integrate vulnerability management tooling (e.g., Nessus, OpenVAS) for ongoing risk assessment.
* Incorporate real-time incident detection simulations using **Purple Team exercises**.

