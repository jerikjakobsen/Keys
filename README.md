# CyberSafe

CyberSafe is a password management app that is available both on iOS and as a chrome extension. Users are able to store passwords and other sensitive data and access that data securely. All Data encryption is done on the user side, so the backend never sees any sensitive information.

### Implementation

To save passwords the Keepass kdbx format was followed. Since there was no package for decrypting the kdbx format for swift I created my own. The package encrypts and decrypts the kdbx files according to the kdbx format. TO create the iOS app I used swift and to create the Chrome extension I used React.

### To use

To use the iOS app you need to install XCode on a mac then compile the code in the 'Keys' folder. To use the chrome extension you must navigate to the Cybersafe folder, then add the extension to chrome as a developer.