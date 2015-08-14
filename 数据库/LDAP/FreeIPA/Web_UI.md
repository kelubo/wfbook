 Web UI

Web UI is a web application for administration of FreeIPA. It has almost the same capabilities as the 'ipa' command line utility (CLI) therefore administrators can freely choose between them for performing common tasks. It is built as a JavaScript single page application. For performing its task it utilizes JSON-RPC interface to access FreeIPA's API. This approach ensures that data which are available or changes which can be performed are limited to the security context of LDAP object (user) which is mapped to an active session.

Web UI has two operation modes:

    self-service
        used for regular users
        limited interface - only information about users
        default page: user's profile
        use cases: change or view own information and reset password
    administration
        used for members of 'admins' group and users with a role assigned
        complete interface available

Contents

    1 Access point
    2 Login
    3 Password reset when expired
    4 Special pages
    5 Addition resources

Access point

Web UI's URL is https://test.example.com/ipa/ui/ where test.example.com is FreeIPA server's host name. Usually user can just write a hostname because http redirects are applied in default installation.
Login

Web UI needs an active session with authenticated user in order to work. When no or expired session is available Web UI automatically tries to re-login. First it uses Kerberos authentication. A session is establish and previously failed command is issued on success. An unauthorized dialog is displayed on failure. In such case user may try to re-login (ie. after he obtained a valid Kerberos ticket) or he can use forms-based authentication.
Password reset when expired

FreeIPA 3.0 introduced password reset functionality for expired password upon login in Web UI. Password reset form is automatically provided when logging in using expired password and forms-based authentication. Other option is to use /ipa/ui/password_reset.html special page.
Special pages

Besides the main application, UI contains several more single purpose pages.

    /ipa/ui/password_reset.html - Standalone password reset page
    /ipa/ui/login.html - Standalone login page
    /ipa/ui/logout.html - Dropzone on logout (destroying a session) from main application
    /ipa/config/unauthorized.html - Error page saying that user doesn't have a valid session. Provides links for browser configuration pages.
    /ipa/config/browserconfig.html - Page for automatic configuration of Firefox browser
    /ipa/config/ssbrowser.html - Page with configuration information for other browsers
    /ipa/migration/ - Page for completion of user migration

Addition resources

    Self-Service Password Reset