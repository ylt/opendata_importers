This is for importing the Ordanance Survey
 - Code-Point Open
 - OS Open Names



### Dependencies:

 - Code-Point Open and OS Open Names, these may be "ordered" (free) at https://www.ordnancesurvey.co.uk/opendatadownload/products.html
    - These files should be downloaded into this directory and extracted
 - xlsx2csv (sudo apt-get install xlsx2csv)

### Usage:
These commands generate and echo out SQL, which may be piped into mysql

./codepoint.sh | mysql -uroot -p OS
