# Keys

Keys is an iOS password management app. Users are able to store passwords and other sensitive data and access that data securely. Keys utilizes the Zero Trust framework to ensure user's data is kept secure.

### Implementation

To save passwords, the Keepass kdbx format was followed. Since there was no package for decrypting the kdbx format for swift I created my own ([KDBX](https://github.com/jerikjakobsen/kdbx)). The package encrypts and decrypts the kdbx files according to the kdbx format as well as managing the password entries. Docker was used to containerize the server as well as Redis and MongoDB. MongoDB was used to store the user information. Amazon S3 was used to keep user's password files backed up. Node and express was used to create the RESTful API server.

### To use

To use the iOS app you need to install XCode on a mac then compile the code in the 'Keys' folder. To start up the backend service, go into the 'Keys_Backend' folder and run docker compose up.