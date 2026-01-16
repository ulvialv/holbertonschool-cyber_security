Evidence:
The server response reflected the injected Host header and generated a malicious link:

<a href="http://attacker.com/login">Try to sign in again ?</a>

This confirms that the server uses the Host header without validation.

IMPACT^ 

An attacker could exploit this vulnerability to:

Perform phishing attacks

Intercept password reset tokens

Take over user accounts

This vulnerability is especially dangerous because it affects a password reset flow.

Mitigation:

Validate and whitelist allowed Host headers

Avoid using client-controlled headers to generate absolute URLs

Use a fixed application base URL in server configuration

Conclusion:
The application is vulnerable to Host Header Injection, which can lead to serious security issues such as account takeover.
Proper validation of HTTP headers is required to prevent this vulnerability.

(Optional – Bonus Finding)
User Enumeration

The application discloses whether an email exists by returning different error messages: Email provided not found
This allows attackers to enumerate valid users.
