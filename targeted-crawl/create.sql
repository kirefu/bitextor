
/*
CREATE USER 'paracrawl_user'@'localhost' IDENTIFIED BY 'paracrawl_password';

CREATE DATABASE paracrawl CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci';
GRANT ALL PRIVILEGES ON paracrawl.* TO 'paracrawl_user'@'localhost';

mysql -u paracrawl_user -pparacrawl_password -Dparacrawl < create.sql
mysqldump -u paracrawl_user -pparacrawl_password --databases paracrawl | xz -c > db.xz
xzcat db.xz | mysql -u paracrawl_user -pparacrawl_password -Dparacrawl
*/

DROP TABLE IF EXISTS document;
DROP TABLE IF EXISTS url;
DROP TABLE IF EXISTS link;
DROP TABLE IF EXISTS document_align;

CREATE TABLE IF NOT EXISTS document
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    mime TINYTEXT,
    lang CHAR(3),
    md5 VARCHAR(32) NOT NULL UNIQUE KEY
);

CREATE TABLE IF NOT EXISTS url
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    val TEXT,
    md5 VARCHAR(32) NOT NULL UNIQUE KEY,
    document_id INT REFERENCES document(id),
    crawl_date DATETIME
);

CREATE TABLE IF NOT EXISTS link
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    text TEXT,
    text_lang CHAR(3),
    text_en TEXT,
    hover TEXT,
    image_url TEXT,
    document_id INT NOT NULL REFERENCES document(id),
    url_id INT NOT NULL REFERENCES url(id)
);

ALTER TABLE link
   ADD CONSTRAINT UQ_link_doc_url UNIQUE (document_id, url_id)
;

CREATE TABLE IF NOT EXISTS document_align
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    document1 INT NOT NULL REFERENCES document(id),
    document2 INT NOT NULL REFERENCES document(id),
    score FLOAT
);

ALTER TABLE document_align
   ADD CONSTRAINT UQ_document_align_docs UNIQUE (document1, document2)
;
