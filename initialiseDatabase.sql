CREATE TABLE perurl (timestamp TEXT, leser INTEGER, url TEXT);
CREATE TABLE total (timestamp TEXT, leser INTEGER);
CREATE INDEX idx_perurl_timestamp ON perurl(timestamp);
CREATE INDEX idx_perurl_url ON perurl(url);
CREATE INDEX idx_perurl_timestamp_url ON perurl(timestamp, url);
CREATE INDEX idx_total_timestamp ON total(timestamp);