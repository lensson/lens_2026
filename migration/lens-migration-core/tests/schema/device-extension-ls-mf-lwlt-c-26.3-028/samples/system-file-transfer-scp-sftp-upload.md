This macro uploads the specified file via SFTP or SCP protocol, by making use of the generated ssh-key for file transfer.
Files are organized to category:

* syslog: syslog file stored localy in the file system

Available files for uploading can be found via the macro system-file-transfer-available-upload-category-get.

The name of the uploaded compressed file will be a concatination of _category_, _timestamp_ and _compression_: category-timestamp.tar.cmp

* category: the category of the file that will be uploaded. Category can be overwritten by using filename in the URL
* timestamp: format is %Y%m%d-%H%M%S%3N
* cmp: represents the compression format and can be _gz_ or _lzo_

Format of URL: _<protocol>://host[:port][/path/]_

* protocol: sftp or scp
* host: represent the remote host server
* port: port is optional
* path: the path on the file system of host server. Note that a URL that does not end with a forward slash /
will modify the name of the final compressed file that is to be uploaded.

Pre-condition: relevant file transfer protocol is enabled and ssh-key is configured.

Input parameters:

* category-type: Define files category
* compression: Compression format, allowed values is gzip or lzop
* filename: The name of the file that will be uploaded, in case that is omitted all the files of the specifed category will be uploaded
* host-url: sftp or scp server url. Note that a URL that does not end with a forward slash / will modify the name of the final compressed file that is to be uploaded.
* ssh-key-type: Algorithm of ssh-key, allowed values is ssh-rsa, ssh-dss and ecdsa-sha2-nistp256
* username: The username that will be used

