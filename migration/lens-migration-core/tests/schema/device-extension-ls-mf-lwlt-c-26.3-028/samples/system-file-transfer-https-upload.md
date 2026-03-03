This macro uploads the specified file to a HTTPS server. Files are organized to category:

* syslog: syslog file stored localy in the file system

Available files for uploading can be found via the macro system-file-transfer-available-upload-category-get.

The name of the uploaded compressed file will be a concatination of _category_, _timestamp_ and _compression_: category-timestamp.tar.cmp

* category: the category of the file that will be uploaded. Category can be overwritten by using filename in the URL
* timestamp: format is %Y%m%d-%H%M%S%3N
* cmp: represents the compression format and can be _gz_ or _lzo_

Format of URL: _https://host[:port][/path/]_

* host: represent the ipaddres of HTTPS server
* port: port is optional (default port is 443)
* path: the path on the file system of host server. Note that a URL that does not end with a forward slash /
will modify the name of the final compressed file that is to be uploaded.

Pre-condition: pinned certificates or EST profile are configured (refer to macro-ids system-certificate-pinned-ca-edit or system-est-client-edit respectively).

Input parameters:

* category-type: Define files category
* certificate-list-name: Certificate name, based on the certificate type.
* certificate-type: Certificate type, allowed values are pinned-ca-certs pinned-server-certs or est-certificate-profile.
* compression: Compression format, allowed values is gzip or lzop (default is gzip)
* filename: The name of the file that will be uploaded, in case that is omitted all the files of the specifed category will be uploaded
* host-url: https server url

