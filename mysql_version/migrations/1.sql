## mysqldiff 0.43
## 
## Run on Thu Sep  3 02:05:55 2015
## Options: user=root, debug=0
##
## --- file: ./logs/dbdump-2015-09-03-02:04:56.sql
## +++ file: ./logs/dbdump-2015-09-03-02:05:55.sql

ALTER TABLE Supplier ADD COLUMN supplier_phone varchar(50) COLLATE utf8_unicode_ci NOT NULL;
