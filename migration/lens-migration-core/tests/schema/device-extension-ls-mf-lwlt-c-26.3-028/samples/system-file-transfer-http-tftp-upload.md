This macro uploads the specified file to a TFTP or HTTP server. Files are organized to category:

* syslog: syslog file stored localy in the file system

Available files for uploading can be found via the macro system-file-transfer-available-upload-category-get.

The name of the uploaded compressed file will be a concatination of _category_, _timestamp_ and _compression_: category-timestamp.tar.cmp

* category: the category of the file that will be uploaded. Category can be overwritten by using filename in the URL
* timestamp: format is %Y%m%d-%H%M%S%3N
* cmp: represents the compression format and can be _gz_ or _lzo_

Format of URL: _<protocol>://host[:port][/path/]_

* protocol: tftp or http
* host: represent the remote host server
* port: port is optional
* path: the path on the file system of host server. Note that a URL that does not end with a forward slash /
will modify the name of the final compressed file that is to be uploaded.

Pre-condition: relevant file transfer protocol is enabled.

Input parameters:

* category-type: Define files category
* compression: Compression format, allowed values is gzip or lzop (default is gzip)
* filename: The name of the file that will be uploaded, in case that is omitted all the files of the specifed category will be uploaded
* host-url: tftp or http server url

